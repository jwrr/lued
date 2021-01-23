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

local keyword_str = string.gsub([[
 and break do else elseif end 
 false for function goto if in 
 local nil not or repeat return 
 then true until while 
 __index _G
 + - * / % ^ # 
 & ~ | << >> // 
 == ~= <= >= < > = 
 :: ; : , . .. ... 
assert collectgarbage dofile error gcinfo getfenv getmetatable ipairs load
loadfile loadlib loadstring module next pairs pcall print rawequal rawget
rawset require select setfenv setmetatable tonumber tostring type unpack
xpcall bc.add bc.compare bc.digits bc.div bc.divmod bc.isneg bc.iszero
bc.mod bc.mul bc.neg bc.number bc.pow bc.powmod bc.sqrt bc.sub bc.tonumber
bc.tostring bc.trunc bc.version bit.ashr bit.band bit.bor bit.clear bit.mod
bit.neg bit.shl bit.shr bit.test bit.tonumber bit.tostring bit.xor
coroutine.create coroutine.resume coroutine.running coroutine.status
coroutine.wrap coroutine.yield debug.debug debug.getfenv debug.gethook
debug.getinfo debug.getlocal debug.getmetatable debug.getregistry
debug.getupvalue debug.setfenv debug.sethook debug.setlocal
debug.setmetatable debug.setupvalue debug.traceback :close :flush :lines
:read :seek :setvbuf :write io.close io.flush io.input io.lines
io.open io.output io.popen io.read io.stderr io.stdin io.stdout
io.tmpfile io.type io.write math.abs math.acos math.asin math.atan
math.atan2 math.ceil math.cos math.cosh math.deg math.exp math.floor
math.fmod math.frexp math.huge math.ldexp math.log math.max math.min
math.modf math.pi math.pow math.rad math.random math.randomseed math.sin
math.sinh math.sqrt math.tan math.tanh os.clock os.date os.difftime
os.execute os.exit os.getenv os.remove os.rename os.setlocale os.time
os.tmpname package.config package.cpath package.loaded package.loaders
package.loadlib package.path package.preload package.seeall re:exec
re:gmatch re:match rex.flags rex.new string.byte string.char string.ends
string.find string.format string.gmatch string.gsub string.len string.lower
string.match string.rep string.reverse string.starts string.sub
]] , "%s+", "\n") 


lued.keywords.lua = lued.explode_keys(keyword_str)

local s = {}
lued.def_snippet(s, "lua !"        , lued.lua.program)
lued.def_snippet(s, "function func"   , lued.lua.func)
lued.def_snippet(s, "if"           , lued.lua.if_statement)
lued.def_snippet(s, "while wh"         , lued.lua.while_loop)
lued.def_snippet(s, "for"              , lued.lua.for_loop)
lued.def_snippet(s, "repeat re"        , lued.lua.repeat_loop)
lued.snippets.lua = s



