draw_self();
draw_set_font(ftMoney);
if resources.supplies > 0
	draw_text_color(x + 8, y - 1, "Supplies: +" + string(resources.supplies), c_green, c_green, c_green, c_green, image_alpha);
draw_set_font(ftDefault);