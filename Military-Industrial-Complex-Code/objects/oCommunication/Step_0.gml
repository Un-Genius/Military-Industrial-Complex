
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
          "description": "Identifies the type of destination or target location the entity should go to or act upon. Example: 'Move to attack marker' would have 'where: marker' or the command 'Follow me' results in the location being the 'player'. 'Squad alpha should move to squad beta' should result in 'Squad' as the location."
        },
        "where_identifier": {
          "type": "string",
          "enum": _identifier_enum,
          "description": "Specifies the exact identifier of the target location or destination. Example: 'Move to within base' would have 'where: building' and 'where_identifier: within_base'. 'Squad alpha should move to squad beta' should result in 'beta' as the location identifier."
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

if keyboard_check_released(vk_enter)
	var _chatgpt_request = send_openai_gpt(_instructions, _input, _communication_tool)

// Start recording
if (keyboard_check_pressed(vk_space) && !is_recording) {
	for (var i = audio_get_recorder_count() - 1; i >= 0; --i) {
		if (i != recording_device)
			continue;
			
		is_recording = true;
		ds_map_destroy(record_specs);
		if (!is_undefined(record_sound))
			audio_free_buffer_sound(record_sound);
		buffer_delete(record_buffer);
		record_specs = audio_get_recorder_info(i);
		record_buffer = buffer_create(record_specs[? "sample_rate"] * buffer_sizeof(record_specs[? "data_format"]), buffer_grow, 1);
		recording_channel = audio_start_recording(i);
		recording_device = i;
		transcription_timer = current_time; // Initialize the timer
		break;
	}
}

// Stop recording
if (keyboard_check_released(vk_space) && is_recording) {
	is_recording = false;
	audio_stop_recording(recording_channel);
	var _new_buffer = save_and_transcribe();
	buffer_delete(record_buffer);
	record_buffer = _new_buffer
	recording_channel = -1;
	//audio_play_sound(record_sound, 0, false);
	if transcription_text != ""
		send_openai_gpt(_instructions, transcription_text, _communication_tool)
}


// Check if transcription is needed every step
if (is_recording) {
	if (current_time - transcription_timer >= 2000) { // 2000ms = 2 seconds
		save_and_transcribe();
		transcription_timer = current_time; // Reset the timer
	}
} else transcription_text = "";




/*
// Start recording
if keyboard_check_pressed(vk_space) && !is_recording {
	for (var i = audio_get_recorder_count()-1; i >= 0; --i) {
		if i != recording_device
			continue;
			
		is_recording = true;
		ds_map_destroy(record_specs);
		if !is_undefined(record_sound)
			audio_free_buffer_sound(record_sound);
		buffer_delete(record_buffer);
		record_specs = audio_get_recorder_info(i);
		record_buffer = buffer_create(record_specs[? "sample_rate"]*buffer_sizeof(record_specs[? "data_format"]), buffer_grow, 1);
		recording_channel = audio_start_recording(i);
		recording_device = i;
		break;
	}
}

// Stop recording
if keyboard_check_released(vk_space) && is_recording {
	is_recording = false;
	audio_stop_recording(recording_channel);
	var convertedRecordBuffer = buffer_create(buffer_tell(record_buffer), buffer_fast, 1);
	buffer_copy(record_buffer, 0, buffer_tell(record_buffer), convertedRecordBuffer, 0);
	record_sound = audio_create_buffer_sound(
		convertedRecordBuffer,
		record_specs[? "data_format"],
		record_specs[? "sample_rate"],
		0,
		buffer_tell(record_buffer),
		record_specs[? "channels"]
	);
	buffer_delete(record_buffer);
	record_buffer = convertedRecordBuffer;
	recording_channel = -1;
 
	var _file_path = working_directory + "temp_audio_recording.wav";
	
	audio_play_sound(record_sound, 0, false);
  
	if (!ds_map_empty(record_specs))
		buffer_save_wav(record_buffer, _file_path, record_specs[? "channels"], record_specs[? "sample_rate"], record_specs[? "data_format"]);
 
	if (file_exists(_file_path)) {
	    show_debug_message("File saved successfully: " + _file_path);
		send_openai_whisper(_file_path);
	} else {
	    show_debug_message("Failed to save the file: " + _file_path);
	}
}