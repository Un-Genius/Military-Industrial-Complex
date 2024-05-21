#region Debug

if(keyboard_check_pressed(vk_f1))
	if global.debug == 1
		global.debug = 0;
	else
		global.debug = 1;
		
if(keyboard_check_pressed(vk_f2))
	if global.debug == 2
		global.debug = 0;
	else
		global.debug = 2;

if(global.debug > 0)
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
	
	draw_text(_Lx, _Ly + (_LInc * _LIncStep), "Displaying Debugmode: " + string(global.debug));
	_LIncStep += 2;
	_L2IncStep += 2;
	
	switch global.debug
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
						case OBJ_NAME.SITE_PRO_SUPPLIES:
							draw_text(_Lx, _Ly + (_LInc * _LIncStep), "Zoning Camps");
							_LIncStep++;
						break;
						
						case OBJ_NAME.SITE_PRO_WEAPONS:
							draw_text(_Lx, _Ly + (_LInc * _LIncStep), "Zoning Money");
							_LIncStep++;
						break;
						
						case OBJ_NAME.SITE_CAP_SUPPLIES:
							draw_text(_Lx, _Ly + (_LInc * _LIncStep), "Zoning Supplies");
							_LIncStep++;
						break;
				
						case OBJ_NAME.SITE_PRO_INF:
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
	
			if(instance_exists(oParSiteLocal))
			{
				draw_text(_Rx, _Ry + (_RInc * _RIncStep), "Local Instances: " + string(instance_number(oParSiteLocal)));
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
	
			if(instance_exists(oParSiteLocal))
			{
				draw_text(_Lx, _Ly + (_LInc * _LIncStep), "Local: " + string(instance_number(oParSiteLocal)));
				_LIncStep++;
				
				for(var i = 0; i < instance_number(oParSiteLocal); i++)
				{
					var _inst = instance_find(oParSiteLocal, i);
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