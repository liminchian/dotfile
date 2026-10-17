-- 位置：~/.config/nvim-pair/lua/plugins/init.lua
-- pair 模式：AI 只在這裡

return {
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Claude Code 整合：使用 Claude Pro 訂閱登入，不需要 API key
  -- 前置：安裝 claude CLI 並執行一次 `claude` 登入 Pro 帳號
  -- 注意：環境中不要設定 ANTHROPIC_API_KEY，否則會改用 API 計費
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSend",
      "ClaudeCodeAdd",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
    },
    opts = {
      terminal = {
        split_side = "right",
        split_width_percentage = 0.38,
      },
    },
  },

  -- 依目錄存/還原 session（開過的檔案、視窗配置）
  {
    "folke/persistence.nvim",
    lazy = false,
    opts = { need = 1, branch = true },
  },
}
