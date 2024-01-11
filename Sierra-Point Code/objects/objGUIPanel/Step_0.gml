#region MOUSE OVER & BLEND
mouseOver = point_in_rectangle(gui_mouse_x(), gui_mouse_y(), buttonLeft, buttonTop, buttonRight, buttonBottom);

if(mouseOver){
    image_blend = c_white;
	fontColor = c_yellow;
}else{
    image_blend = c_ltgray;
	fontColor = c_white;
}

#endregion

#region COLLISION SETUP

gui_setup_collision(origin);

#endregion

