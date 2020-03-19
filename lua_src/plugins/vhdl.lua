
-- vhdl.lua

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

function vhdl_inst(dd)
  local dd2 = 1
  local line = get_line()
  local newline = {}

  local next_line = get_next_line() or "" -- peek ahead for close paren
  local paren_start = string.find(next_line, "^%s*%)%s*;",1) or 0
  local comma = (paren_start==0) and "," or " "

  local name = string.gsub(line, "^%s*([_%w]+).*", "%1")
  local padlen = math.max(14 - #name, 0)
  local pad = string.rep(' ',padlen)

  -- entity xxx is
  newline[1] = string.gsub(line, "^%s*entity%s+([_%w]+)%s+is", "  u_%1: entity work.%1")

  -- generic (
  newline[2] = string.gsub(line, "^%s*generic.*", "  generic map (")
  
  -- WIDTH : integer := 1024;
  newline[3] = string.gsub(line, "^%s*([_%w]+).*[:]=.*", "    %1"..pad.."=> %1"..comma)

  -- port (
  newline[4] = string.gsub(line, "^%s*port.*", "  port map (")

  -- clk: in std_logic;
  newline[5] = string.gsub(line, "^%s*([_%w]+)%s*:%s*(%w%w.)%s*(std_logic[^;]*)", "    %1"..pad.."=> %1"..comma..pad.."  -- %2 %3")

  -- );
  newline[6] = string.gsub(line, "^%s*[)];.*", "  )")
  
  -- end xxx;
  newline[7] = string.gsub(line, "^%s*end", "  -- %0")

  for i=1,7 do
    if (newline[i]~=line) then
      replace_line(newline[i],dd2)
      break
    end
  end

  move_down_n_lines(1,dd2)
  move_to_sol_classic(dd2)

  disp(dd)
end


function vhdl_inst_selected(dd)
  foreach_selected(vhdl_inst, dd)
end




-- =============================================================================
-- Insert VHDL template for entity and architecture

function vhdl_template(dd)

  local str = [===[

--------------------------------------------------------------------------------
-- Block:
-- Email:
-- Description:
-- This block ...
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity yyy is
generic (
  WIDTH : integer := 16;
);
port (
  clk        : in  std_logic;
  rst_n      : in  std_logic;
  i_aaa      : in  std_logic;
  o_bbbb     : out std_logic_vector(WIDTH-1 downto 0)
);
end yyy;

architecture rtl of yyy is
  signal ccc       : std_logic;
  signal dddd      : std_logic_vector(WIDTH-1 downto 0);
  signal eeeee     : unsigned(WIDTH-1 downto 0);
  signal ffffff    : signed(WIDTH-1 downto 0);
begin

end rtl;

]===]

  local dd2 = 1
  move_to_sol_classic(dd2)
  ins_str(str,dd)
end



-- =============================================================================
-- Insert VHDL template for package

function vhdl_package(dd)

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

  local dd2 = 1
  move_to_sol_classic(dd2)
  ins_str(str,dd)
  move_up_n_lines(30,dd2)
  move_to_eol(dd)
end


-- =============================================================================
-- Insert VHDL template for testbench

function vhdl_tb(dd)

  local str = [===[

--------------------------------------------------------------------------------
-- Test :
-- Description:
-- This test ...
--
--------------------------------------------------------------------------------
library std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
library work;

entity tb is
end entity tb;

architecture sim of tb is
  signal ccc       : std_logic;
  signal dddd      : std_logic_vector(WIDTH-1 downto 0);
  signal eeeee     : unsigned(WIDTH-1 downto 0);
  signal ffffff    : signed(WIDTH-1 downto 0);

  signal clk       : std_logic;
  signal rst_n     : std_logic;
  signal test_done : std_logic := '0';

  constant CLK_PERIOD : time := 10 ns;

begin

  -- generate clocks until test_done is asserted
  clk_gen: process
  begin
    while test_done = '0' loop
      wait for CLK_PERIOD / 2;
      clk <= '1';
      wait for CLK_PERIOD / 2;
      clk <= '0';
    end loop;
    wait;  -- Simulation stops stop after clock stops
  end process clk_gen;

  main_test: process
  begin
    rst_n <= '0'; -- assert reset

    for i in 1 to 10 loop
      wait until rising_edge(clk);
    end loop;

    wait for 10 * CLK_PERIOD;

    report("test done"); -- severity NOTE, WARNING, ERROR, FAILURE (NOTE is default)

    test_done <= '1';
    wait;
  end process main_test;

end sim;
]===]

  local dd2 = 1
  local r,c = get_cur_pos()
  move_to_sol_classic(dd2)
  ins_str(str,dd)
  set_cur_pos(r,c)
  disp(dd)
end



--
-- =============================================================================
-- Insert VHDL process with a clock and an active-low, asynchronous reset.

function vhdl_proc(dd)

  local str = [===[

  process (clk, rst_n)
  begin
    if (rst_n = '0') then
      xxx <= '0;
      yyy <= (others => '0');
    elsif rising_edge(clk)

    end if;
  end process;

]===]

  local dd2 = 1
  move_to_sol_classic(dd2)
  ins_str(str,dd)
  move_up_n_lines(4,dd2)
  move_to_eol(dd)
end


-- =============================================================================
-- Insert VHDL combinatorial process.

function vhdl_proc_all(dd)

  local str = [===[

  process (all) -- combinatorial block
  begin

  end process;

]===]

  local dd2 = 1
  move_to_sol_classic(dd2)
  ins_str(str,dd)
  move_up_n_lines(3,dd2)
  move_to_eol(dd)
end


-- =============================================================================
-- Insert VHDL function template.

function vhdl_function(dd)

  local str = [===[

  function incr(slv :std_logic_vector) return std_logic_vector is
  begin
    return std_logic_vector( unsigned(slv) + 1);
  end function;

]===]

  local dd2 = 1
  move_to_sol_classic(dd2)
  ins_str(str,dd)
  move_up_n_lines(3,dd2)
  move_to_eol(dd)
end


function alt_oth (dd) ins_str("(others => '0');\n",dd); end
function alt_ooth (dd) ins_str("others => (others => '0'));\n",dd); end

-- =============================================================================
-- Insert signal sl : std_logic;

function vhdl_sl(dd)
  local dd2 = 1

--   local str = "signal sl : std_logic;"
--   ins_str(str,dd2)
--   move_to_sol(dd2)
--   move_right_n_words(1,dd2)
--   sel_word(dd)

  ins_str(" std_logic;\n",dd)


end


-- =============================================================================
-- Insert signal slv : std_logic_vector(FIXME downto 0);

function vhdl_slv(n,dd)
  n = n or 0
  local dd2 = 1

--   local str = "signal slv : std_logic_vector(FIXME downto 0);"
--   ins_str(str,dd2)
--   move_to_sol(dd2)
--   move_right_n_words(1,dd2)
--   sel_word(dd)

  if n == 0 then
    ins_str("std_logic_vector(".."FIXME-1".." downto 0);", dd2)
    move_left_n_words(3,dd2);
    sel_word(dd2);
  else
    ins_str("std_logic_vector("..n.." downto 0);", dd2)
  end
  disp(dd)
end


-- =============================================================================
-- Insert signal slv_array : slv_array16_type;
-- Works in conjunction with vhdl_type_slv_array.

function vhdl_slv_array(dd)

  local str = "signal slv_array : slv_array16_type;"

  local dd2 = 1
  ins_str(str,dd2)
  move_to_sol(dd2)
  move_right_n_words(1,dd2)
  sel_word(dd)
end


-- =============================================================================
-- Insert signal unsigned_vec : std_logic_vector(FIXME downto 0);

function vhdl_unsigned(dd)

  local str = "signal unsigned_vec : std_logic_vector(FIXME downto 0);"

  local dd2 = 1
  ins_str(str,dd2)
  move_to_sol(dd2)
  move_right_n_words(1,dd2)
  sel_word(dd)
end


-- =============================================================================
-- Insert signal signed_vec : std_logic_vector(FIXME downto 0);

function vhdl_signed(dd)

  local str = "signal signed_vec : std_logic_vector(FIXME downto 0);"

  local dd2 = 1
  ins_str(str,dd2)
  move_to_sol(dd2)
  move_right_n_words(1,dd2)
  sel_word(dd)
end


-- =============================================================================
-- Insert FIXME = std_logic_vector( unsigned(FIXME) + 1);

function vhdl_slv_incr(dd)

  local str = "FIXME = std_logic_vector( unsigned(FIXME) + 1);"

  local dd2 = 1
  ins_str(str,dd2)
  move_to_sol(dd2)
  sel_word(dd)
end


-- =============================================================================
-- Insert type state is (IDLE, STATE1);

function vhdl_state(dd)

  local str = "type state_type is (IDLE, STATE1);"

  local dd2 = 1
  ins_str(str,dd2)
  move_to_sol(dd2)
  move_right_n_words(1,dd2)
  sel_word(dd)
end


-- =============================================================================
-- Insert VHDL record template;

function vhdl_record(dd)

  local str = [[
  type aaa_rec is record
    sig1    :std_logic;
    sig2    :std_logic_vector(7 downto 0);
  end record aaa_rec;

]]


  local dd2 = 1
  ins_str(str,dd)
end


-- =============================================================================
-- Insert type slv_array16_type is array(natural range <>) of std_logic_vector(15 downto 0);
-- Works in conjunction with vhdl_slv_array.

function vhdl_type_slv_array(dd)

  local str = "type slv_array16_type is array(natural range <>) of std_logic_vector(15 downto 0);"

  local dd2 = 1
  ins_str(str,dd2)
  move_to_sol(dd2)
  move_right_n_words(1,dd2)
  sel_word(dd2)
  set_sel_end()
  disp(dd)
end


-- =============================================================================
-- Insert VHDL case statement template

function vhdl_case(dd)

  local str = [[
      case state is
        when IDLE =>
          if COND then
            state <= STATE2
          end if;
        when STATE2 =>
          state <= STATE3;
        when OTHERS =>
          state <= IDLE;
      endcase;
]]

  local dd2 = 1
  move_to_sol_classic(dd2)
  ins_str(str,dd2)
  move_up_n_lines(9,dd2)
  move_to_sol(dd2)
  move_right_n_words(1,dd2)
  sel_word(dd)
end


function vhdl_help()
  local help_str = [[
  
alt_vhdl_inst             - Convert arch/port list into entity instantiation
alt_vhdl_proc             - Template for clocked process
alt_vhdl_proc_all         - Template for comb process
alt_vhdl_template         - Template for vhdl file 
alt_vhdl_package          - Template for vhdl package
alt_vhdl_tb               - Template for testbench
alt_sl                    - Shortcut for std_logic
alt_slv                   - Shortcut slv.  alt+slv15 -> std_logic_vector(15 downto 0);
alt_slv_squote            - Shortcut slv.  alt+slv'WID -> std_logic_vector(WID-1 downto 0);
alt_unsigned              - shortcut unsigned15 -> unsigned(15 downto 0);
alt_signed                - shortcut signed15 -> signed(15 downto 0);
alt_slv_array             - shortcut
alt_slv_incr              - shortcut x <= std_logic_vecctor(unsigned(x)+1);     
alt_vhdl_case             - Template for case statement
alt_vhdl_state            - Template for state
alt_vhdl_record           - Template
alt_vhdl_type_slv_array   - Template
alt_vhdl_function         - Template
  ]]

print(help_str)

end

-- =============================================================================
-- KEYBOARD BINDINGS

alt_vhdl_help      = vhdl_help
alt_vhdl_inst      = vhdl_inst_selected
alt_vhdl_proc      = vhdl_proc
alt_vhdl_proc_all  = vhdl_proc_all
alt_vhdl_template  = vhdl_template
alt_vhdl_package   = vhdl_package
alt_vhdl_tb        = vhdl_tb
alt_sl             = vhdl_sl
alt_slv            = vhdl_slv
alt_unsigned       = vhdl_unsigned
alt_signed         = vhdl_signed
alt_slv_array      = vhdl_slv_array
alt_slv_incr       = vhdl_slv_incr
alt_vhdl_case      = vhdl_case
alt_vhdl_state     = vhdl_state
alt_vhdl_record    = vhdl_record
alt_vhdl_type_slv_array = vhdl_type_slv_array
alt_vhdl_function  = vhdl_function


