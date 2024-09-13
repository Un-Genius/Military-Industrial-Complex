/// @description DRAW FRAME
if( sprite_index != -1 ){
	draw_sprite_stretched_ext(	sprite_index, 0, 
								buttonLeft, buttonTop, buttonRight-buttonLeft, buttonBottom-buttonTop, 
								image_blend, image_alpha );
}


#region DRAW ICON

if( icon != -1 ){
    if( buttonPressed ){
        draw_sprite_ext(icon, iconIndex, buttonX + (width-35), buttonY + (height/2), 0.5, 0.5, 0, image_blend, image_alpha);
    }else{
        draw_sprite_ext(icon, iconIndex,buttonX + (width-35), buttonY + (height/2)-pressedOffset, 0.5, 0.5, 0, image_blend, image_alpha);
    }
}

#endregion


#region DRAW TEXT
if( text != "" ){
    draw_set_font_ext(fontType, fontColor, fontAlign, fa_middle, 1);
    
    var textX = 0;
    var textY = 0;
    
    if(origin == "CENTER"){
        textX = buttonX;
        textY = buttonY;
    }else{
        if( fontAlign == fa_center ){
            textX = buttonX + (width div 2);
            textY = buttonY + (height div 2);
        }else if( fontAlign == fa_left ){
            textX = buttonX + 15;
            textY = buttonY + (height div 2);
        }
    }
    
    if( buttonPressed ){
        draw_text_outline( textX, textY+pressedOffset, text, -1, 1000, c_black, fontScale );
    }else{
        draw_text_outline( textX, textY, text, -1, 1000, c_black, fontScale );
    }
}

#endregion