
-- verilog.lua - plugin for lued text editor

lued.verilog = {}
lued.filetypes.v = "verilog"
lued.filetypes.sv  = "verilog"
lued.line_comments.verilog = "//"

lued.verilog.keyword_str = string.gsub([[
always end ifnone or rpmos tranif1 and endcase initial output rtran tri assign 
endmodule inout parameter rtranif0 tri0 begin endfunction input pmos rtranif1 
tri1 buf endprimitive integer posedge scalared triand bufif0 endspecify join 
primitive small trior bufif1 endtable large pull0 specify trireg case endtask 
macromodule pull1 specparam vectored casex event medium pullup strong0 wait 
casez for module pulldown strong1 wand cmos force nand rcmos supply0 weak0 
deassign forever negedge real supply1 weak1 default for nmos realtime table 
while defparam function nor reg task wire disable highz0 not release time wor 
edge highz1 notif0 repeat tran xnor else if notif1 rnmos tranif0 xor
$dumpfile $dumpvars $finish $display

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
-- lued.verilog.sig_from_portlist converts a verilog entity into signals and constants.
-- The entity's generics are converted to constants
-- The entity's ports are converted to signals.
-- Typical usage is to cut/paste a copy of the entity. Then move to the first line
-- of the copy and type esc+lued.verilog.sig_from_portlist. This should have converted the generics and
-- ports to constants and signals.

function lued.verilog.sig_from_portlist()
  local dd2 = 1
  local r1,c1 = lued.get_cur_pos()
  lued.find_forward("end",dd2)
  local r2,c2 = lued.get_cur_pos()

  for r=r1,r2 do
    lued.set_cur_pos(r,1)
    local line = lued.get_line()
    lowerline = string.lower(line)

    -- Insert semicolon if missing
    if string.find(line, "input") or string.find(line, "output") or string.find(line, "inout") then
      line = string.gsub(line,"input", "reg  ")
      line = string.gsub(line,"output","wire ")
      line = string.gsub(line,"inout", "wire ")
      line = string.gsub(line,",",";")
      if string.find(line, ";") == nil then
        line = string.gsub(line," *//","; //")
        if string.find(line, ";") == nil then
          line = line .. ";"
        end
      end
    end
    lued.ins_str(line,dd2)
  end -- for
  lued.set_cur_pos(r1+1,1)
  lued.disp(dd)
end -- lued.verilog.sig_from_portlist

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

function lued.verilog.inst_from_portlist(dd)
  local dd2 = 1
  
  local r1,c1 = lued.get_cur_pos()
  local save_find_whole_word = lued.get_find_whole_word()
  lued.set_find_whole_word()
  lued.find_forward(";",dd2)
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
    newline[1] = string.gsub(line, "^%s*module%s+([_%w]+)%s+is", "  %1 u_%1")
    newline[1] = string.gsub(newline[1], "^%s*module%s+([_%w]+)%s+is", "  %1 u_%1")
  
    -- parameter (
--     newline[2] = string.gsub(line, "^%s*generic.*", "  generic map (")
--     newline[2] = string.gsub(newline[2], "^%s*GENERIC.*", "  GENERIC MAP (")
--   
--     -- WIDTH : integer := 1024;
--     newline[3] = string.gsub(line, "^%s*([_%w]+).*[:]=.*", "    %1"..pad.."=> %1"..comma)
  
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
end -- verilog inst_from_portlist


function lued.verilog.inst_from_portlist_wrapper()
  lued.set_nameless_mark()
  lued.find_forward(";")
  lued.move_down_n_lines(1)
  lued.sel_mark_to_cursor()
  lued.verilog.inst_from_portlist()
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
  modulename = filename

  local str = [[
//-----------------------------------------------------------------------------
// Block: ]]..filename..[[

// Description:
// This block ...
//
//------------------------------------------------------------------------------


module ]] .. modulename .. [[ #(
  parameter AWID = 16,
  parameter DWID = 32) (
  input                 clk,
  input                 rst_n,
  input                 we,
  input      [AWID-1:0] i_addr,
  input      [DWID-1:0] i_dat,
  output reg            o_data_v,
  output     [DWID-1:0] o_dat);            

  localparam AWID2 = 2;

  -- clamp address to full scale
  wire [AWID2:0]  tmpa = (i_addr[AWID-1:AWID2] == 0) ? {AWID2{1'b1}}  : i_addr[AWID2:0];
  
  reg [DWID-1:0] reg_array[0:7];
  assign o_dat = reg_array[tmpa];
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      o_dat <= 'h0;
    end else begin
      if (we) begin
        reg_array[tmpa] <= i_dat;
      end
    end
  end
endmodule


]]

  local r,c = lued.get_cur_pos()
  lued.move_to_sol_classic()
  lued.ins_str(str)
  lued.set_cur_pos(r,c)
  lued.find_forward("16")
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
  lued.find_forward("module")
  lued.move_to_sol_classic()
  lued.set_nameless_mark()
  lued.find_forward(";")
  lued.move_to_eol()
  lued.sel_mark_to_cursor()
  lued.global_copy()

  lued.new_file(full_tbname)

  lued.ins_str( [[

// ----------------------------------------------------------------------------
// Test : ]] .. tbname .. [[

// Description:
// This test verifies the ]] .. blockname .. [[
 block.
//
// ----------------------------------------------------------------------------

‘timescale 1 ns /  100 ps

module tb();
FINDME1 ]]
,dd2)

  lued.global_paste(dd2)

  lued.ins_str( [[

  parameter HALF_CLK = 5;
  reg  clk       ; initial clk = 0;
  reg  rst       ; initial rst = 0;

  always #(HALF_CLK) clk <= !clk;

FINDME2
]])

  lued.global_paste()

  lued.ins_str( [[

// ----------------------------------------------------------------------------
// MAIN TEST
  
  initial
  begin

    $display($time, "reset dut");
    rst <= '0';
    repeat(10) @(posedge clk);
    rst <= '1';
    repeat(10) @(posedge clk);
    $display($time, "After reset");
    rst <= '0';
    repeat(10) @(posedge clk);

    $display($time, "Start of test");




    $display($time, "Test done"); -- severity NOTE, WARNING, ERROR, FAILURE (NOTE is default)
    for i in 1 to 10 loop wait until rising_edge(clk); end loop; 
    $finish;
  end // main initial block

endmodule

]])

-- ===========================================================
-- CREATE CONSTANTS AND SIGNALS FROM ENTITY GENERICS AND PORTS
  lued.find_forward("FINDME1")
  lued.cut_line() -- FINDME1
  lued.verilog.sig_from_portlist()

-- ======================================================================
-- CONVERT ENTITY INTO INSTANTIATION

  lued.move_to_first_line()
  lued.find_forward("FINDME2")
  lued.cut_line()
  
  lued.verilog.inst_from_portlist_wrapper()


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

function lued.verilog.for_loop()

  local str = [[
  integer ii;
  for (ii = 0; ii < 10; ii = ii + 1) begin
    
  end

]]

  lued.move_to(0,1)
  lued.ins_str_after(str, "iis")
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
  repeat(NNN) @posedge(REP_CLK);
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
  lued.insert_line_after()
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
lued.def_snippet(s, "! verilog"      , lued.verilog.template)
lued.def_snippet(s, "always"         , lued.verilog.always_block)
lued.def_snippet(s, "testbench tb"   , lued.verilog.tb)
lued.def_snippet(s, "al*"            , lued.verilog.always_star)
lued.def_snippet(s, "func"           , lued.verilog.func)
lued.def_snippet(s, "log log2"       , lued.verilog.log)
lued.def_snippet(s, "record"     , lued.verilog.record)
lued.def_snippet(s, "ts state"       , lued.verilog.state)
lued.def_snippet(s, "for"            , lued.verilog.for_loop)
lued.def_snippet(s, "case"            , lued.verilog.case)
lued.def_snippet(s, "inst instance e2i" , lued.verilog.inst_from_portlist_wrapper)
lued.def_snippet(s, "sig siglist sigent" , lued.verilog.sig_from_portlist)
lued.def_snippet(s, "help h"              , lued.verilog.help)
lued.def_snippet(s, "clkgen"              , lued.verilog.clkgen)
lued.def_snippet(s, "clkn"                , lued.verilog.clkn)
lued.def_snippet(s, "clk1"                , lued.verilog.clk1)
lued.snippets.verilog = s


