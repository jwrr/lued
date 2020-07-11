-- lua.lua

lued.python = {}


-- ============================================================================


function lued.python.program()
str = [[
#!/usr/bin/python3

import sys

print ('Num args:', len(sys.argv), 'arguments.')
print ('Args:', str(sys.argv))

]]

lued.ins_str_after(str, 'print')
end


-- ============================================================================


function lued.python.func()
str = [[
sub SUBNAME {
  my ($arg1, $arg2) = @_;
}


]]

lued.ins_str_after(str, "SUBNAME")
end


-- ============================================================================


function lued.python.if_statement()
str = [[
  if ($COND) {
    
  } elsif ($COND) {
    
  } else {
    
  }

]]
lued.ins_str_after(str, "$COND")
end


-- ============================================================================


function lued.python.while_loop()
str = [[
  while COND {
  
  }
  
]]
lued.ins_str_after(str, "COND")
end


-- ============================================================================


function lued.python.for_loop()
str = [[
  for (my $i=0; $i <= MAX; $i++) {
    
  }

]]
lued.ins_str_after(str, "MAX")
end


-- ============================================================================


-- ============================================================================
-- ============================================================================

lued.filetypes.py = "python"
lued.line_comments.python = "#"

lued.python.keyword_str = string.gsub([[
False await else import pass None break except in raise True class finally is 
return and continue for lambda try as def from nonlocal while assert del 
global not with async elif if or yield 
abs delattr hash memoryview set all dict help min setattr any dir hex next 
slice ascii divmod id object sorted bin enumerate input oct staticmethod bool 
eval int open str breakpoint exec isinstance ord sum bytearray filter 
issubclass pow super bytes float iter print tuple callable format len property 
type chr frozenset list range vars classmethod getattr locals repr zip compile 
globals map reversed __import__ complex hasattr max round
]] , "%s+", "\n") 


lued.keywords.python = lued.explode_keys(lued.python.keyword_str)

local s = {}
lued.def_snippet(s, "python  !"        , lued.python.program)
lued.def_snippet(s, "sub function func"   , lued.python.func)
lued.def_snippet(s, "if"           , lued.python.if_statement)
lued.def_snippet(s, "while wh"         , lued.python.while_loop)
lued.def_snippet(s, "for"              , lued.python.for_loop)
lued.snippets.python = s



