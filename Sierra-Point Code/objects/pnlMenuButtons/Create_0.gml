event_inherited();
///SETUP & CREATE BUTTONS
var offset = 20;
var btnWidth = 300;
var btnHeight = 100;
var btnOffset = 5;

width = (offset*2) + btnWidth;
height = (offset*2) + btnHeight + ((btnHeight+btnOffset) * 1);

var wx = x + offset;
var wy = y + offset;
var inst;

gui_create_button(wx, wy, btnWidth, btnHeight, "Start", func_start_game);

//wy += btnHeight + btnOffset;
//inst = gui_create_button(wx, wy, btnWidth, btnHeight, "With Companion", alert, "Toggled 1 clicked");
//inst.toggled = true;

wy += btnHeight + btnOffset;
inst = gui_create_button(wx, wy, btnWidth, btnHeight, "Main Menu", func_room_goto, roomMainFramework);




