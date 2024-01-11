event_inherited();
///SETUP & CREATE BUTTONS
var elementWidth = 150;
var elementHeight = 50;
var elementOffset = 8;
var offset = 20;

width =  (offset*2) + (elementWidth*2);
height = (offset*2) + (elementOffset*1) + (elementHeight*3);

var wx = x + offset;
var wy = y + offset;
var inst;

inst = instance_create(wx, wy, objGUILabel);
inst.text = "Name";

wy += elementHeight + elementOffset;
inst = instance_create(wx+55, wy, objGUIInputText);
inst.text = "";
inst.targetScript		= func_update_name;
inst.label = global.gender;
inst.width = 225;

///CREATE OTHER PANEL
wy += 165 + elementOffset;
inst = instance_create(x, y+height+10, pnlMenuGender);