/// @description CREATE PANELS

var _ww = global.RES_W;

var _offset = 20;
var _btn_width = 300;
var _btn_offset = 5;

var _width = (_offset*2) + _btn_width;

var _x = (_ww div 2) //middle of the screen
		 -(_width div 2);

instance_create(_x, 150, pnlMenuButtons);

instance_create(_x + 350, 150, pnlMenuName);
instance_create(_x - 350, 150, pnlMenuChatGPT);

//instance_create(_x + 350, 100, pnlMenuCharacters);

/*
var inst = instance_create(10, 414, objGUIDialogBox);

inst.width = 800
inst.height = 118;

inst.text = "###"+
    "Hey. Don't ever let somebody tell you, you can't do something. " +
    "#Not even me. All right? ##" +
    "You got a dream? " +
    "#You gotta protect it. ##" +
    "People can't do something themselves, they want to tell you you can't do it. ###" +
    "You want something?         " +
    "#Go get it! " +
    "#Period!";
*/


instance_destroy();
