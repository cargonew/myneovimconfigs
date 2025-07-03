require("config.lazy")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.fillchars:append({ eob = " " })


-- Set background to dark and make it transparent
vim.opt.background = "dark"
vim.cmd("hi Normal ctermbg=NONE guibg=NONE")
vim.cmd("hi VertSplit ctermbg=NONE guibg=NONE")

-- Fix tab spacing to 4 spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true


-- Java LSP loader
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    require("config.java")
  end,
})

vim.diagnostic.config({
  virtual_text = true,   -- Show inline error messages
  signs = true,          -- Gutter signs (like red >)
  underline = true,      -- Underline errors
  update_in_insert = false,
  severity_sort = true,
})
-- Enable full diagnostic display
vim.diagnostic.config({
  virtual_text = true,  -- Show messages inline next to code
  signs = true,         -- Show signs in the gutter
  underline = true,     -- Underline the problem lines
  update_in_insert = false,
  severity_sort = true,
})

-- Optional: keybinding to see the diagnostic message in a popup
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show error message" })



-- Get the center line of the screen
local center_cursor = function()
  local height = vim.api.nvim_win_get_height(0)
  local center = math.floor(height / 2)
  vim.opt.scrolloff = center
end

-- Set scrolloff to center of screen on startup and on resize
vim.api.nvim_create_autocmd({ "VimResized", "WinEnter" }, {
  callback = center_cursor,
})

-- Run once on launch
center_cursor()


vim.api.nvim_create_user_command("ToggleCenterPin", function()
  if vim.opt.scrolloff:get() > 0 then
    vim.opt.scrolloff = 0
  else
    center_cursor()
  end
end, {})


-- Compile & run current file in terminal below
vim.keymap.set("n", "<leader>rr", function()
  local file = vim.fn.expand("%:p")
  local ext = vim.fn.expand("%:e")

  local cmd = ""

  if ext == "c" then
    cmd = string.format("gcc '%s' -o /tmp/a.out && /tmp/a.out", file)
  elseif ext == "cpp" then
    cmd = string.format("g++ '%s' -o /tmp/a.out && /tmp/a.out", file)
  elseif ext == "py" then
    cmd = string.format("python3 '%s'", file)
  elseif ext == "rs" then
    cmd = "cargo run"
  elseif ext == "java" then
    cmd = string.format("javac '%s' && java %s", file, vim.fn.expand("%:t:r"))
  else
    vim.notify("Unsupported filetype: " .. ext)
    return
  end

  vim.cmd("belowright split | terminal " .. cmd)
end, { desc = "Compile and run file" })

