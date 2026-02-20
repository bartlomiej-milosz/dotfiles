return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = {
    "mason-org/mason.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    local jdtls = require("jdtls")

    local function attach_jdtls()
      -- Check if jdtls is installed via Mason
      local mason_registry = require("mason-registry")
      local ok, jdtls_pkg = pcall(mason_registry.get_package, "jdtls")
      if not ok or not jdtls_pkg:is_installed() then
        vim.notify("jdtls is not installed. Run :Mason and install it.", vim.log.levels.WARN)
        return
      end

      local jdtls_install = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

      -- Platform-specific config
      local os_name = vim.uv.os_uname().sysname
      local config_dir
      if os_name == "Linux" then
        config_dir = jdtls_install .. "/config_linux"
      elseif os_name == "Darwin" then
        config_dir = jdtls_install .. "/config_mac"
      else
        config_dir = jdtls_install .. "/config_win"
      end

      local launcher = vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")
      local lombok = jdtls_install .. "/lombok.jar"

      -- Workspace directory per project
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local config = {
        cmd = {
          "java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xmx2g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          "-javaagent:" .. lombok,
          "-jar", launcher,
          "-configuration", config_dir,
          "-data", workspace_dir,
        },
        root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" }),
        capabilities = capabilities,

        settings = {
          java = {
            eclipse = { downloadSources = true },
            configuration = {
              updateBuildConfiguration = "interactive",
              -- Add your installed JDK runtimes here
              -- runtimes = {
              --     { name = "JavaSE-17", path = "/path/to/jdk-17" },
              --     { name = "JavaSE-21", path = "/path/to/jdk-21" },
              -- },
            },
            maven = { downloadSources = true },
            references = { includeDecompiled = true },
            inlayHints = {
              parameterNames = { enabled = "all" },
            },
            signatureHelp = { enabled = true },
          },
        },

        init_options = {
          bundles = {},
        },
      }

      jdtls.start_or_attach(config)
    end

    -- Attach jdtls when opening Java files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = attach_jdtls,
    })

    -- Java-specific keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "jdtls" then
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
          end

          map("n", "<leader>co", jdtls.organize_imports, "Organize Imports")
          map("n", "<leader>cv", jdtls.extract_variable_all, "Extract Variable")
          map("n", "<leader>cc", jdtls.extract_constant, "Extract Constant")
          map("x", "<leader>cm", function() jdtls.extract_method(true) end, "Extract Method")
        end
      end,
    })
  end,
}
