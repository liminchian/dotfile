-- 位置：~/.config/nvim-think/lua/plugins/init.lua
-- think 模式：AI 只在右側面板（Claude Code / Copilot，見 agents.lua）

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

  -- 補全不自動跳出，需要時按 <C-Space> 手動呼叫
  {
    "hrsh7th/nvim-cmp",
    opts = {
      completion = { autocomplete = false },
    },
  },

  -- Zed 式浮動 command palette
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      cmdline = { view = "cmdline_popup" },
      lsp = {
        -- NvChad 已處理 hover / signature，避免衝突
        hover = { enabled = false },
        signature = { enabled = false },
      },
      presets = {
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
  },

  -- 置中排版的專注模式
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = { width = 100 },
    },
  },

  -- Claude Code 面板（右側，snacks.terminal）
  -- 注意：環境中不要設定 ANTHROPIC_API_KEY，否則會改用 API 計費
  {
    "coder/claudecode.nvim",
    cmd = { "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeAdd", "ClaudeCodeSend", "ClaudeCodeDiffAccept", "ClaudeCodeDiffDeny" },
    dependencies = { "folke/snacks.nvim" },
    opts = { terminal = { split_side = "right", split_width_percentage = 0.38 } },
  },

  -- Copilot CLI 面板也用 snacks.terminal（見 agents.lua）
  { "folke/snacks.nvim" },

  -- 依目錄存/還原 session（開過的檔案、視窗配置）
  {
    "folke/persistence.nvim",
    lazy = false,
    opts = { need = 1, branch = true },
  },
}
