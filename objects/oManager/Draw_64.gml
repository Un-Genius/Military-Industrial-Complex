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

// Draw Loading text
if state == menu.public && steam_lobby_list_is_loading()
	draw_sprite(spr_loading, -1, global.RES_W/2 - 170, 77.5)