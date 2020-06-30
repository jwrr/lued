-- lua.lua

lued.perl = {}


-- ============================================================================


function lued.perl.program()
str = [[
#!/usr/bin/perl 
use strict;
use warnings;
use POSIX;

my ($first, $last) = @ARGV;
die("Format: $0 [first] [last]") if not defined $first;
$last = "" if not defined $last;

print("Hello $first $last\n"); 
]]

lued.ins_str_after(str, 'print("Hello World\n");')
end


-- ============================================================================


function lued.perl.func()
str = [[
sub SUBNAME {
  my ($arg1, $arg2) = @_;
}


]]

lued.ins_str_after(str, "SUBNAME")
end


-- ============================================================================


function lued.perl.if_statement()
str = [[
  if ($COND) {
    
  } elsif ($COND) {
    
  } else {
    
  }

]]
lued.ins_str_after(str, "$COND")
end


-- ============================================================================


function lued.perl.while_loop()
str = [[
  while COND {
  
  }
  
]]
lued.ins_str_after(str, "COND")
end


-- ============================================================================


function lued.perl.for_loop()
str = [[
  for (my $i=0; $i <= MAX; $i++) {
    
  }

]]
lued.ins_str_after(str, "MAX")
end


-- ============================================================================


-- ============================================================================
-- ============================================================================


lued.filetypes.pl = "perl"
lued.line_comments.perl = "#"

local keyword_str = string.gsub([[
__DATA__ 	else 	lock 	qw
__END__ 	elsif 	lt 	qx
__FILE__ 	eq 	m 	s
__LINE__ 	exp 	ne 	sub
__PACKAGE__ 	for 	no 	tr
and 	foreach 	or 	unless
cmp 	ge 	package 	until
continue 	gt 	q 	while
CORE 	if 	qq 	xor
do 	le 	qr 	y
]] , "%s+", "\n") 


lued.keywords.perl = lued.explode_keys(keyword_str)

local s = {}
lued.def_snippet(s, "perl  !"        , lued.perl.program)
lued.def_snippet(s, "sub function func"   , lued.perl.func)
lued.def_snippet(s, "if"           , lued.perl.if_statement)
lued.def_snippet(s, "while wh"         , lued.perl.while_loop)
lued.def_snippet(s, "for"              , lued.perl.for_loop)
lued.snippets.perl = s



