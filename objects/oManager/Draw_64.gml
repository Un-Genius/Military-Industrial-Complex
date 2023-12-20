#region Draw chat box

var qPos = 1;
var _lines = 0;
	
// Add buffer
var baseString = string_insert(" ", chat_text, 0)
	
while(qPos != 0)
{
	baseString = string_delete(baseString, 1, qPos);
	qPos = string_pos("\n", baseString);
	_lines++;
}

// Draw background
draw_sprite(spr_chat, -1, chatX - padding, chatY - sprite_get_height(spr_chat) + padding);

draw_set_color(c_dkgray);
draw_set_alpha(0.4);
	draw_rectangle(chatX - padding,		chatY + padding,	 chatX + sprite_get_width(spr_chat) - padding,	   chatY + padding +	 ((fntSize + padding) * _lines) + padding, false);
draw_set_alpha(1);
	draw_rectangle(chatX - padding,		chatY + padding,	 chatX + sprite_get_width(spr_chat) - padding,	   chatY + padding +	 ((fntSize + padding) * _lines) + padding, true);
	draw_rectangle(chatX - padding + 1, chatY + padding + 1, chatX + sprite_get_width(spr_chat) - padding - 1, chatY + padding - 1 + ((fntSize + padding) * _lines) + padding, true);
	draw_rectangle(chatX - padding + 2, chatY + padding + 2, chatX + sprite_get_width(spr_chat) - padding - 2, chatY + padding - 2 + ((fntSize + padding) * _lines) + padding, true);

var _drawSize = ds_list_size(global.chat);

if _drawSize > chatHistory
	_drawSize = chatHistory;

#region Draw chat room

for(var i = 0; i < _drawSize; i++)
{
	// Get text
	var _chat_text = ds_list_find_value(global.chat, i);
	
		// Draw text
	draw_set_color(ds_list_find_value(global.chat_color, i));
		draw_text(chatX, chatY - (fntSize*(i+1)) - (5*(i+1)) - 2, _chat_text);
	draw_set_color(c_white);
}

if active
{
	draw_set_color(make_color_rgb(240, 215, 158));
		draw_text(chatX, chatY + 14, "> " + chat_text);
	draw_set_color(c_white);
}
else
{
	draw_set_color(c_gray);
		draw_text(chatX, chatY + 14, "> ");
	draw_set_color(c_white);
}
	
#endregion

#endregion

#region Debug

if(keyboard_check_pressed(vk_f1))
	if global.debugMenu == 1
		global.debugMenu = 0;
	else
		global.debugMenu = 1;
		
if(keyboard_check_pressed(vk_f2))
	if global.debugMenu == 2
		global.debugMenu = 0;
	else
		global.debugMenu = 2;

if(global.debugMenu > 0)
{
	// Left GUI side
	var _Lx			= 25;
	var _Ly			= 15;	
	var _LInc		= 22;	// Left Increment Amount
	var _LIncStep	= 0;	// Left Increment Step
	
	var _L2x		= _Lx + 300;
	var _L2y		= _Ly;	
	var _L2Inc		= _LInc;
	var _L2IncStep	= _LIncStep;
	
	// Right GUI side
	var _Rx			= global.RES_W - 300;
	var _Ry			= _Ly;	
	var _RInc		= _LInc;
	var _RIncStep	= _LIncStep;
	
	draw_text(_Lx, _Ly + (_LInc * _LIncStep), "Displaying Debugmode: " + string(global.debugMenu));
	_LIncStep += 2;
	_L2IncStep += 2;
	
	switch global.debugMenu
	{		
		case 1:
			#region Mouse UI
			draw_text(_Lx, _Ly + (_LInc * _LIncStep), "Mouse over UI: ");
			
			if(global.mouse_on_ui)
			{
				// Draw active
				draw_text_color(_Lx + 150, _Ly + (_LInc * _LIncStep), "TRUE", c_green, c_green, c_green, c_green, 1);
				_LIncStep++;
			}
			else
			{
				// Draw inactive
				draw_text_color(_Lx + 150, _Ly + (_LInc * _LIncStep), "FALSE", c_red, c_red, c_red, c_red, 1);
				_LIncStep++;
			}
			
			#endregion
			
			#region Controls
	
			draw_text(_Lx, _Ly + (_LInc * _LIncStep), "Controls -----");
			_LIncStep++;

			#region Zoning
	
			if(instance_exists(oPlayer))
			{
				draw_text(_Lx, _Ly + (_LInc * _LIncStep), "Press a number to Toggle Zoning: ");

				if(oPlayer.zoning)
				{
					// Draw active
					draw_text_color(_Lx + 330, _Ly + (_LInc * _LIncStep), "ACTIVE", c_green, c_green, c_green, c_green, 1);
					_LIncStep++;
					
					switch(oPlayer.zoning)
					{
						case objectType.oZoneCamp:
							draw_text(_Lx, _Ly + (_LInc * _LIncStep), "Zoning Camps");
							_LIncStep++;
						break;
						
						case objectType.oZoneMoney:
							draw_text(_Lx, _Ly + (_LInc * _LIncStep), "Zoning Money");
							_LIncStep++;
						break;
						
						case objectType.oZoneSupplies:
							draw_text(_Lx, _Ly + (_LInc * _LIncStep), "Zoning Supplies");
							_LIncStep++;
						break;
				
						case objectType.oZoneBootCamp:
							draw_text(_Lx, _Ly + (_LInc * _LIncStep), "Zoning BootCamp");
							_LIncStep++;
						break;
					}
				}
				else
				{
					// Draw inactive
					draw_text_color(_Lx + 330, _Ly + (_LInc * _LIncStep), "INACTIVE", c_red, c_red, c_red, c_red, 1);
					_LIncStep++;
				}
			}
	
			#endregion
	
			#endregion
	
			#region Stats
	
			draw_text(_Rx, _Ry + (_RInc * _RIncStep), "Overall Instaces -----");
			_RIncStep++;
		
			#region Instances
	
			if(instance_exists(oParZoneLocal))
			{
				draw_text(_Rx, _Ry + (_RInc * _RIncStep), "Local Instances: " + string(instance_number(oParZoneLocal)));
				_RIncStep++;
			}
	
			if(instance_exists(oParZoneNet))
			{
				draw_text(_Rx, _Ry + (_RInc * _RIncStep), "Net Instances: " + string(instance_number(oParZoneNet)));
				_RIncStep++;
			}
	
			#endregion
	
			#endregion
		break;
		
		case 2:						
			#region Instances that Exist
	
			if(instance_exists(oParZoneLocal))
			{
				draw_text(_Lx, _Ly + (_LInc * _LIncStep), "Local: " + string(instance_number(oParZoneLocal)));
				_LIncStep++;
				
				for(var i = 0; i < instance_number(oParZoneLocal); i++)
				{
					var _inst = instance_find(oParZoneLocal, i);
					draw_text(_Lx, _Ly + (_LInc * _LIncStep), string(i) + ": " + string(object_get_name(_inst.object_index)) + " - " + string(_inst));
					_LIncStep++;
				}
			}
	
			if(instance_exists(oParZoneNet))
			{
				draw_text(_Rx, _Ry + (_RInc * _RIncStep), "Net: " + string(instance_number(oParZoneNet)));
				_RIncStep++;
				
				for(var i = 0; i < instance_number(oParZoneNet); i++)
				{
					var _inst = instance_find(oParZoneNet, i);
					draw_text(_Rx, _Ry + (_RInc * _RIncStep), string(i) + ": " + string(object_get_name(_inst.object_index)) + " - " + string(_inst));
					_RIncStep++;
				}
			}
			
			#endregion
		break;
	}
}
#endregion

// Draw Loading text
if state == menu.public && steam_lobby_list_is_loading()
	draw_sprite(spr_loading, -1, global.RES_W/2 - 170, 77.5)