
-- verilog.lua - plugin for lued text editor

lued.verilog = {}
lued.filetypes.v = "verilog"
lued.filetypes.sv  = "verilog"
lued.line_comments.verilog = "//"

lued.verilog.keyword_str = string.gsub([[
accept_on export ref alias extends restrict always_comb extern return 
always_ff final s_always always_latch first_match s_eventually assert foreach 
s_nexttime assume forkjoin s_until before global s_until_with bind iff 
sequence bins ignore_bins shortint binsof illegal_bins shortreal bit implies 
solve break import static byte inside string chandle int strong checker 
interface struct class intersect super clocking join_any sync_accept_on const 
join_none sync_reject_on constraint let tagged context local this continue 
logic throughout cover longint timeprecision covergroup matches timeunit 
coverpoint modport type cross new typedef dist nexttime union do null unique 
endchecker package unique0 endclass packed until endclocking priority 
until_with endgroup program untypted endinterface property var endpackage 
protected virtual endprogram pure void endproperty rand wait_order endsequence 
randc weak enum randcase wildcard eventually randsequence with expect 
reject_on within
]] , "%s+", " ")

lued.keywords.verilog = lued.explode_keys(lued.verilog.keyword_str, " ")


-- =============================================================================
-- =============================================================================
-- lued.verilog.sig_from_entity converts a verilog entity into signals and constants.
-- The entity's generics are converted to constants
-- The entity's ports are converted to signals.
-- Typical usage is to cut/paste a copy of the entity. Then move to the first line
-- of the copy and type esc+lued.verilog.sig_from_entity. This should have converted the generics and
-- ports to constants and signals.

function lued.verilog.sig_from_entity()
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
end -- lued.verilog.sig_from_entity

-- =============================================================================
-- =============================================================================

--[[
  verilog_inst
--]]

-- Instantiates verilog entity.
--   1. Copy+paste the entity
--   2. Place cursor on the entity line.
--   3. Type esc+verilog_inst.  This should change the line to u_...
--   4. Start pressing <Enter>.  This should walk through correcting each line of the entity.
--   5. Move cursor to the first port and move the => to a good column and -- to a good column
--   6. Select all of the ports
--   7. Type Alt-aa and enter = at the prompt. This should align all of the =>.
--   8. Type Alt-aa and enter -- at the prompt.  This should align alll of the -- comments.

function lued.verilog.sel_entity(dd)
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

function lued.verilog.inst_from_entity(dd)
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
end -- verilog inst_from_entity


function lued.verilog.inst_from_entity_wrapper()
  lued.set_nameless_mark()
  lued.find_forward("end")
  lued.move_down_n_lines(1)
  lued.sel_mark_to_cursor()
  lued.verilog.inst_from_entity()
  lued.set_sel_off()
end

-- =============================================================================
-- =============================================================================

-- Insert verilog template for entity and architecture

function lued.verilog.template()

  local filename = lued.get_filename()
  filename = string.gsub(filename, ".*/", "");
  filename = string.gsub(filename, ".v$", "");
  filename = string.gsub(filename, ".sv$", "");

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
-- Insert verilog template for testbench

function lued.verilog.tb()
  local full_filename = lued.get_filename()
  local filename = string.gsub(full_filename, ".*/", "");
  local blockname = string.gsub(filename, ".v$", "");
  local blockname = string.gsub(filename, ".sv$", "");

  local full_tbname,src_found = string.gsub(full_filename, "src/", "tb/tb_");
  local tbname = string.gsub(full_tbname, ".*/", "");
  local tbblockname = string.gsub(full_filename, ".v$", "");
  local tbblockname = string.gsub(full_filename, ".sv$", "");

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
-- use work.tb_pkg.all;

entity tb is
end entity tb;

architecture sim of tb is
FINDME1 ]]
,dd2)

  lued.global_paste(dd2)

  lued.ins_str( [[

  constant CLK_PERIOD : time := 10 ns;
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
    wait for CLK_PERIOD;
    while test_done = '0'  loop
      clk <= not clk;
      wait for CLK_PERIOD / 2;
    end loop;
    wait;  -- Simulation stops stop after clock stops
  end process;
  

  main_test: process
  begin

    report("reset dut");
    rst <= '0';
    for i in 1 to 10 loop wait until rising_edge(clk); end loop; 
    rst <= '1';
    for i in 1 to 10 loop wait until rising_edge(clk); end loop; 
    report("After reset");
    rst <= '0';
    for i in 1 to 10 loop wait until rising_edge(clk); end loop; 

    report("Start of test");




    report("Test done"); -- severity NOTE, WARNING, ERROR, FAILURE (NOTE is default)
    for i in 1 to 10 loop wait until rising_edge(clk); end loop; 
    test_done <= '1';
    wait;
  end process main_test;

end architecture sim;

]])

-- ===========================================================
-- CREATE CONSTANTS AND SIGNALS FROM ENTITY GENERICS AND PORTS
  lued.find_forward("FINDME1")
  lued.cut_line() -- FINDME1
  lued.verilog.sig_from_entity()

-- ======================================================================
-- CONVERT ENTITY INTO INSTANTIATION

  lued.move_to_first_line()
  lued.find_forward("FINDME2")
  lued.cut_line()
  
  lued.verilog.inst_from_entity_wrapper()


  if not save_find_whole_word then
    lued.clr_find_whole_word()
  end

  lued.move_to_first_line()
end -- lued.verilog.tb




-- =============================================================================
-- =============================================================================
--
-- Insert verilog always block with a clock and an active-low, asynchronous reset.

function lued.verilog.always_block(dd)
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
  local rst_level = rst_active_low and "~" or ""
  local rst_edge  = rst_active_low and "negedge " or "posedge "
  local str = [[

  always @ (posedge ]] .. clk_name .. " or " .. rst_edge .. rst_name .. ")" .. [[
  begin
    if (]] .. rst_level .. rst_name .. [[) begin
      DELETME
    end
    else begin
    end
  end

]]

  lued.ins_str_after(str, "DELETEME")


end


-- =============================================================================
-- Insert verilog combinatorial process.

function lued.verilog.always_star()

  local str = [===[
  always@*
  begin
    DELETEME
  end

]===]

  lued.move_to(0,1)
  lued.ins_str_after(str, "DELETEME")
end


-- =============================================================================
-- Insert verilog function template.

function lued.verilog.func()

  local str = [===[

  function [CHANGE:0] change (input [7:0] a, b);
  begin
    change = a + b;
  end
  endfunction

]===]

  lued.move_to(0,1)
  lued.ins_str_after(str, "CHANGE")
end


-- =============================================================================
-- Insert: integer := integer(ceil(log2(real(DEPTH))));

function lued.verilog.log()
  lued.ins_str_after("integer := integer(ceil(log2(real(BUS_WIDTH))));", "BUS_WIDTH")
end



-- =============================================================================
-- Insert type state is (IDLE, STATE1);

function lued.verilog.state()
  local str = "type state_type is (IDLE, STATE1);"
  lued.ins_str_after(str, "state_type")
end


-- =============================================================================
-- Insert verilog record template;

function lued.verilog.record()
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
-- Works in conjunction with lued.verilog.slv_array.

function lued.verilog.type_slv_array()
  local str = "type slv_array16_type is array(natural range <>) of std_logic_vector(15 downto 0);"
  lued.ins_str_after(str,"slv_array16_type")
end


-- =============================================================================
-- Insert verilog case statement template

function lued.verilog.case()

  local str = [[

  case (CHANGE)
    change_1 : next_state <= state;
    change_2,
    change_3 : a <= b;
    change_4 : begin
       c <= d;
       e <= f;
    end
    default : g <= h;
  endcase

]]

  lued.move_to(0,1)
  lued.ins_str_after(str, "CHANGE")
end


-- =============================================================================
-- Insert clock generator

function lued.verilog.clkgen()

  local str = [[

  wire  clk_en = !test_done;
  reg   clk;    initial clk = 0;

  clk_en <= not test_done;
  initial begin
    #5;
    while (clk_en) begin
      #5 clk <= !clk;
    end
  end
]]

  lued.ins_str_after(str, "clk")
end


-- =============================================================================
-- Insert wait for N clocks

function lued.verilog.clkn()

  local str = [[

  repeat(NNN) @posedge(REP_CLK)
    for i in 1 to FOR_NN loop
      wait until rising_edge(FOR_CLK);
    end loop;

]]

  lued.ins_str_after(str)      -- Insert the template
  lued.find_reverse("clk")     -- Search previous word with clk
  lued.copy_word()             -- Put word in paste buffer
  lued.find_forward("REP_CLK") -- Find FOR_CLK
  lued.paste()                 -- Replace FOR_CLK with clk signalname
  lued.find_reverse("NNN")  -- Select max loop count for easy replace
end


-- =============================================================================
-- Insert wait for 1 clock

function lued.verilog.clk1()

  local str = [[@posedge(XXXCLK1);]]

  lued.ins_str_after(str)      -- Insert the template
  lued.find_reverse("clk")     -- Search previous word with clk
  lued.copy_word()             -- Put word in paste buffer
  lued.find_forward("XXXCLK1") -- Find FOR_CLK
  lued.paste()                 -- Replace FOR_CLK with clk signalname
  lued.insert_cr_after()
end


-- =============================================================================
-- print help

function lued.verilog.help()
  local help_str = [[

  ]]

print(help_str)
prompt("Press <Enter> to continue...")

end

-- =============================================================================
-- KEYBOARD BINDINGS

alt_verilog_help      = verilog_help

-- ============================================================================

local s = {}
lued.def_snippet(s, "verilog !"      , lued.verilog.template)
lued.def_snippet(s, "always"         , lued.verilog.always_block)
lued.def_snippet(s, "testbench tb"   , lued.verilog.tb)
lued.def_snippet(s, "al*"            , lued.verilog.always_star)
lued.def_snippet(s, "func"           , lued.verilog.func)
lued.def_snippet(s, "log log2"       , lued.verilog.log)
lued.def_snippet(s, "record"     , lued.verilog.record)
lued.def_snippet(s, "ts state"       , lued.verilog.state)
lued.def_snippet(s, "case"            , lued.verilog.case)
lued.def_snippet(s, "inst instance e2i" , lued.verilog.inst_from_entity_wrapper)
lued.def_snippet(s, "sig siglist sigent" , lued.verilog.sig_from_entity)
lued.def_snippet(s, "help h"              , lued.verilog.help)
lued.def_snippet(s, "clkgen"              , lued.verilog.clkgen)
lued.def_snippet(s, "clkn"                , lued.verilog.clkn)
lued.def_snippet(s, "clk1"                , lued.verilog.clk1)
lued.snippets.verilog = s


