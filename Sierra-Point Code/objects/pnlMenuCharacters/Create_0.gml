event_inherited();
///SETUP & CREATE BUTTONS & OTHER PANEL
var elementWidth = 220;
var elementHeight = 50;
var elementOffset = 8;
var offset = 20;

//x -= (elementWidth-150)*2;

width =  (offset*2) + (elementWidth*2);
height = (offset*2) + (elementOffset*1) + (elementHeight*4);

var wx = x + offset;
var wy = y + offset;
var inst;

//gui_create_button(wx, wy, elementWidth, elementHeight, "Start", func_room_goto, roomGame_Corridor);

inst = instance_create(wx, wy, objGUILabel);
inst.text = "Characters to Encounter";

wy += elementHeight + elementOffset;
inst = instance_create(wx, wy, objGUICheckbox);
inst.text				= "US Chad";
inst.buttonPressed		= true;
inst.toggled			= true;
inst.targetScript		= func_add_character;
inst.targetScriptArgs	= [obj_character_chad];
inst.execute_on_destroy	= true;

wy += elementHeight + elementOffset;
inst = instance_create(wx, wy, objGUICheckbox);
inst.text				= "GE Fred";
inst.buttonPressed		= true;
inst.toggled			= true;
inst.targetScript		= func_add_character;
inst.targetScriptArgs	= [obj_character_fred];
inst.execute_on_destroy	= true;

wy += elementHeight + elementOffset;
inst = instance_create(wx, wy, objGUICheckbox);
inst.text				 = "UK Thomas";
inst.buttonPressed		= true;
inst.toggled			= true;
inst.targetScript		= func_add_character;
inst.targetScriptArgs	= [obj_character_thomas];
inst.execute_on_destroy	= true;


wx = x + offset + elementWidth;
wy = y + offset + elementHeight + elementOffset;
inst = instance_create(wx, wy, objGUICheckbox);
inst.text				= "RU Viktor";
inst.targetScript		= func_add_character;
inst.targetScriptArgs	= [obj_character_viktor];
inst.execute_on_destroy	= true;

///CREATE OTHER PANEL
//inst = instance_create(x, y+height+10, pnlMenuGender);

///CREATE OTHER PANEL
//inst = instance_create(x, y+height+10, pnlMenuLanguage);

///CREATE ANOTHER PANEL
//inst = instance_create(x+width+10, y, pnlMenuSliders);



