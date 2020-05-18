--[[
MIT License

Copyright (c) 2018 JWRR.COM

git clone https://github.com/jwrr/lued.git

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]


lued.csi = {}

local fg = {}
local bg = {}
for i=0,7 do
  fg[i]      = tostring(30+i)
  fg[i+8]    = tostring(90+i)
  bg[i]      = tostring(40+i)
  bg[i+8]    = tostring(100+i)
end

lued.csi.fg = fg
lued.csi.bg = bg



function lued.set_style(fg,bg,decorations)
-- lued.csi.normal  = "0"
-- lued.csi.reset   = "0"
-- lued.csi.bold    = "1"
-- lued.csi.under   = "4"
-- lued.csi.blink   = "5"
-- lued.csi.inverse = "7"
--    local CSI = "esc["
  local CSI = string.char(27) .. '['

  local code = ""
  if decorations ~= nil then
    if type(decorations)=="table" then
      for i=1,#decorations do
        code = code=="" and CSI or code..";"
        code = code .. tostring(decorations[i])
      end
    else
      code = code=="" and CSI or code..";"
      code = code .. tostring(decorations)
    end
  end
  if fg ~= nil then
    local fg_code = tostring( fg<8 and fg+30 or fg+90-8 )
    code = code=="" and CSI or code..";"
    code = code .. fg_code
  end
  if  bg ~= nil then
    local bg_code = tostring( bg<8 and bg+40 or bg+100-8 )
    code = code=="" and CSI or code..";"
    code = code .. bg_code
  end
  code = code=="" and "" or code.."m"

--    lued.dbg_prompt("code="..code.."dec="..decorations.."xxx")
  return code;
end


local styles = {}
styles.enable               = false
styles.reset                = lued.set_style( nil, nil, 0 )
styles.normal               = lued.set_style( nil, nil, 0 )
styles.inverse              = lued.set_style( nil, nil, 7 ) -- inverse
styles.cursor               = lued.set_style( nil, nil, {1,5,7} ) -- bold,blink,inverse
--     lued.dbg_prompt("code="..styles.cursor.."xxx"); os.exit()
styles.cursor_line          = lued.set_style( nil, 8  , nil )
styles.line_number          = lued.set_style( 8,  nil , 0)
styles.cursor_line_number   = lued.set_style( 15, 8   , 0)
styles.sb_files             = lued.set_style( 7, nil   , 0)
styles.comment              = lued.set_style( 8,  nil , 0 )
styles.comment_regex        = "//[^\n]*"
styles.comment_regex2       = "%-%-[^\n]*"
styles.comment_regex3       = "%-%-[^\n]*"
styles.string               = lued.set_style( 3,  nil       , 0 )
styles.string_regex         = "[\"][^\"][\"]"

-- Lua Magic: (   )   .   %   +   –   *   ?   [   ^   $

styles.fg0                  = lued.set_style ( 0, nil , 0)
styles.fg1                  = lued.set_style ( 1, nil , 0)
styles.fg2                  = lued.set_style ( 2, nil , 0)
styles.fg3                  = lued.set_style ( 3, nil , 0)
styles.fg4                  = lued.set_style ( 4, nil , 0)
styles.fg5                  = lued.set_style ( 5, nil , 0)
styles.fg6                  = lued.set_style ( 6, nil , 0)
styles.fg7                  = lued.set_style ( 7, nil , 0)
styles.fg8                  = lued.set_style ( 8, nil , 0)
styles.fg9                  = lued.set_style ( 9, nil , 0)
styles.fg10                 = lued.set_style ( 10, nil , 0)
styles.fg11                 = lued.set_style ( 11, nil , 0)
styles.fg12                 = lued.set_style ( 12, nil , 0)
styles.fg13                 = lued.set_style ( 13, nil , 0)
styles.fg14                 = lued.set_style ( 14, nil , 0)
styles.fg15                 = lued.set_style ( 15, nil , 0)
styles.bg0                  = lued.set_style ( nil, 0  ,  0)
styles.bg1                  = lued.set_style ( nil, 1  ,  0)
styles.bg2                  = lued.set_style ( nil, 2  ,  0)
styles.bg3                  = lued.set_style ( nil, 3  ,  0)
styles.bg4                  = lued.set_style ( nil, 4  ,  0)
styles.bg5                  = lued.set_style ( nil, 5  ,  0)
styles.bg6                  = lued.set_style ( nil, 6  ,  0)
styles.bg7                  = lued.set_style ( nil, 7  ,  0)
styles.bg8                  = lued.set_style ( nil, 8  ,  0)
styles.bg9                  = lued.set_style ( nil, 9  ,  0)
styles.bg10                  = lued.set_style ( nil, 10  ,  0)
styles.bg11                  = lued.set_style ( nil, 11  ,  0)
styles.bg12                  = lued.set_style ( nil, 12  ,  0)
styles.bg13                  = lued.set_style ( nil, 13  ,  0)
styles.bg14                  = lued.set_style ( nil, 14  ,  0)
styles.bg15                  = lued.set_style ( nil, 15  ,  0)


-- lued.dbg_prompt("\n" ..
--            styles.fg0 .. "000000" ..
--            styles.fg1 .. "111111" ..
--            styles.fg2 .. "222222" ..
--            styles.fg3 .. "333333" ..
--            styles.fg4 .. "444444" ..
--            styles.fg5 .. "555555" ..
--            styles.fg6 .. "666666" ..
--            styles.fg7 .. "777777" .. "\n" ..
--            styles.fg8 .. "888888" ..
--            styles.fg9 .. "999999" ..
--            styles.fg10 .. "aaaaaa" ..
--            styles.fg11 .. "bbbbbb" ..
--            styles.fg12 .. "cccccc" ..
--            styles.fg13 .. "dddddd" ..
--            styles.fg14 .. "eeeeee" ..
--            styles.fg15 .. "ffffff" .. "\n" ..
--            styles.bg0 .. "0     " ..
--            styles.bg1 .. "1     " ..
--            styles.bg2 .. "2     " ..
--            styles.bg3 .. "3     " ..
--            styles.bg4 .. "4     " ..
--            styles.bg5 .. "5     " ..
--            styles.bg6 .. "6     " ..
--            styles.bg7 .. "7     " .. "\n" ..
--            styles.bg8 .. "8     " ..
--            styles.bg9 .. "9     " ..
--            styles.bg10 .. "a     " ..
--            styles.bg11 .. "b     " ..
--            styles.bg12 .. "c     " ..
--            styles.bg13 .. "d     " ..
--            styles.bg14 .. "e     " ..
--            styles.bg15 .. "f     "
--           )
--


function lued.sidebar(lines) -- Dummy function, usually replaced by base.sidebar
  return lines
end


function lued.style_page(lines, first_line_of_page, row_offset)

  -- ensure all styles are define
  styles.enable = styles.enable or false
  styles.normal = styles.normal or ""
  styles.cursor_line = styles.cursor_line or ""
  styles.line_number = styles.line_number or ""
  styles.cursor_line_number = styles.cursor_line_number or ""
  styles.cursor = styles.cursor or ""


  -- do nothing if not showing lnum and no style
--  if not g_show_abs_line_numbers and not styles.enable then
--    return lines
--  end

  -- subtract one because for loop adds one
  first_line_of_page = first_line_of_page-1

  -- set the first and last lines to include all lines or just current line
  local update_only_cursor_line = false -- FIXME not g_show_abs_line_numbers and styles.normal==""
  local start_line = update_only_cursor_line and row_offset or 1
  local stop_line = update_only_cursor_line and row_offset or #lines

  local comment_from = "(" .. styles.comment_regex .. ")";
  local comment_to = styles.comment .. "%1" .. styles.normal
  local string_from = "(" .. styles.string_regex .. ")"
  local string_to   = styles.comment .. "%1" .. styles.normal

  for ii=start_line,stop_line do
    local line_style = styles.enable and styles.normal or ""
    local lnum_style = styles.enable and styles.line_number or ""

    if ii==row_offset then
      local curs_style = styles.enable and styles.cursor or ""
      if curs_style~="" then
        lines[ii] = lued.psub(lines[ii], styles.inverse, curs_style, 1)
      end

      line_style = styles.enable and line_style .. styles.cursor_line or ""
      lnum_style = styles.enable and styles.cursor_line_number or ""
    else

      if styles.comment~="" then
        lines[ii] = string.gsub(lines[ii], comment_from, comment_to )
      end

      if styles.string~="" then
        lines[ii] = string.gsub(lines[ii], string_from, string_to )
      end
    end

    local t={}
    if line_style~="" then
     lines[ii] = line_style .. lued.psub(lines[ii], styles.reset, line_style) .. styles.normal
    end
    
    if g_show_abs_line_numbers or g_show_rel_line_numbers then
      local abs_ln = first_line_of_page+ii
      local rel_ln = math.abs(row_offset-ii) 
      local tmp = g_show_abs_line_numbers and abs_ln or rel_ln
      tmp = tmp==0 and abs_ln or tmp
      local linenum_str = string.format("  %4d  ", tmp)
      lines[ii] = lnum_style .. linenum_str .. styles.reset .. lines[ii]
    end
    
    if g_show_sb_files then
      lines = lued.sidebar(lines)
    end

    lines[ii] = styles.reset .. lines[ii]

  end -- for each line
  return lines
end


function lued.make_line_bold_orig(lnum1,lnum2)
  local esc_bold = ""
  if g_bold_current_line and lnum1==lnum2 then
    esc_bold = string.char(27) .. "[1m"
  end
  return esc_bold
end









