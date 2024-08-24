
var _instructions = ""

var _example_tools = [
    {
        "type": "function",
        "function": {
            "name": "get_delivery_date",
            "description": "Get the delivery date for a customer's order. Call this whenever you need to know the delivery date, for example when a customer asks 'Where is my package'",
            "parameters": {
                "type": "object",
                "properties": {
                    "order_id": {
                        "type": "string",
                        "description": "The customer's order ID.",
                    },
                },
                "required": ["order_id"],
                "additionalProperties": false,
            },
        }
    }
]

var _identify_information_tool = [
    {
        "type": "function",
        "function": {
            "name": "identify_info",
            "description": "Used to identify instruction from the user. Call this to provide the essential instruction in a reformatted way.",
            "parameters": {
                "type": "object",
                "properties": {
                    "is_squad": {
                        "type": "bool",
                        "description": "Whether or not the user has mentioned a squad or an individual to command. For example, the user is talking about a squad in the phrase: 'Squad alpha should proceed to the attack marker.'",
                    },
					"unit_identifier": {
                        "type": "string",
						"enum": ["everyone", "nearest", "specific"],
                        "description": "Identifies the unit or squad in question. For example, the user may be talking about 'everyone' when they mention 'you guys should stick behind' or 'nearest' when they say 'you should follow me'",
					},
					"unit_identifier_extra": {
                        "type": "string",
                        "description": "Use this variable if the user calls out a specific unit type or squad name.",
					},
					"unit_action": {
                        "type": "string",
						"enum": ["idle", "move", "follow", "patrol", "engage", "retreat"],
                        "description": "This variable calls out what movement type the unit or squad should perform. For example, the user wants their units to engage in the phrase: 'Everyone atttack!'",
					},
					"location_type": {
                        "type": "string",
						"enum": ["marker", "building", "user", "specific"],
                        "description": "",
					},
					"location_marker": {
                        "type": "string",
						"enum": ["attack", "defend", "retreat", "patrol", "recon"],
                        "description": "This optional variable calls out which type of map marker the user is using in cases when 'location type' is set to 'marker'. For example, the user wants their units move to a 'recon' marker: 'stick behind scouting area 1.'",
					},
					"location_marker_extra": {
                        "type": "string",
                        "description": "This optional variable calls out which exact marker the user is specifying in cases when 'location_marker' is used. For example, the user wants their units move to the marker '3': 'go to patrol area 3.'",
					},
					"location_identifier": {
                        "type": "string",
                        "description": "This optional variable calls identifies the location name the user is identifying in cases when location_type is for 'building', or 'specific'. For example, the user wants their units move to the HQ 'hq': 'Retreat to HQ!'. Always be lower case.",
					},
					"location_identifier_extra": {
                        "type": "string",
                        "description": "",
					},
                },
                "required": ["is_squad", "unit_identifier", "unit_action", "location_type"],
                "additionalProperties": false,
            },
        }
    }
]

var _tools = [
    {
        "type": "function",
        "function": {
            "name": "set_movement_idle",
            "description": "The default state when the unit is not performing any tasks. Call this when the unit should not be moving anywere, for example when the user says 'Stop moving.'",
            "parameters": {
                "type": "object",
                "properties": {
                    "order_id": {
                        "type": "string",
                        "description": "The customer's order ID.",
                    },
                },
                "required": ["order_id"],
                "additionalProperties": false,
            },
        }
    }
]

var _input = "Squad alpha should proceed to the attack marker and you guys should stick behind patrolling area 1."

var _context = {
	"units_nearby_sorted_nearest" : []
}
_context = json_stringify(_context)


if keyboard_check_released(vk_enter)
	send_gpt("You are a friendly agent", "Hello!")