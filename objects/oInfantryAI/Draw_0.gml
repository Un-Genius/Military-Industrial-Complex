if selected
	draw_circle_color(x, y, 2, c_yellow, c_yellow, true)

draw_self();

if(global.debugMenu)
{
	draw_set_font(ftSmall);
		draw_text(x+4, y, "State: " + string(sm.state_name));
	draw_set_font(ftDefault);
}