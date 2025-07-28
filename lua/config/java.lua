print("📡 Loading Java LSP config...")

local jdtls = require("jdtls")

local home = os.getenv("HOME")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = home .. "/.local/share/eclipse/" .. project_name

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)

if not root_dir then
  print("❌ jdtls: Could not find project root.")
  return
else
  print("✅ jdtls: Root found at " .. root_dir)
end

local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)

local config = {
  cmd = { "jdtls" },
  root_dir = root_dir,
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    print("🎯 Java LSP attached.")
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
    vim.defer_fn(function()
      vim.cmd("syntax enable")
      vim.cmd("TSBufEnable highlight")
    end, 100)
  end,
  settings = { java = {} },
  init_options = { bundles = {} },
}

jdtls.start_or_attach(config)

