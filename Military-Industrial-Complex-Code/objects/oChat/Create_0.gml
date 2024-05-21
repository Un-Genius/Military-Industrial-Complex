global.chat = ds_list_create();
global.chat_color = ds_list_create();

ds_list_add(global.chat, "Welcome to the game", "Alpha " + string(GM_version));
ds_list_add(global.chat_color, c_white, c_olive);

chatX = global.RES_W - 500;
chatY = global.RES_H - 100;

chatSize = 5;
chatHistory = 8;
active = false; // on/off switch
chat_text = "";	// chat message
nextSpace = 0;

width = 350;
padding = 10;

fntSize = font_get_size(ftDefault);