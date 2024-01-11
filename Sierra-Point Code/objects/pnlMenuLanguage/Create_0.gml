event_inherited();
///SETUP & CREATE BUTTONS
var elementWidth = 220;
var elementHeight = 50;
var elementOffset = 8;
var offset = 20;

x -= (elementWidth-150)*2;

width =  (offset*2) + (elementWidth*2);
height = (offset*2) + (elementOffset*1) + (elementHeight*4);

var wx = x + offset;
var wy = y + offset;
var inst;

inst = instance_create(wx, wy, objGUILabel);
inst.text = "Languages to Encounter";

wy += elementHeight + elementOffset;
inst = instance_create(wx, wy, objGUICheckbox);
inst.text = "English";
inst.buttonPressed		= true;
inst.toggled			= true;
inst.execute_on_destroy	= true;
inst.targetScript		= func_change_language;
inst.targetScriptArgs	= [inst.text];

wy += elementHeight + elementOffset;
inst = instance_create(wx, wy, objGUICheckbox);
inst.text = "German";
inst.execute_on_destroy	= true;
inst.targetScript		= func_change_language;
inst.targetScriptArgs	= [inst.text];

wy += elementHeight + elementOffset;
inst = instance_create(wx, wy, objGUICheckbox);
inst.text = "Russian";
inst.execute_on_destroy	= true;
inst.targetScript		= func_change_language;
inst.targetScriptArgs	= [inst.text];

///CREATE OTHER PANEL
inst = instance_create(x, y+height+10, pnlMenuCharacters);


