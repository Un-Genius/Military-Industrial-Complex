/// @description Insert description here
// You can write your code in this editor







// Inherit the parent event
event_inherited();

#region CUSTOMIZEABLE VARIABLES

width = 195;
height = 75;
text = "Button Text"; //displayed text
icon = -1; //sprite index
iconIndex = 0; //subimage of the sprite icon to be presented

enabled = true;
stayPressed = false;
toggled = false;

guiSprite = sprButton;
guiSpritePressed = sprButtonPressed;
depth = 0; //always above panels

origin = GUI_TOPLEFT; // GUI_TOPLEFT or GUI_CENTER

fontType = fntStandard;//global.language_font;
fontScale = 0.5;
fontColor = c_white;
fontAlign = fa_left; //fa_center, fa_left

pressedOffset = 2;

soundClick = sndClick;

targetScript = noone;
targetScriptArgs[0] = noone;

site_type = noone;
cost = 0;

#endregion