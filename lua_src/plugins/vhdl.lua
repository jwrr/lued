
-- vhdl.lua - plugin for lued text editor

lued.vhdl = {}
lued.filetypes.vhdl = "vhdl"
lued.filetypes.vhd  = "vhdl"
lued.line_comments.vhdl = "--"

local keyword_str = string.gsub([[
abs configuration impure null rem type access constant in of report unaffected
after disconnect inertial on return units alias downto inout open rol until
all else is or ror use and elsif label others select variable architecture 
end library out severity wait array entity linkage package signal when assert 
exit literal port shared while attribute file loop postponed sla with begin 
for map procedure sll xnor block function mod process sra xor body generate 
nand pure srl buffer generic new range subtype bus group next record then 
case guarded nor register to component if not reject transport
]] , "%s+", " ")

lued.keywords.vhdl = lued.explode_keys(keyword_str, " ")


-- =============================================================================
-- =============================================================================
-- lued.vhdl.sig_from_entity converts a vhdl entity into signals and constants.
-- The entity's generics are converted to constants
-- The entity's ports are converted to signals.
-- Typical usage is to cut/paste a copy of the entity. Then move to the first line
-- of the copy and type esc+lued.vhdl.sig_from_entity. This should have converted the generics and
-- ports to constants and signals.

function lued.vhdl.sig_from_entity()
  local dd2 = 1
  local r1,c1 = lued.get_cur_pos()
  lued.find_forward("end",dd2)
  local r2,c2 = lued.get_cur_pos()

  for r=r1,r2 do
    lued.set_cur_pos(r,1)
    local line = lued.get_line()
    lowerline = string.lower(line)

    -- Insert semicolon if missing
    if string.find(line, ":") then
      if string.find(line, ";") == nil then
        line = string.gsub(line," *[-][-]","; --")
        if string.find(line, ";") == nil then
          line = line .. ";"
        end
      end
    end

    if string.find(lowerline, ":=") then -- constant
      lued.del_eol(dd2)
      lued.ins_str(line,dd2)
      lued.move_to_sol_classic(dd2)
      if lued.is_space() then lued.skip_spaces_right(dd2); end
      lued.ins_str("constant ",dd2)
    elseif string.find(lowerline, ":") then -- signal
      if string.find(lowerline, "inout") then
        line = string.gsub(line, "inout%s*", "")
        line = line .. " -- inout"
      elseif string.find(lowerline, "out") then
        line = string.gsub(line, "out%s*", "")
        line = line .. " -- out"
      elseif string.find(lowerline, "in") then
        line = string.gsub(line, "in%s*", "")
        line = string.gsub(line, ";", "")
        if string.find(lowerline,"std_logic_vector") then
          line = line .. " := (others => '0'); -- in"
        elseif string.find(lowerline,"std_logic") then
          line = line .. " := '0'; -- in"
        else
          line = line .. "; -- in"
        end
      end
      lued.del_eol(dd2)
      lued.ins_str(line,dd2)
      lued.move_to_sol_classic(dd2)
      if lued.is_space() then lued.skip_spaces_right(dd2); end
      lued.ins_str("signal ",dd2)
    else
      if not lued.is_eol() then lued.del_eol(dd2) end
    end
  end -- for
  lued.set_cur_pos(r1+1,1)
  lued.disp(dd)
end -- lued.vhdl.sig_from_entity

-- =============================================================================
-- =============================================================================

--[[
  vhdl_inst
--]]

-- Instantiates VHDL entity.
--   1. Copy+paste the entity
--   2. Place cursor on the entity line.
--   3. Type esc+vhdl_inst.  This should change the line to u_...
--   4. Start pressing <Enter>.  This should walk through correcting each line of the entity.
--   5. Move cursor to the first port and move the => to a good column and -- to a good column
--   6. Select all of the ports
--   7. Type Alt-aa and enter = at the prompt. This should align all of the =>.
--   8. Type Alt-aa and enter -- at the prompt.  This should align alll of the -- comments.

function lued.vhdl.sel_entity(dd)
  local dd2=1
  local save_find_whole_word = lued.get_find_whole_word()
  lued.set_find_whole_word()
  lued.move_up_n_lines(1,dd2)
  lued.find_forward("entity",dd2)
  lued.set_nameless_mark(dd2)
  lued.find_forward("end",dd2)
  if not lued.save_find_whole_word then
    lued.clr_find_whole_word(dd2)
  end
  lued.move_down(dd2)
  lued.sel_mark_to_cursor(dd2)
  lued.disp(dd)
end

function lued.vhdl.inst_from_entity(dd)
  local dd2 = 1
  
  local r1,c1 = lued.get_cur_pos()
  local save_find_whole_word = lued.get_find_whole_word()
  lued.set_find_whole_word()
  lued.find_forward("end",dd2)
  local r2,c2 = lued.get_cur_pos()

  for r=r1,r2 do
    lued.set_cur_pos(r,1)

    local line = lued.get_line()
    local newline = {}
  
    local next_line = lued.get_next_line() or "" -- peek ahead for close paren
    local paren_start = string.find(next_line, "^%s*%)%s*;",1) or 0
    local comma = (paren_start==0) and "," or " "
  
    local name = string.gsub(line, "^%s*([_%w]+).*", "%1")
    local padlen = math.max(14 - #name, 0)
    local pad = string.rep(' ',padlen)
  
    -- entity xxx is
    newline[1] = string.gsub(line, "^%s*entity%s+([_%w]+)%s+is", "  u_%1: entity work.%1")
    newline[1] = string.gsub(newline[1], "^%s*ENTITY%s+([_%w]+)%s+is", "  u_%1: ENTITY work.%1")
  
    -- generic (
    newline[2] = string.gsub(line, "^%s*generic.*", "  generic map (")
    newline[2] = string.gsub(newline[2], "^%s*GENERIC.*", "  GENERIC MAP (")
  
    -- WIDTH : integer := 1024;
    newline[3] = string.gsub(line, "^%s*([_%w]+).*[:]=.*", "    %1"..pad.."=> %1"..comma)
  
    -- port (
    newline[4] = string.gsub(line, "^%s*port.*", "  port map (")
    newline[4] = string.gsub(newline[4], "^%s*PORT.*", "  PORT MAP (")
  
    -- clk: in std_logic;
    newline[5] = string.gsub(line, "^%s*([_%w]+)%s*:%s*(%w%w.)%s*(std_logic[^;]*)", "    %1"..pad.."=> %1"..comma..pad.."  -- %2 %3")
  
    -- );
    newline[6] = string.gsub(line, "^%s*[)];.*", "  )")
  
    -- end xxx;
    newline[7] = string.gsub(line, "^%s*end", "  ; -- %0")
  
    if not lued.is_eol() then lued.del_eol(dd2); end
    for i=1,7 do
      if (newline[i]~=line) then
        lued.ins_str(newline[i],dd2)
        break
      end
    end

  end -- for r=r1,r2

  lued.set_cur_pos(r1,1)
  if not save_find_whole_word then
    lued.clr_find_whole_word(dd2)
  end

  lued.disp(dd)
end -- vhdl inst_from_entity


-- =============================================================================
-- =============================================================================

-- Insert VHDL template for entity and architecture

function lued.vhdl.template()

  local filename = lued.get_filename()
  filename = string.gsub(filename, ".*/", "");
  filename = string.gsub(filename, ".vhd.*", "");

  local str = [[
--------------------------------------------------------------------------------
-- Block: ]]..filename..[[

-- Description:
-- This block ...
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
library work;

entity ]]..filename..[[ is
generic (
  WIDTH : integer := 16
);
port (
  clk        : in  std_logic;
  rst        : in  std_logic;
  i_    : in  std_logic;
  o_    : out std_logic_vector(WIDTH-1 downto 0)
);
end ]]..filename..[[;

architecture rtl of ]]..filename..[[ is
  signal ccc       : std_logic;
  signal dddd      : std_logic_vector(WIDTH-1 downto 0);
  signal eeeee     : unsigned(WIDTH-1 downto 0);
  signal ffffff    : signed(WIDTH-1 downto 0);
begin

  process (clk,rst)
  begin
    if rst = '1' then

    elsif rising_edge(clk) then

    end if;
  end process;

end rtl;

]]

  local r,c = lued.get_cur_pos()
  lued.move_to_sol_classic()
  lued.ins_str(str)
  lued.set_cur_pos(r,c)
  lued.find_forward("...")
end



-- =============================================================================
-- Insert VHDL template for package

function lued.vhdl.package()

  local str = [===[

--------------------------------------------------------------------------------
-- Name :
-- Description:
-- This package ...
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

package aaa_pkg is
end package;
]===]


  lued.move_to_sol_classic()
  local r,c = lued.get_cur_pos()
  lued.ins_str(str)
  lued.set_cur_pos(r,c)
  lued.find_forward("...")
end


-- =============================================================================
-- Insert VHDL template for testbench

function lued.vhdl.tb()
  local full_filename = lued.get_filename()
  local filename = string.gsub(full_filename, ".*/", "");
  local blockname = string.gsub(filename, ".vhd.*", "");

  local full_tbname,src_found = string.gsub(full_filename, "src/", "tb/tb_");
  local tbname = string.gsub(full_tbname, ".*/", "");
  local tbblockname = string.gsub(full_filename, ".vhd.*", "");

  -- Snip Entity from block
  lued.move_to_first_line()
  local save_find_whole_word = lued.get_find_whole_word()
  lued.set_find_whole_word()
  lued.find_forward("entity")
  lued.move_to_sol_classic()
  lued.set_nameless_mark()
  lued.find_forward("end")
  lued.move_to_eol()
  lued.sel_mark_to_cursor()
  lued.global_copy()

  lued.new_file(full_tbname)

  lued.ins_str( [[

--------------------------------------------------------------------------------
-- Test : ]] .. tbname .. [[

-- Description:
-- This test verifies the ]] .. blockname .. [[
 block.
--
--------------------------------------------------------------------------------
-- library std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
library work;
use work.tb_pkg.all;

entity tb is
end entity tb;

architecture sim of tb is
FINDME1 ]]
,dd2)

  lued.global_paste(dd2)

  lued.ins_str( [[

  signal clk       : std_logic := '0';
  signal rst       : std_logic := '0';
  signal test_done : std_logic := '0';

begin

FINDME2
]])

  lued.global_paste()

  lued.ins_str( [[



  -- generate clocks until test_done is asserted
  process
  begin
    clkgen(clk,test_done);
    wait;  -- Simulation stops stop after clock stops
  end process;

  main_test: process
  begin

    report("reset dut");
    pulse(rst, clk, 10);

    report("After reset");

    wait_re(clk,10);

    report("test done"); -- severity NOTE, WARNING, ERROR, FAILURE (NOTE is default)

    set(test_done);
    wait;
  end process main_test;

end architecture sim;

]])

-- ===========================================================
-- CREATE CONSTANTS AND SIGNALS FROM ENTITY GENERICS AND PORTS
  lued.find_forward("FINDME1")
  lued.cut_line() -- FINDME1
  lued.vhdl.sig_from_entity()

-- ======================================================================
-- CONVERT ENTITY INTO INSTANTIATION

  lued.move_to_first_line()
  lued.find_forward("FINDME2")
  lued.cut_line()
  lued.set_nameless_mark()
  lued.find_forward("end")
  lued.move_down_n_lines(1)
  lued.sel_mark_to_cursor()
  lued.vhdl.inst_from_entity()
  lued.set_sel_off()



  if not save_find_whole_word then
    lued.clr_find_whole_word()
  end

  lued.move_to_first_line()
end -- lued.vhdl.tb




-- =============================================================================
-- =============================================================================
--
-- Insert VHDL process with a clock and an active-low, asynchronous reset.

function lued.vhdl.proc(dd)
  local dd2 = 1

  local r1,c1 = lued.get_cur_pos()
  local save_fw = g_find_whole_word
  g_find_whole_word = false;
  
  lued.set_cur_pos(1,1)
  local clk_name = "clk"
  local clk_found = lued.find_forward("clk",dd2) or
                    lued.find_forward("clock",dd2) or
                    lued.find_forward("ck",dd2) or false
  if clk_found then
    lued.set_sel_off()
    lued.sel_word()
    clk_name = lued.get_sel_str()
  end

  lued.set_cur_pos(1,1)
  local rst_name = "rst"
  local rst_found = lued.find_forward("rst",dd2) or
                    lued.find_forward("reset",dd2) or false
  if rst_found then
    lued.set_sel_off()
    lued.sel_word()
    rst_name = lued.get_sel_str()
  end

  lued.set_sel_off()
  g_find_whole_word = save_fw
  lued.move_to_line(r1,dd2)
  lued.move_to_sol_classic(dd2)

  local rst_name_lower = string.lower(rst_name)
  local rst_active_low = string.match(rst_name, "n") or
                         string.match(rst_name, "b") or
                         string.match(rst_name, "l")
  local rst_level = rst_active_low and "0" or "1"
  local str = [[

  process (]] .. clk_name .. " , " .. rst_name .. [[)
  begin
    if (]] .. rst_name .. " = '" .. rst_level .. [[') then
      
    elsif rising_edge(clk) then
      DELETEME
    end if;
  end process;

]]

  lued.ins_str_after(str, "DELETEME")


end


-- =============================================================================
-- Insert VHDL combinatorial process.

function lued.vhdl.proc_all()

  local str = [===[

  process (all) -- combinatorial block
  begin
    DELETEME
  end process;

]===]

  lued.move_to(0,1)
  lued.ins_str_after(str, "DELETEME")
end


-- =============================================================================
-- Insert VHDL function template.

function lued.vhdl.func()

  local str = [===[

  function incr(slv :std_logic_vector) return std_logic_vector is
  begin
    DELETEME
    return std_logic_vector( unsigned(slv) + 1);
  end function;

]===]

  lued.move_to(0,1)
  lued.ins_str_after(str)
  lued.del_next("DELETEME")
end


function alt_oth (dd) lued.ins_str("(others => '0');\n",dd2); insert_tab(dd); end
function alt_ooth (dd) lued.ins_str( "(others => (others => '0'));\n" ,dd2); insert_tab(dd); end

-- =============================================================================
-- Insert signal sl : std_logic;

function lued.vhdl.sl()
  lued.ins_str_after("signal signame   : std_logic;" , "signame")
end


-- =============================================================================
-- Insert: std_logic_vector(FIXME-1 downto 0);
-- ALT_slv15 produces std_logic_vector(15 downto 0);

function lued.vhdl.slv()
  lued.ins_str_after("signal signame     : std_logic_vector(".."H".." downto 0);" , "signame")
end


function lued.vhdl.signed()
  lued.ins_str_after("signal signame     : signed(".."H".." downto 0);" , "signame")
end


function lued.vhdl.unsigned()
  lued.ins_str_after("signal signame     : unsigned(".."H".." downto 0);" , "signame")
end


-- =============================================================================
-- Insert: integer := integer(ceil(log2(real(DEPTH))));

function lued.vhdl.log()
  lued.ins_str_after("integer := integer(ceil(log2(real(BUS_WIDTH))));", "BUS_WIDTH")
end


-- =============================================================================
-- Insert signal slv_array : slv_array16_type;
-- Works in conjunction with vhdl_type_slv_array.

function lued.vhdl.slv_array()
  local str = "signal slv_array    : slv_array16_type;"
  lued.ins_str_after(str , "slv_array")
end


-- =============================================================================
-- Insert FIXME = std_logic_vector( unsigned(FIXME) + 1);

function lued.vhdl.slv_incr(dd)
  local str = "std_logic_vector( unsigned(FIXME) + 1);"
  lued.move_to_sol()
  lued.sel_word()
  lued.copy()
  lued.move_to_eol()
  lued.ins_str_after(str, "FIXME")
  lued.paste()
end


-- =============================================================================
-- Insert FIXME <= std_logic_vector( resize( unsigned(FIXME), FIXME'size);

function lued.vhdl.resize(t)
  t = t or "slv"
  local str = ""
  if t=="slv" then
    str = "std_logic_vector( resize( unsigned(FIXME), FIXME2'length);"
  else
    str = "resize(FIXME, FIXME2'length);"
  end

  lued.move_to_sol()
  lued.sel_word()
  lued.copy()
  lued.move_to_eol()
  
  lued.ins_str_after(str, "FIXME2")
  lued.paste()
  lued.find_reverse("FIXME")
end

function lued.vhdl.slv_resize() lued.vhdl.resize("slv") end
function lued.vhdl.signed_resize() lued.vhdl.resize("signed") end
function lued.vhdl.unsigned_resize() lued.vhdl.resize("unsigned") end


-- =============================================================================
-- Insert type state is (IDLE, STATE1);

function lued.vhdl.state()
  local str = "type state_type is (IDLE, STATE1);"
  lued.ins_str_after(str, "state_type")
end


-- =============================================================================
-- Insert VHDL record template;

function lued.vhdl.record()
  local str = [[
  type aaa_rec is record
    sig1    :std_logic;
    sig2    :std_logic_vector(7 downto 0);
  end record aaa_rec;

]]
  lued.move_to(0,1)
  lued.ins_str_after(str, "aaa_rec")
end


-- =============================================================================
-- Insert type slv_array16_type is array(natural range <>) of std_logic_vector(15 downto 0);
-- Works in conjunction with lued.vhdl.slv_array.

function lued.vhdl.type_slv_array()
  local str = "type slv_array16_type is array(natural range <>) of std_logic_vector(15 downto 0);"
  lued.ins_str_after(str,"slv_array16_type")
end


-- =============================================================================
-- Insert VHDL case statement template

function lued.vhdl.case()

  local str = [[
      case state is
        when IDLE =>
          if COND then
            state <= STATE2
          end if;
        when STATE2 => state <= STATE3;
        when OTHERS =>
          state <= IDLE;
      end case;
]]

  lued.move_to(0,1)
  lued.ins_str_after(str, "state")
end


-- =============================================================================
-- Insert clock generator

function lued.vhdl.clkgen()

  local str = [[

  constant CLK_PERIOD      : time := 10 ns;
  constant CLK_HALF_PERIOD : time := CLK_PERIOD / 2;
  signal   clk_en          : std_logic := '0';
  signal   clk             : std_logic := '0';

  clk_en <= not test_done;
  clkgen: process
  begin
    while true loop
      wait until clk_en;
      while clk_en loop
        clk <= not clk;
        wait for CLK_HALF_PERIOD;
      end loop;
    end loop;
    wait;
  end process clkgen;

]]

  lued.ins_str_after(str, "clk")
end


-- =============================================================================
-- Insert wait for N clocks

function lued.vhdl.clkn()

  local str = [[

    for i in 1 to FOR_NN loop
      wait until rising_edge(FOR_CLK);
    end loop;

]]

  lued.ins_str_after(str)      -- Insert the template
  lued.find_reverse("clk")     -- Search previous word with clk
  lued.copy_word()             -- Put word in paste buffer
  lued.find_forward("FOR_CLK") -- Find FOR_CLK
  lued.paste()                 -- Replace FOR_CLK with clk signalname
  lued.find_reverse("FOR_NN")  -- Select max loop count for easy replace
end


-- =============================================================================
-- print help

function lued.vhdl.help()
  local help_str = [[

  ]]

print(help_str)
prompt("Press <Enter> to continue...")

end

-- =============================================================================
-- KEYBOARD BINDINGS

alt_vhdl_help      = vhdl_help

-- ============================================================================

local s = {}
lued.def_snippet(s, "vhdl vhd !"     , lued.vhdl.template)
lued.def_snippet(s, "package pack"   , lued.vhdl.package)
lued.def_snippet(s, "process proc"   , lued.vhdl.proc)
lued.def_snippet(s, "testbench tb"   , lued.vhdl.tb)
lued.def_snippet(s, "proc_all procall all" , lued.vhdl.proc_all)
lued.def_snippet(s, "function func"  , lued.vhdl.func)
lued.def_snippet(s, "sl stdl"        , lued.vhdl.sl)
lued.def_snippet(s, "sv slv stdlv"   , lued.vhdl.slv)
lued.def_snippet(s, "slva aslv"      , lued.vhdl.slv_array)
lued.def_snippet(s, "incr"           , lued.vhdl.slv_incr)
lued.def_snippet(s, "resize"         , lued.vhdl.slv_resize)
lued.def_snippet(s, "un uns unsign unsigned" , lued.vhdl.unsigned)
lued.def_snippet(s, "si sign signed" , lued.vhdl.signed)
lued.def_snippet(s, "log log2"       , lued.vhdl.log)
lued.def_snippet(s, "ta tsa typea"   , lued.vhdl.type_slv_array)
lued.def_snippet(s, "rec record"     , lued.vhdl.record)
lued.def_snippet(s, "ts state"       , lued.vhdl.state)
lued.def_snippet(s, "resize slvresize slvr" , lued.vhdl.slv_resize)
lued.def_snippet(s, "uresize ures ur" , lued.vhdl.unsigned_resize)
lued.def_snippet(s, "sresize sres"    , lued.vhdl.signed_resize)
lued.def_snippet(s, "case"            , lued.vhdl.case)
lued.def_snippet(s, "inst instance e2i" , lued.vhdl.inst_from_entity)
lued.def_snippet(s, "sig siglist sigent" , lued.vhdl.sig_from_entity)
lued.def_snippet(s, "selent sel_ent sent" , lued.vhdl.sel_entity)
lued.def_snippet(s, "help h"              , lued.vhdl.help)
lued.def_snippet(s, "clkgen"              , lued.vhdl.clkgen)
lued.def_snippet(s, "clkn"                , lued.vhdl.clkn)
lued.snippets.vhdl = s


