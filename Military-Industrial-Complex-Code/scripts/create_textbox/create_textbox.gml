/// @arg x
/// @arg y
/// @arg text
/// @arg textLimit
/// @arg parent
function create_textbox() {

	// Arguments
	var _x			= argument[0];
	var _y			= argument[1];
	var _text		= argument[2];
	var _textLimit	= argument[3];
	var _parent		= argument[4];

	// Create button
	var _textbox = instance_create_layer(_x, _y, "GUI", oTextbox);
	
	// Set Values
	with(_textbox)
	{
		text	= _text;
		limit	= _textLimit + 1;
		parent	= _parent;
	}

	return _textbox;


}
