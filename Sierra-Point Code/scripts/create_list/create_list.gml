/// @arg x
/// @arg y
/// @arg width
/// @arg title
function create_list() {

	// Arguments
	var _x		= argument[0];
	var _y		= argument[1];
	var _width	= argument[2];
	var _title	= argument[3];

	// Create list
	var _list = instance_create_layer(_x, _y, "GUI", oList);

	// Set values
	with(_list)
	{
		width	= _width;
		title	= _title;
	}

	return _list;


}
