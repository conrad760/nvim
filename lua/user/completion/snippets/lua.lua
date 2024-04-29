local ls = require("luasnip")

local s = ls.s
local i = ls.i
local t = ls.t

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

ls.add_snippets("lua",{
    s("req", fmt("local {} = require('{}')", { i(1, "default"), rep(1)})),
    s("understand", { t("text_node"), }),
})
