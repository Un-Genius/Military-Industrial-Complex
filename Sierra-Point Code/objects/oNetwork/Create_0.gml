// Initialise steam
if steam_initialised()
{
	if steam_is_user_logged_on()
		trace(1, "Steam Connected");
	else
		trace(2, "Steam is not online");
}
else
{
	if steam_is_user_logged_on()
		trace(2, "Failed to connect to steam servers.");
	else
		trace(2, "Failed to find steam running.");
}

// formats specified when sent by client \ when sent by server
enum packet_t
{
    none = 0,
    // client: ()
    // server: ()
    // Bounces to keep the P2P connection active.
    ping,
    // client: (game_name:string, game_version:u32)
    // server: (client_id:int64)
    auth,
    // client: (message:string)
    // server: (message:string)
    chat,
    // server: (error_text:string)
    error,
    // client: ()
    // server: (client_id:int64)
    leaving,
	// server: ()
    data_map,
    // client: (string, data (s16))
	// server: (client_id:int64, string, boolean (s16))
	start,
	// server: ()
	add_unit,
	// client: (unit_type, x, y)
	// server: (client_id:int64, unit_type, x, y)
	add_attached_unit,
	// client: (unit_type, x, y, pos)
	// server: (client_id:int64, unit_type, x, y, pos)
	destroy_unit,
	// client: (user, pos)
	// server: (client_id:int64, pos)
	move_unit,
	// client: (user, pos, x, y, goal_x, goal_y)
	// server: (client_id:int64, pos, x, y, goal_x, goal_y)
	veh_interact,
	// client: (pos, interaction)
	// server: (client_id:int64, pos, interaction)
	update_unit,
	// client: (pos, state)
	// server: (client_id:int64, pos, state)
	shoot_bullet,
	// client: (x, y, angle, type, team)
	// server: (x, y, angle, type, team)
	lobby_connected,
	// client: ()
	// server: ()
	data_update_request,
	// sender: ()
	data_update_packet,
	// sender: (ready, numColor, team, game_mode)
}

enum color
{
	white,
	red,
	orange,
	yellow,
	green,
	ltBlue,
	blue,
	purple,
	pink
}

// Game details
game_name		= "Sierra-Point";
game_version	= GM_version;

// Get name
steamUserName	= steam_get_user_steam_id();	// local user ID
names	= ds_map_create();				// <steamid:int64 -> name:string>

lobby_owner = noone;

// Create a map to hold a map for each players data
playerDataMap = ds_map_create();	// Uses steam ID to find the data map

// Preload username
steam_get_user_persona_name_w(steamUserName);

// Store other players
net_list	= ds_list_create();	// <steamid:int64>
net_map		= ds_map_create();	// <steamid:int64, time>

// Data handling
inbuf	= buffer_create(1024, buffer_grow, 1);	// used for storing incoming packets
outbuf	= buffer_create(1024, buffer_grow, 1);	// used for building outgoing packets

// lobby
lobby			= false;	// whether currently in a lobby
lobby_is_owner	= false;	// whether acting as a server
creating_lobby	= false;	// whether currently in async lobby creation
joining_lobby	= false;	// whether currently awaiting initial connection
playersReady	= 0;		// tracks all players in lobby have clicked ready
ready			= false;	// Tracks you, (cia agent says hello)
started			= false;
inGame			= false;