local snip_status_ok, ls = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

return {

  -- const
  s({ trig = "const", name = "Constant", dscr = "Insert a constant" }, {
    t("const "), i(1, "name"), t(" = "), i(2, "value")
  }),

  -- prints
  s({ trig = "pf", name = "Formatted Print", dscr = "Insert a formatted print statement" }, {
    t("fmt.Printf(\"%#v\\n\", "), i(1, "value"), t(")")
  }),

  -- errors
  parse({ trig = "ife", name = "If Err", dscr = "Insert a basic if err not nil statement" }, [[
  if err != nil {
    return err
  }
  ]]),

  parse({ trig = "ifel", name = "If Err Log Fatal", dscr = "Insert a basic if err not nil statement with log.Fatal" }, [[
  if err != nil {
    log.Fatal(err)
  }
  ]]),

  s({ trig = "ifew", name = "If Err Wrapped", dscr = "Insert a if err not nil statement with wrapped error" }, {
    t("if err != nil {"),
    t({ "", "  return fmt.Errorf(\"failed to " }),
    i(1, "message"),
    t(": %w\", err)"),
    t({ "", "}" })
  }),

  parse({ trig = "main", name = "Main Package", dscr = "Basic main package structure" }, [[
  package main

  import "fmt"

  func main() {
    fmt.Printf("%+v\n", "...")
  }
  ]]),

  -- For loops
  s({ trig = "for", name = "for range", desc = "for types" },
    c(1, {
      fmt([[
  for {},{} := range {} {{
    {}
  }}]],
        { i(1, "_"), i(2, "v"), i(3, "thing"), i(4) }),
      fmt([[
  for {} := {} ; {} {} {} ; {}{} {{
    {}
  }}]],
        { i(1, "i"), i(2, "0"), rep(1), i(3, "<"), i(4, "len(nums)"), rep(1), i(5, "++"), i(6) })
    })
  ),

  -- Funcs
  s({ trig = "func", name = "func", desc = "function or method" },
    c(1, {
      fmt([[
  // {} {}
  func {}({}) {} {{
    {}
    return
  }}]],
      { rep(1), i(4), i(1,"funcName"), i(2), i(3,"returnType"), i(5) }),
      fmt([[
  // {} {}
  func ({}) {}({}) {} {{
    {}
    return
  }}]], { rep(2), i(6), i(1), i(2,"MethodName"), i(3), i(4), i(5), })
  })),
}
