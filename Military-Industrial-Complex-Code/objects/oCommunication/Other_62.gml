var _size = ds_map_size(async_load);
var _key = ds_map_find_first(async_load);

for (var i = 0; i < _size; ++i) {
	if (_key == "result") 
	{	
		show_debug_message("MESSAGE RECEIVED");
		
		// Stop if the status is wrong
		if(async_load[? "status"] == -1)
			show_debug_message("ERROR WITH RECEIVED MESSAGE. STATUS: " + string(async_load[? "status"]));
	    
		// Get the entire JSON message
		var _full_message = json_parse(async_load[? _key]);
		
		// Stop if error is in the message
		if(variable_struct_exists(_full_message, "error"))
			show_debug_message("ERROR WITH RECEIVED MESSAGE. STATUS: " + string(variable_struct_get(_full_message, "error")));
		
		// Pull out the amount of messages stored
		var _number_returned = array_length(_full_message.choices);
		
		var raw_string = "";
		
		// Grab all the messages it could have if the variable n is greater than 1
		for (var j = 0; j < _number_returned; ++j) {
			raw_string += _full_message.choices[j].message.content;
		}
		
		// Grab the actual output
		var _content = json_parse(raw_string);
		
		show_debug_message("CONTENT: " + string(_content));
		
		// If its an array, just take the first slot
		if(is_array(_content))
			_content = _content[0];
			
		// if(variable_struct_exists(_content, "review"))
		
		show_debug_message("Cost: " + string(_full_message.usage.total_tokens))
		
		break;
	}
	
	_key = ds_map_find_next(async_load,_key);
}