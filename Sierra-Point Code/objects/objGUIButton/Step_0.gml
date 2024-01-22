event_inherited();

#region HOVER AND CLICK

if( enabled )
{
    if( !mouseOver )
	{
        if( !stayPressed && !toggled )
		{
            buttonPressed = false;
        }
    }
	else
	{
        if( mouse_check_button_pressed(mb_left) )
		{
            if( toggled )
			{
				// Action for untoggling
				if buttonPressed
					event_user(1)
				
				// Flip flop logic
                buttonPressed = !buttonPressed;
            }
			else 
			if( stayPressed )
			{
                if(!buttonPressed)
				{
                    buttonPressed = true;
                    event_perform(ev_other, ev_user0); // execute command
                }
            }
			else
			{
                buttonPressed = true;
            }
			
	        if( buttonPressed )
			{
	            if( toggled )
				{
					// Turning on
	                event_perform(ev_other, ev_user0); // execute command
	            }
				else
				if( stayPressed )
				{
	                // execute command
	            }
				else
				{
	                buttonPressed = false;
	                event_perform(ev_other, ev_user0); // execute command
	            }
	        }
		}
    }
}else{
    image_blend = c_gray;
}

#endregion

#region SPRITE

if(!buttonPressed){
    sprite_index = guiSprite;
}else{
    sprite_index = guiSpritePressed;
}

#endregion