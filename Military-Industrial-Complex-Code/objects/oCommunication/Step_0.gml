
var _input = "Squad alpha should proceed to the attack marker and you guys should stick behind patrolling area 1."

var _instructions = ""

var _identifier_enum = [
	"player_nearest", "player_furthest", "unit_nearest", "unit_furthest",
	"attack_marker", "defend_marker", "recon_marker", "patrol_marker", "retreat_marker",
	"building_hq", "within_base",
	"alpha", "beta", "charlie",
	"1", "2", "3",
	"player", "enemy", "friendly"
]

var _communication_tool = [{
  "type": "function",
  "function": {
    "name": "execute_action",
    "description": "This must be called every time a command is parsed to extract essential information for the game to command troops. There can be multiple commands in a sentence, 'Squad alpha and you guys should proceed to attack marker' should be two seperate tool calls.",
    "parameters": {
      "type": "object",
      "properties": {
        "who": {
          "type": "string",
          "enum": ["squad", "unit", "player", "building", "undefined"],
          "description": "Identifies the type of entity referenced in the command. It could be a squad (e.g., 'Alpha'), a specific unit (e.g., 'Sniper 1'), a player, a building (e.g., 'HQ'), or 'undefined' if not specified. Example: 'Squad Alpha should attack' would use 'squad'."
        },
        "who_identifier": {
          "type": "string",
          "enum": _identifier_enum,
          "description": "Specifies the exact name or identifier of the entity mentioned in the command. It can be a squad name like 'alpha', a marker like 'attack_marker', or a specific unit name. Example: 'Sniper 1 move to recon marker' would use 'sniper_1'."
        },
        "who_amount": {
          "type": "string",
          "description": "Specifies the quantity or percentage of entities referenced. This field captures the number or percentage mentioned in the command. Example: 'Send 3 units' would be '3', and 'Send half of the squads to defend' would be '50%'."
        },
        "who_proximity": {
          "type": "string",
          "enum": ["squad", "unit", "building", "player", "marker", "objective"],
          "description": "Specifies the type of object that the entity is near or in proximity to. Example: 'All units near the HQ must fall back' would set 'who_proximity' to 'building'."
        },
        "who_proximity_identifier": {
          "type": "string",
          "enum": _identifier_enum,
          "description": "Provides the exact identifier of the object near which the entity is located. Example: 'Squads near patrol marker 1' would use 'who_proximity: marker' and 'who_proximity_identifier: patrol_marker_1'."
        },
        "action": {
          "type": "string",
          "enum": ["idle", "move", "haste", "follow", "patrol", "engage"],
          "description": "Specifies the action the entity should take. Examples: 'idle' for no action, 'move' to proceed to a location, 'haste' to move quickly, 'follow' to follow another unit or squad, 'patrol' to patrol an area, 'engage' to attack or engage an enemy."
        },
        "behavior": {
          "type": "string",
          "enum": ["aggressive", "defensive", "passive"],
          "description": "Optionally specifies the behavior mode of the entity, providing tactical context to the action. 'aggressive' prioritizes offense, 'defensive' focuses on holding ground, and 'passive' avoids combat."
        },
        "where": {
          "type": "string",
          "enum": ["squad", "unit", "building", "player", "marker", "objective", "undefined"],
          "description": "Identifies the type of destination or target location the entity should go to or act upon. Example: 'Move to attack marker' would have 'where: marker'."
        },
        "where_identifier": {
          "type": "string",
          "enum": _identifier_enum,
          "description": "Specifies the exact identifier of the target location or destination. Example: 'Move to within base' would have 'where: building' and 'where_identifier: within_base'."
        },
        "condition": {
          "type": "string",
          "enum": ["ifAttacked", "ifDestinationReached", "ifHealthLow", "ifTimer2Minutes"],
          "description": "Specifies conditions that need to be met for the action to be executed or continue. 'ifAttacked' triggers if attacked, 'ifDestinationReached' upon reaching a destination, 'ifHealthLow' if health is low, and 'ifTimer2Minutes' after a set time."
        }
      },
      "required": ["who", "action", "where"],
      "additionalProperties": false
    }
  }
}]
	
var _old_communication_tool = [{
	"type": "function",
	"function": {
	    "name": "execute_action",
	    "description": "This must be called everytime and is used to extract essential information for the game to command troops. This tool call acts as a single line of information for one command. This should be called if there are multiple commands in a sentence. For example 'Squad alpha and you guys should proceed to attack marker' should be two seperate tool calls.",
	    "parameters": {
	        "type": "object",
	        "properties": {
	            "who": {
	                "type": "string",
					"enum": ["squad", "unit", "undefined"],
	                "description": "Identifies whether the player is referencing a unit or a squad.",
	            },
				"who_identifier": {
	                "type": "string",
					//"enum": _identifier_enum,
	                "description": "Identifies the exact name of the unit or squad. Squads may be in the form of 'Alpha', 'Beta', etc. And units may be 'Bob', 'Joe.' For example, 'Squad Omega should defend the base' is 'omega'",
	            },
	            "who_amount": {
	                "type": "string",
	                "description": "The number of units or squads the player mentions. Must be either an int or a percentage. For example, 'Send most of the units at base to the objective' is '75%'.",
	            },
				"who_proximity": {
	                "type": "string",
					"enum": ["squad", "unit", "building", "player", "marker", "objective"],
	                "description": "Optional for when the player is trying to reference a squad or unit in proximity to an object. For example, 'All squads near patrol group 1 must retreat' is of type 'marker'",
	            },
	            "who_proximity_identifier": {
	                "type": "string",
					"enum": _identifier_enum,
	                "description": "Optional for when the player is referencing a specific object. For example, 'All squads near recon marker must retreat' is referencing 'recon_marker'",
	            },
				"action": {
	                "type": "string",
					"enum": ["idle", "move", "haste", "follow", "patrol", "engage"],
	                "description": "Identifies which action the unit should take to fulfill the users command. For example, 'You should attack the objective' is 'engage'",
	            },
	            "behavior": {
	                "type": "string",
					"enum": ["aggressive", "defensive", "passive"],
	                "description": "Optionally identifies what behavior the unit should have. 'Stick behind and protect the base' is 'defensive'",
	            },
				"where": {
	                "type": "string",
					"enum": ["squad", "unit", "building", "player", "marker", "objective", "undefined"],
	                "description": "Identifies where or who the unit/squad should go. For example, 'Retreat to base' is 'building'",
	            },
	            "where_identifier": {
	                "type": "string",
					"enum": _identifier_enum,
	                "description": "Optionally identifies the exact name of where to go. Example, 'Retreat to base' is 'within_base'",
	            },
				"condition": {
	                "type": "string",
					"enum": ["ifAttacked", "ifDestinationReached", "ifHealthLow", "ifTimer2Minutes"],
	                "description": "Optionally identifies preset conditions. For example, 'Attack once you reach the destination' is 'ifDestinationReached'",
	            },
	        },
	        "required": ["who", "action", "where"],
	        "additionalProperties": false,
	    },
	}
}]

if keyboard_check_released(vk_enter)
	var _chatgpt_request = send_openai_gpt(_instructions, _input, _communication_tool)









// Start recording
if (keyboard_check_pressed(vk_space) && !isRecording) {
	for (var i = audio_get_recorder_count() - 1; i >= 0; --i) {
		if (i != recordingDevice)
			continue;
			
		isRecording = true;
		ds_map_destroy(recordSpecs);
		if (!is_undefined(recordSound))
			audio_free_buffer_sound(recordSound);
		buffer_delete(recordBuffer);
		recordSpecs = audio_get_recorder_info(i);
		recordBuffer = buffer_create(recordSpecs[? "sample_rate"] * buffer_sizeof(recordSpecs[? "data_format"]), buffer_grow, 1);
		recordingChannel = audio_start_recording(i);
		recordingDevice = i;
		transcriptionTimer = current_time; // Initialize the timer
		break;
	}
}

// Stop recording
if (keyboard_check_released(vk_space) && isRecording) {
	isRecording = false;
	audio_stop_recording(recordingChannel);
	var _newBuffer = save_and_transcribe();
	buffer_delete(recordBuffer);
	recordBuffer = _newBuffer
	recordingChannel = -1;
	audio_play_sound(recordSound, 0, false);
}


// Check if transcription is needed every step
if (isRecording) {
	if (current_time - transcriptionTimer >= 2000) { // 2000ms = 2 seconds
		save_and_transcribe();
		transcriptionTimer = current_time; // Reset the timer
	}
}







/*
// Start recording
if keyboard_check_pressed(vk_space) && !isRecording {
	for (var i = audio_get_recorder_count()-1; i >= 0; --i) {
		if i != recordingDevice
			continue;
			
		isRecording = true;
		ds_map_destroy(recordSpecs);
		if !is_undefined(recordSound)
			audio_free_buffer_sound(recordSound);
		buffer_delete(recordBuffer);
		recordSpecs = audio_get_recorder_info(i);
		recordBuffer = buffer_create(recordSpecs[? "sample_rate"]*buffer_sizeof(recordSpecs[? "data_format"]), buffer_grow, 1);
		recordingChannel = audio_start_recording(i);
		recordingDevice = i;
		break;
	}
}

// Stop recording
if keyboard_check_released(vk_space) && isRecording {
	isRecording = false;
	audio_stop_recording(recordingChannel);
	var convertedRecordBuffer = buffer_create(buffer_tell(recordBuffer), buffer_fast, 1);
	buffer_copy(recordBuffer, 0, buffer_tell(recordBuffer), convertedRecordBuffer, 0);
	recordSound = audio_create_buffer_sound(
		convertedRecordBuffer,
		recordSpecs[? "data_format"],
		recordSpecs[? "sample_rate"],
		0,
		buffer_tell(recordBuffer),
		recordSpecs[? "channels"]
	);
	buffer_delete(recordBuffer);
	recordBuffer = convertedRecordBuffer;
	recordingChannel = -1;
 
	var _file_path = working_directory + "temp_audio_recording.wav";
	
	audio_play_sound(recordSound, 0, false);
  
	if (!ds_map_empty(recordSpecs))
		buffer_save_wav(recordBuffer, _file_path, recordSpecs[? "channels"], recordSpecs[? "sample_rate"], recordSpecs[? "data_format"]);
 
	if (file_exists(_file_path)) {
	    show_debug_message("File saved successfully: " + _file_path);
		send_openai_whisper(_file_path);
	} else {
	    show_debug_message("Failed to save the file: " + _file_path);
	}
}