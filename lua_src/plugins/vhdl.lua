-- vhdl.lua

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
  
  -- entity xxx is
  newline[1] = string.gsub(line, "^%s*entity%s+([_%w]+)%s+is", "u_%1: entity work.%1")

  -- port (
  newline[2] = string.gsub(line, "^%s*port.*", "port map (")

  -- clk: in std_logic;
  local next_line = get_next_line() or "" -- peek ahead for close paren 
  local paren_start = string.find(next_line, "^%s*%)%s*;",1) or 0
  local comma = (paren_start==0) and "," or "" 
  newline[3] = string.gsub(line, "^%s*([_%w]+)%s*:%s*(%w%w.)%s*(std_logic[^;]*)", "   %1 => %1"..comma.."  -- %2 %3")

  -- end xxx;
  newline[4] = string.gsub(line, "^%s*end", "-- %0")

  for i=1,4 do
    if (newline[i]~=line) then
      replace_line(newline[i],dd2)
      break
    end
  end

  line_down(1,dd2)
  sol_classic(dd2)

  disp(dd)  
end


function vhdl_inst_selected(dd)
  foreach_selected(vhdl_inst, dd)
end



alt_vhdl_inst = vhdl_inst_selected hot("vhdl_inst")

