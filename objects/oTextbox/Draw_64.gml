draw_self();

// Draw text input from player
draw_set_valign(fa_middle);
draw_set_color(c_black);

if active
	draw_text(x + 16, y + 16, message + cursor);
else
{
	if message == ""
	{
		draw_text_color(x + 16, y + 16, text, c_gray, c_gray, c_gray, c_gray, 0.8);
	}
	else
		draw_text(x + 16, y + 16, message);
}

draw_set_valign(fa_top);
draw_set_color(c_white);