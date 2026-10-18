-- 位置：~/.config/nvim-think/lua/zedkeys.lua
--      ~/.config/nvim-pair/lua/zedkeys.lua（兩邊同一份）
-- Zed 風格的程式碼導航與 LSP 快捷鍵，兩個模式共用（這些不是 AI 功能）
--
-- Zed vim mode 的鍵：
--   gd 定義      gD 宣告      gy 型別定義   gI 實作
--   gA 所有引用  g. Code Action  gh Hover   cd 重新命名
--   gs 檔案內符號  gS 專案符號  ]d [d 下/上一個診斷  ]e [e 只跳錯誤
-- Zed 預設鍵：
--   Ctrl+. Code Action   F2 重新命名   F12 定義   Shift+F12 引用
--   Ctrl+Shift+M 診斷清單
-- <leader>c 群組（Code）：
--   ca Code Action  cr 重新命名  cf 格式化  cd 這一行的診斷
--   cD 專案診斷     cx 目前檔案診斷  cs 檔案符號  cS 專案符號
--   cR 引用         cl 開關 inlay hints

local M = {}

local function tb(name, opts)
  return function()
    require("telescope.builtin")[name](opts or {})
  end
end

local function jump(count, severity)
  return function()
    vim.diagnostic.jump { count = count, float = true, severity = severity }
  end
end

local function lsp_keys(buf)
  local map = vim.keymap.set
  local lsp = vim.lsp.buf
  local function o(desc)
    return { buffer = buf, desc = desc }
  end

  -- Zed vim mode
  map("n", "gd", tb "lsp_definitions", o "Go to definition")
  map("n", "gD", lsp.declaration, o "Go to declaration")
  map("n", "gy", tb "lsp_type_definitions", o "Go to type definition")
  map("n", "gI", tb "lsp_implementations", o "Go to implementation")
  map("n", "gA", tb "lsp_references", o "Find all references")
  map({ "n", "x" }, "g.", lsp.code_action, o "Code actions")
  map("n", "gh", lsp.hover, o "Hover")
  map("n", "cd", lsp.rename, o "Rename symbol")
  map("n", "gs", tb "lsp_document_symbols", o "Document symbols")
  map("n", "gS", tb "lsp_dynamic_workspace_symbols", o "Project symbols")

  -- Zed 預設鍵（Neovide 能辨識這些組合）
  map({ "n", "x", "i" }, "<C-.>", lsp.code_action, o "Code actions")
  map("n", "<F2>", lsp.rename, o "Rename symbol")
  map("n", "<F12>", tb "lsp_definitions", o "Go to definition")
  map("n", "<S-F12>", tb "lsp_references", o "Find all references")

  -- <leader>c
  map({ "n", "x" }, "<leader>ca", lsp.code_action, o "Code action")
  map("n", "<leader>cr", lsp.rename, o "Rename symbol")
  map("n", "<leader>cs", tb "lsp_document_symbols", o "Document symbols")
  map("n", "<leader>cS", tb "lsp_dynamic_workspace_symbols", o "Workspace symbols")
  map("n", "<leader>cR", tb "lsp_references", o "References")
  map("n", "<leader>cl", function()
    local on = vim.lsp.inlay_hint.is_enabled { bufnr = buf }
    vim.lsp.inlay_hint.enable(not on, { bufnr = buf })
  end, o "Toggle inlay hints")
end

function M.setup()
  local map = vim.keymap.set

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("ZedLspKeys", { clear = true }),
    callback = function(ev)
      -- 延後一步，蓋過 NvChad on_attach 設定的同名按鍵（gd、gD 等）
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(ev.buf) then
          lsp_keys(ev.buf)
        end
      end)
    end,
  })

  -- 不需要 LSP 的部分
  map({ "n", "x" }, "<leader>cf", function()
    require("conform").format { lsp_format = "fallback" }
  end, { desc = "Format" })
  map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
  map("n", "<leader>cD", tb "diagnostics", { desc = "Project diagnostics" })
  map("n", "<leader>cx", tb("diagnostics", { bufnr = 0 }), { desc = "Buffer diagnostics" })
  map("n", "<C-S-m>", tb "diagnostics", { desc = "Diagnostics panel" })

  map("n", "]d", jump(1), { desc = "Next diagnostic" })
  map("n", "[d", jump(-1), { desc = "Prev diagnostic" })
  map("n", "]e", jump(1, vim.diagnostic.severity.ERROR), { desc = "Next error" })
  map("n", "[e", jump(-1, vim.diagnostic.severity.ERROR), { desc = "Prev error" })
end

return M
