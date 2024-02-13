local null_ls = require "null-ls"

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.deno_fmt.with { filetypes = { "ts", "js" } },
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css", "scss" } },

  -- Lua
  b.formatting.stylua,

  -- cpp
  b.formatting.clang_format,

  -- rust
  b.formatting.rustfmt.with { extra_args = { "--edition=2021" } },

  -- python
  b.formatting.black.with { extra_args = { "--line-length", "79", "--target-version", "py311" } },
  b.formatting.ruff,
  b.diagnostics.mypy.with {
    extra_args = { "--ignore-missing-imports", "--strict-optional", "--follow-imports", "skip" },
  },
  b.formatting.isort,

  -- sql
  b.formatting.sqlfluff.with {
    extra_args = { "--dialect", "postgres" },
  },
}

null_ls.setup {
  debug = true,
  sources = sources,
}
