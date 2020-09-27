-- lua.lua

lued.clang = {}


-- ============================================================================


function lued.clang.program()
str = [[
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
  int x;
  printf("hello\n");
  return 0;
}

]]

lued.ins_str_after(str, 'print("Hello World\n");')
end


-- ============================================================================


function lued.clang.func()
str = [[
void NAME()
{
  
}

]]

lued.ins_str_after(str, "NAME")
end


-- ============================================================================


function lued.clang.typedef()
str = [[
typedef struct {
  int x, y;
} NAME_t;

]]

lued.ins_str_after(str, "NAME")
end


-- ============================================================================


function lued.clang.if_statement()
str = [[
  if (COND) {
    
  } else if (COND) {
    
  } else {
    
  }

]]
lued.ins_str_after(str, "COND")
end


-- ============================================================================


function lued.clang.if_statement()
str = [[
  if (COND) {
    
  } else if (COND) {
    
  } else {
    
  }

]]
lued.ins_str_after(str, "COND")
end


-- ============================================================================


function lued.clang.switch_statement()
str = [[
  switch (ch) {
  case 'a':
    aflag = 1;
    break;
  case 'b':
    bflag = 1;
    /* FALLTHROUGH */
  default:
    xflag = 1;
  }

]]
lued.ins_str_after(str, "COND")
end


-- ============================================================================


function lued.clang.while_loop()
str = [[
  while (COND) {
     
  }
  
]]
lued.ins_str_after(str, "COND")
end


-- ============================================================================


function lued.clang.for_loop()
str = [[
  for (int i=0; i < MAX; i++) {
    
  }

]]
lued.ins_str_after(str, "MAX")
end


-- ============================================================================


-- ============================================================================
-- ============================================================================


lued.filetypes.c = "clang"
lued.line_comments.clang = "//"

lued.clang.keyword_str = string.gsub([[
auto break case char const continue default do double else enum extern float
for goto if inline int long register restrict return short signed sizeof
static struct switch typedef union unsigned void volatile while
_Alignas _Alignof  _Atomic _Bool _Complex _Generic _Imaginary _Noreturn  
_Static_assert _Thread_local   
if elif else endif defined ifdef ifndef define undef include line error
pragma
]] , "%s+", "\n") 


lued.keywords.clang = lued.explode_keys(lued.clang.keyword_str)

local s = {}
lued.def_snippet(s, "clang  !"        , lued.clang.program)
lued.def_snippet(s, "func"            , lued.clang.func)
lued.def_snippet(s, "if"              , lued.clang.if_statement)
lued.def_snippet(s, "switch case"     , lued.clang.switch_statement)
lued.def_snippet(s, "while wh"        , lued.clang.while_loop)
lued.def_snippet(s, "for"             , lued.clang.for_loop)
lued.def_snippet(s, "type struct"     , lued.clang.typedef)
lued.snippets.clang = s



