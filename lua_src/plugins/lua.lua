-- lua.lua

lued.lua = {}


-- ============================================================================


function lued.lua.program()
str = [[
-- lua program

CODE
]]

lued.ins_str_after(str, "CODE")
end


-- ============================================================================


function lued.lua.func()
str = [[

function FNAME()
  
end

]]

lued.ins_str_after(str, "FNAME")
end


-- ============================================================================


function lued.lua.if_statement()
str = [[
  if COND then

  elseif
  else
  end
]]
lued.ins_str_after(str, "COND")
end


-- ============================================================================


function lued.lua.while_loop()
str = [[
  while COND do

  end
]]
lued.ins_str_after(str, "COND")
end


-- ============================================================================


function lued.lua.for_loop()
str = [[
  for i=1,NNN do

  end
]]
lued.ins_str_after(str, "NNN")
end


-- ============================================================================


function lued.lua.repeat_loop()
str = [[
  repeat
    
  until COND
]]
lued.ins_str_after(str, "COND")

end



-- ============================================================================


-- ============================================================================


lued.filetypes.lua = "lua"
lued.line_comments.lua = "--"

local s = {}
lued.def_snippet(s, "lua !"            , lued.lua.program)
lued.def_snippet(s, "function func"    , lued.lua.func)
lued.def_snippet(s, "if"               , lued.lua.if_statement)
lued.def_snippet(s, "while wh"         , lued.lua.while_loop)
lued.def_snippet(s, "for"              , lued.lua.for_loop)
lued.def_snippet(s, "repeat re"        , lued.lua.repeat_loop)
lued.snippets.lua = s



