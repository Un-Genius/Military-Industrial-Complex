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
inst.text = "AI Style";

wy += elementHeight + elementOffset;
inst = instance_create(wx, wy, objGUIRadiobutton);
inst.text = "Effecient";
inst.targetScript		= func_change_chatGPT;
inst.targetScriptArgs	= ["gpt-3.5-turbo"];
inst.execute_on_destroy	= 1; // 0:false, 1:true, 2:both
inst.group				= id;

if global.chatGPT == "gpt-3.5-turbo"
{
	inst.buttonPressed		= true;
	inst.toggled			= true;
}

wy += elementHeight + elementOffset;
inst = instance_create(wx, wy, objGUIRadiobutton);
inst.text = "Quality";
inst.targetScript		= func_change_chatGPT;
inst.targetScriptArgs	= ["gpt-4"];
inst.execute_on_destroy	= 1; // 0:false, 1:true, 2:both
inst.group				= id;

if global.chatGPT == "gpt-4"
{
	inst.buttonPressed		= true;
	inst.toggled			= true;
}

///CREATE OTHER PANEL
inst = instance_create(x, y+height+10, pnlMenuLanguage);