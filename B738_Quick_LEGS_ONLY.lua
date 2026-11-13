-- ================================================================
-- B738 QUICK LEGS ONLY - Standalone cleaned test edition
-- Derived from ChrisInUT's B738-FMC-Popup (MIT, copyright 2022).
-- Based on the successfully flight-tested QUICK LEGS comment-out build.
-- Original source and license: https://github.com/ChrisInUT/B738-FMC-Popup
-- ================================================================
-- CUSTOM SKIN / MOUSE HOT AREAS
-- Replace B738_Quick_LEGS.png with your own PNG if desired.
-- Coordinates below belong to the ImGui client area, NOT screen pixels.
-- X, Y: upper-left corner; W, H: width and height in pixels.
-- To reposition the invisible PREV/NEXT buttons, edit only these values.
-- The values below are the proven default positions and are unchanged.
-- For different PNG sizes/layouts you may also need to adjust the
-- imgui.Image dimensions, display text offsets, and window dimensions.
-- Do not rename the PNG unless you also change its filename below.
-- ================================================================
local QUICK_PREV_X, QUICK_PREV_Y, QUICK_PREV_W, QUICK_PREV_H = 145, 387, 72, 60
local QUICK_NEXT_X, QUICK_NEXT_Y, QUICK_NEXT_W, QUICK_NEXT_H = 280, 387, 73, 60

-- v0.3.16 CLEAN TEST | based on flight-tested v0.3.14 geometry
-------------------------------------
-- Only runs for the Zibo 737-800 aircraft ICAO type.
if PLANE_ICAO == "B738" then

	if not SUPPORTS_FLOATING_WINDOWS then
		-- to make sure the script doesn't stop old FlyWithLua versions
		logMsg("imgui not supported by your FlyWithLua version")
		return
	end

	blank_string = create_dataref_table("B738_fmc_display/blank_line" , "Data" )
	blank_string[0] = "                        "

	-- Original CDU text rendering metrics (preserved unchanged).

	local screen_left = 86
	local screen_top = 61	

	local font_scale_large = 2
	local font_scale_small = 1.375

	local column_x_start = 4	
	local column_x_inc = 14
	local line_y_start = 14
	local line_y_inc = 2.175

	-- Retrieve the passed dataref, upcase, and then return it.
	function read_dataref(dataref_name)
		temp = get("B738_fmc_display/blank_line")
		return string.upper(get(dataref_name))
	end

	-- Optional magenta overlay. If the DataRef is absent, retain original display.
	function read_optional_fmc_magenta(line_number)
		local name = string.format("laminar/B738/fmc1/Line%02d_M", line_number)
		local ok, value = pcall(function() return read_dataref(name) end)
		if ok and type(value) == "string" then return value end
		return ""
	end

	function draw_fmc_line(offset, text, style)
		local color_index = 0xFFFFFFFF
		if string.len(text) > 0 then
			for i=1, string.len(text) do
				if i < 25 then
					local display_text = string.sub(text,i,i)
					if style == "large" then
						-- Set text color to white
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFFFFFF)
						
						-- Set the font scale
						imgui.SetWindowFontScale(font_scale_large)

					elseif style == "largec" then
						-- Set text color to cyan
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFC0C000)
						
						-- Set the font scale
						imgui.SetWindowFontScale(font_scale_large)

					elseif style == "largem" then
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFF00FF)
						imgui.SetWindowFontScale(font_scale_large)

					elseif style == "largeg" then
						-- Set text color to green
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF00FF00)
						
						-- Set the font scale
						imgui.SetWindowFontScale(font_scale_large)				

					else
						-- Set text color to white
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFFFFFF)
						
						-- Set the font scale
						imgui.SetWindowFontScale(font_scale_small)

					end
					if display_text == "*" then
						if style == "largec" then
							color_index = 0xFFC0C000
						elseif style == "largeg" then
							color_index = 0xFF00FF00
						elseif style == "largem" then
							color_index = 0xFFFF00FF
						else
							color_index = 0xFFFFFFFF
						end
						text_width, text_height = imgui.CalcTextSize("L")
						x_left = screen_left + column_x_start + (column_x_inc * (i - 1)) + (column_x_inc - text_width) / 2 + 2
						y_top = screen_top + line_y_start + (line_y_inc * (offset + 4)) - 5
						x_right = x_left + text_width - 2
						y_bottom = y_top - text_height + 11
						imgui.DrawList_AddRect(x_left, y_top, x_right, y_bottom, color_index, 0)
					elseif display_text == "`" then
						text_width, text_height = imgui.CalcTextSize("L")
						x_center = screen_left + column_x_start + (column_x_inc * (i - 1)) + column_x_inc / 2 - 3
						if string.sub(style,1,5) == "large" then
							y_center = screen_top + line_y_start + (line_y_inc * offset) - 8
							deg_rad = 3
						else
							y_center = screen_top + line_y_start + (line_y_inc * offset) - 3
							deg_rad = 2
						end
						imgui.DrawList_AddCircle(x_center, y_center, deg_rad, color_index, 20, 1.5)
					else
						-- Get char height and width
						text_width, text_height = imgui.CalcTextSize(display_text)
						
						-- Calculate the position for the text
						imgui.SetCursorPos(screen_left + column_x_start + (column_x_inc * (i - 1)) + ((column_x_inc - text_width) / 2), screen_top + line_y_start + (line_y_inc * (offset + 4)) - text_height)
						
						-- Display the text
						imgui.TextUnformatted(display_text)
					end
				end
			end
		end
		-- Reset the font properties
		imgui.SetWindowFontScale(1.0)
		imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFFFFFF)
	end

	-- v0.3.14: Positions measured by v0.3.14 in the user's X-Plane window.
	-- Geometry uses X-Plane coordinates: left, top, right, bottom.
	-- Positioning is best-effort; a failed API call must not block the hotkeys.
	local function fmc_apply_measured_position(wnd, left, top, right, bottom)
		if wnd and type(float_wnd_set_geometry) == "function" then
			local ok = pcall(float_wnd_set_geometry, wnd, left, top, right, bottom)
			if not ok then
				-- Keep window placement best-effort; do not interrupt the display.
			end
		end
	end

	

	-- QUICK LEGS: standalone compact view; the full FMC code is intentionally omitted.
	-- Reuses the original FMC line renderer with compact-display offsets.
	local quick_legs_original_image_id = float_wnd_load_image(SCRIPT_DIRECTORY .. "/B738_Quick_LEGS.png")
	local quick_legs_wnd = nil
	local quick_legs_visible = false

	function quick_legs_on_build(wnd, x, y)
		imgui.PushStyleColor(imgui.constant.Col.WindowBg, 0xFF000000)
		-- QUICK LEGS PNG artwork developed for this derivative from Chris's CDU concept.
		imgui.Image(quick_legs_original_image_id, 498, 465)
		local old_left, old_top = screen_left, screen_top
		screen_left, screen_top = 86, 61
		local page_label_large_cyan = read_dataref("laminar/B738/fmc1/Line00_C")
		local page_label_large_green = read_dataref("laminar/B738/fmc1/Line00_G")
		local page_label_large = read_dataref("laminar/B738/fmc1/Line00_L")
		local page_label_small = read_dataref("laminar/B738/fmc1/Line00_S")
		local label_line_1_small = read_dataref("laminar/B738/fmc1/Line01_X")
		local label_line_1_large = read_dataref("laminar/B738/fmc1/Line01_LX")
		local line_1_large_green = read_dataref("laminar/B738/fmc1/Line01_G")	
		local line_1_large = read_dataref("laminar/B738/fmc1/Line01_L")
		local line_1_small = read_dataref("laminar/B738/fmc1/Line01_S")
		local label_line_2_small = read_dataref("laminar/B738/fmc1/Line02_X")
		local line_2_large_green = read_dataref("laminar/B738/fmc1/Line02_G")
		local line_2_large = read_dataref("laminar/B738/fmc1/Line02_L")
		local line_2_small = read_dataref("laminar/B738/fmc1/Line02_S")
		local label_line_3_small = read_dataref("laminar/B738/fmc1/Line03_X")
		local line_3_large_green = read_dataref("laminar/B738/fmc1/Line03_G")
		local line_3_large = read_dataref("laminar/B738/fmc1/Line03_L")
		local line_3_small = read_dataref("laminar/B738/fmc1/Line03_S")
		local label_line_4_small = read_dataref("laminar/B738/fmc1/Line04_X")
		local line_4_large_green = read_dataref("laminar/B738/fmc1/Line04_G")
		local line_4_large = read_dataref("laminar/B738/fmc1/Line04_L")
		local line_4_small = read_dataref("laminar/B738/fmc1/Line04_S")
		local label_line_5_small = read_dataref("laminar/B738/fmc1/Line05_X")
		local line_5_large_green = read_dataref("laminar/B738/fmc1/Line05_G")
		local line_5_large = read_dataref("laminar/B738/fmc1/Line05_L")
		local line_5_small = read_dataref("laminar/B738/fmc1/Line05_S")
		local label_line_6_small = read_dataref("laminar/B738/fmc1/Line06_X")
		local label_line_6_large = read_dataref("laminar/B738/fmc1/Line06_LX")
		local line_6_large_green = read_dataref("laminar/B738/fmc1/Line06_G")
		local line_6_large = read_dataref("laminar/B738/fmc1/Line06_L")
		local line_6_small = read_dataref("laminar/B738/fmc1/Line06_S")
		local entry_line_large = read_dataref("laminar/B738/fmc1/Line_entry")
		
		-- Draw the lines of text on the display.
		draw_fmc_line(000, string.sub(page_label_large_cyan,1,16), "largec")
		draw_fmc_line(000, page_label_large_green, "largeg")
		draw_fmc_line(000, page_label_large, "large")
		draw_fmc_line(-001, page_label_small, "small")
		draw_fmc_line(007, label_line_1_small, "small")
		draw_fmc_line(008, label_line_1_large, "large")
		draw_fmc_line(016, line_1_small, "small")
		draw_fmc_line(018, line_1_large_green, "largeg")
		draw_fmc_line(018, line_1_large, "large")
		draw_fmc_line(018, read_optional_fmc_magenta(1), "largem")
		draw_fmc_line(025, label_line_2_small, "small")
		draw_fmc_line(034, line_2_small, "small")
		draw_fmc_line(036, line_2_large_green, "largeg")
		draw_fmc_line(036, line_2_large, "large")
		draw_fmc_line(036, read_optional_fmc_magenta(2), "largem")
		draw_fmc_line(043, label_line_3_small, "small")
		draw_fmc_line(052, line_3_small, "small")
		draw_fmc_line(054, line_3_large_green, "largeg")
		draw_fmc_line(054, line_3_large, "large")
		draw_fmc_line(054, read_optional_fmc_magenta(3), "largem")
		draw_fmc_line(061, label_line_4_small, "small")
		draw_fmc_line(070, line_4_small, "small")
		draw_fmc_line(072, line_4_large_green, "largeg")
		draw_fmc_line(072, line_4_large, "large")
		draw_fmc_line(072, read_optional_fmc_magenta(4), "largem")
		draw_fmc_line(079, label_line_5_small, "small")
		draw_fmc_line(088, line_5_small, "small")
		draw_fmc_line(090, line_5_large_green, "largeg")
		draw_fmc_line(090, line_5_large, "large")
		draw_fmc_line(090, read_optional_fmc_magenta(5), "largem")
		draw_fmc_line(097, label_line_6_small, "small")
		draw_fmc_line(098, label_line_6_large, "large")
		draw_fmc_line(106, line_6_small, "small")
		draw_fmc_line(108, line_6_large_green, "largeg")	
		draw_fmc_line(108, line_6_large, "large")
		draw_fmc_line(108, read_optional_fmc_magenta(6), "largem")	
		draw_fmc_line(118, entry_line_large, "large")

		screen_left, screen_top = old_left, old_top
		-- Only two interactive controls are created in this view.
		imgui.PushStyleColor(imgui.constant.Col.Button, 0x00000000)
		imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, 0x00000000)
		imgui.PushStyleColor(imgui.constant.Col.ButtonActive, 0x00000000)
		imgui.SetCursorPos(QUICK_PREV_X, QUICK_PREV_Y)
		if imgui.Button("##quick_prev_page", QUICK_PREV_W, QUICK_PREV_H) then
			command_once("laminar/B738/button/fmc1_prev_page")
		end
		imgui.SetCursorPos(QUICK_NEXT_X, QUICK_NEXT_Y)
		if imgui.Button("##quick_next_page", QUICK_NEXT_W, QUICK_NEXT_H) then
			command_once("laminar/B738/button/fmc1_next_page")
		end
		imgui.PopStyleColor(3)
		imgui.PopStyleColor()
	end

	function toggle_quick_legs()
		if quick_legs_visible then
			if quick_legs_wnd then float_wnd_destroy(quick_legs_wnd) end
			quick_legs_wnd = nil
			quick_legs_visible = false
		else
			-- Select LEGS on Captain CDU; uses the author's existing Zibo command.
			command_once("laminar/B738/button/fmc1_legs")
			quick_legs_wnd = float_wnd_create(514, 482, 1, true)
			float_wnd_set_title(quick_legs_wnd, "B738 QUICK LEGS - v0.3.16 CLEAN TEST")
			float_wnd_set_imgui_builder(quick_legs_wnd, "quick_legs_on_build")
			float_wnd_set_resizing_limits(quick_legs_wnd, 514, 482, 514, 482)
			fmc_apply_measured_position(quick_legs_wnd, 2013, 1268, 2511, 768)
			quick_legs_visible = true
		end
	end

	

	-- QUICK LEGS ONLY hotkey: preserve Option+L from original handler.
	function fmc_on_keystroke()
		if CKEY == "l" and OPTION_KEY == true and KEY_ACTION == "pressed" then
			toggle_quick_legs()
		end
	end

	do_on_keystroke("fmc_on_keystroke()")
	
end
