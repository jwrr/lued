-- lua.lua

lued.cpp = {}

-- ============================================================================


function lued.cpp.program()
str = [[
#include <iostream>
#include <string>
#include <vector>

using namespace std;

int main(int argc, char *argv[])
{
    vector<int> vec;
    string name = "Linus";
    string action = " loves C++";
  
    cout << name << action << endl;
    
    for (int i=0; i< 10; ++i) {
        vec.push_back(i);
    }
    
    cout << "size = " << vec.size() << endl;
     
    for (auto& it : vec) {
        cout << it << endl;
    } 

    return 0;
}

]]

lued.ins_str_after(str, 'print("Hello World\n");')
end


-- ============================================================================


function lued.cpp.func()
str = [[
void NAME()
{
  
}

]]

lued.ins_str_after(str, "NAME")
end


-- ============================================================================


function remove_extension(filename)
  local newname = string.gsub(filename, "%..*", "")
  return newname
end


function ucfirst(s)
  local firstchar = string.sub(s, 1, 1)
  return string.gsub(s, "^" .. firstchar, string.upper(firstchar))
end

function lued.cpp.class()
local filename = lued.get_filename()
local basename = remove_extension(filename)
local basename_uc = string.upper(basename)
local guardname = "_" .. basename_uc .. "_H_"
local classname = ucfirst(basename)

str = [[
// ================================================
// ]] .. basename .. [[.h
 
#ifndef ]] .. guardname .. [[

#define ]] .. guardname .. [[


#include <iostream>
#include <string>
#include <vector>

using namespace std; 

class ]] .. classname  .. [[

{
private:
  string  name_{"Rudolf"};
  int     class_variable_{37};
  
public:
  int MethodName();
};

#endif // ]] .. guardname .. [[


// ================================================

int ]] .. classname .. [[::MethodName()

{
  int local_variable_name{5};
  return local_variable_name + class_variable_;
} 


int main()
{
  ]] .. classname .. [[ obj1;
  
  cout << obj1.MethodName() << endl;
  
  return 0;
}

]]

lued.ins_str_after(str, "class")
lued.find_forward(classname)
end


-- ============================================================================


function lued.cpp.typedef()
str = [[
typedef struct {
  int x, y;
} NAME_t;

]]

lued.ins_str_after(str, "NAME")
end


-- ============================================================================


function lued.cpp.if_statement()
str = [[
  if (COND) {
    
  } else if (COND) {
    
  } else {
    
  }

]]
lued.ins_str_after(str, "COND")
end


-- ============================================================================


function lued.cpp.if_statement()
str = [[
  if (COND) {
    
  } else if (COND) {
    
  } else {
    
  }

]]
lued.ins_str_after(str, "COND")
end


-- ============================================================================


function lued.cpp.switch_statement()
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


function lued.cpp.while_loop()
str = [[
  while (COND) {
     
  }
  
]]
lued.ins_str_after(str, "COND")
end


-- ============================================================================


function lued.cpp.for_loop()
str = [[
  for (int i=0; i < MAX; i++) {
    
  }

]]
lued.ins_str_after(str, "MAX")
end


-- ============================================================================


-- ============================================================================
-- ============================================================================


lued.filetypes.cpp = "cpp"
lued.line_comments.cpp = "//"

lued.cpp.keyword_str = string.gsub([[
auto break case char const continue default do double else enum extern float
for goto if inline int long register restrict return short signed sizeof
static struct switch typedef union unsigned void volatile while
_Alignas _Alignof  _Atomic _Bool _Complex _Generic _Imaginary _Noreturn  
_Static_assert _Thread_local   
if elif else endif defined ifdef ifndef define undef include line error
pragma
]] , "%s+", "\n") 


lued.keywords.cpp = lued.explode_keys(lued.cpp.keyword_str)

local s = {}
lued.def_snippet(s, "cpp main !"   , lued.cpp.program)
lued.def_snippet(s, "func"         , lued.cpp.func)
lued.def_snippet(s, "if"           , lued.cpp.if_statement)
lued.def_snippet(s, "switch case"  , lued.cpp.switch_statement)
lued.def_snippet(s, "while"        , lued.cpp.while_loop)
lued.def_snippet(s, "for"          , lued.cpp.for_loop)
lued.def_snippet(s, "type struct"  , lued.cpp.typedef)
lued.def_snippet(s, "class"        , lued.cpp.class)
lued.snippets.cpp = s



