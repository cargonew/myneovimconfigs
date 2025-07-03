local jdtls = require("jdtls")

-- Determine the workspace directory based on current folder name
local home = os.getenv("HOME")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = home .. "/.local/share/eclipse/" .. project_name

-- Determine root of project (important!)
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)

if not root_dir then
  print("jdtls: Could not find project root. Java LSP won't start.")
  return
end

-- Set up JDTLS config
local config = {
  cmd = { "jdtls" },
  root_dir = root_dir,
  settings = {
    java = {
      format = {
        enabled = true,
      },
    },
  },
  init_options = {
    bundles = {},
  },
}

-- Start or attach to the LSP
jdtls.start_or_attach(config)

