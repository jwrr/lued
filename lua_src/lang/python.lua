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


function lued.python.class()
str = [[

# ==============================================================================

class ClassName:
    "description"
    var1 = 42

    def __init__(self, x=0, y=0):
        "Constructor"
        self.x = x
        self.y = y
        
    def __str__(self):
        "Standard print statement"
        "({},{})".format(self.x, self.y)

    def meth1(self):
        "Just a method"
        print("hi")
        return self.x + self.y

# ==============================================================================

class_instance = ClassName()

]]

lued.ins_str_after(str, 'ClassName')
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
for i in range(10):
]]
lued.ins_str_after(str, "10")
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
lued.def_snippet(s, "python  !"          , lued.python.program)
lued.def_snippet(s, "class"              , lued.python.class)
lued.def_snippet(s, "sub function func"  , lued.python.func)
lued.def_snippet(s, "if"                 , lued.python.if_statement)
lued.def_snippet(s, "while wh"           , lued.python.while_loop)
lued.def_snippet(s, "for"                , lued.python.for_loop)
lued.snippets.python = s



