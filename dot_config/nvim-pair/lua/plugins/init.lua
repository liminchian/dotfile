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

  -- Claude Code 整合：只當 IDE 橋接（diff、送檔案/選取），Claude 本體跑在 herdr 的 pane 裡
  -- 在 herdr 裡執行 `claude --ide` 就會連回這個 Neovim
  -- 注意：環境中不要設定 ANTHROPIC_API_KEY，否則會改用 API 計費
  {
    "coder/claudecode.nvim",
    lazy = false, -- 要先啟動 server，herdr 裡的 claude 才連得到
    opts = { terminal = { provider = "none" } },
  },

  -- herdr 用 snacks.terminal 開在主視窗（見 agents.lua）
  { "folke/snacks.nvim" },

  -- 依目錄存/還原 session（開過的檔案、視窗配置）
  {
    "folke/persistence.nvim",
    lazy = false,
    opts = { need = 1, branch = true },
  },
}
