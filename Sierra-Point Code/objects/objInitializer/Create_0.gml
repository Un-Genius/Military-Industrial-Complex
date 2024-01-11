/// @description CREATE YOUR GLOBALS AND ENUMS HERE

///LOAD SOUND ALWAYS ON
audio_group_load(AlwaysOn);

#region RESIZE GAME WINDOW AND SURFACE

// 1920, 1080 is default
var _width = display_get_width();
var _height = display_get_height();

surface_resize(application_surface, _width, _height);
window_set_size(_width, _height);

window_set_fullscreen(true);

#endregion

#region INI FILE
ini_open("CONFIG.INI");

var value = ini_read_real("prefs", "sound", 100);
audio_group_set_gain(AlwaysOn, value/100, 1);

value = ini_read_real("prefs", "music", 100);
musicVolume = value/100;
audio_group_set_gain(audiogroup_default, value/100, 1);
var inst = instance_create(-1000, -1000, objMusicBox);
inst.musicVolume = musicVolume;

ini_close();
#endregion

#region CREATE ESSENTIAL OBJECTS

instance_create(-1000, -1000, objMouseGui);
instance_create(-1000, -1000, objParticleEngine);
instance_create(-1000, -1000, objGamepadDetector);

#endregion

#region RUN ESSENTIAL SCRIPTS

lang_initialize();
rebind_keys_initialize();

#endregion

#region GAME ENUMS

randomize();

global.character_list	= ds_list_create();
global.gender			= "Elder";
global.name				= "Greenie";
global.in_game_menu		= 0;
global.chatGPT			= "gpt-3.5-turbo";
global.gameLanguage		= "English";
global.debug			= false;

enum types
{
	text,
	choice,
	input,
	GeneratedText
}

enum generatedTextState
{
	idle,
	sent,
	received
}

enum effect
{
	normal,
	shakey,
	wave,
	colour_shift,
	wave_and_colour_shift,
	spin,
	pulse,
	flicker
}

enum keyTypes
{
	text,
	effects,
	effects_color,
	effects_color_speed
}

#endregion

#region ChatGPT GLOBAL VARS

global.prompt_GPT_discussion = 
	"Game Context: '''You are a character " +
	"with a strong personality and mostly ignorant about LDS." +
	"You're at home in an apartment.'''" +
	
	"Purpose: '''Show interest in your question " +
	"If the user answers the question and gives an invitation, set the win_condition to true." +
	"Your responses should be formatted in JSON.'''";

var _keys =
	" Json Keys: 'response', 'emotion', " +
	"'end_conversation', 'win_condition'. " +
	"'visible_to_player', 'win_condition' & 'end_conversation' are booleans. " +
	"'emotion' = 0:neutral, 1:postive, 2:negative, 3:curious, 4:learning, 5:confused, 6:weirded out. " +
	"'end_conversation' if conversation is finished or if the player is rude or weird. " +
	" Example: '''{ \"response\": \"Who are you? I don't know about religion.\", \"emotion\": 0, \"end_conversation\": false, \"win_condition\": false }'''";

//" Json Keys: 'response', 'emotion', 'visible_to_player', " +

global.prompt_GPT_discussion += _keys;

global.questions_of_the_soul = [
	"Does God exist? Who is God?",
	"Does God know me and care about me? How can I feel His love? How can I feel closer to Him?",
	"What is the purpose of life?",
	"Why is life so hard sometimes? How can I find strength during hard times?",
	"How can I find peace in times of turmoil?",
	"How can I be happier?",
	"How can I be a better person?",
	"How can I feel God’s forgiveness?",
	"What happens after I die?",
	"How can I contribute to the spiritual well-being of my family?",
	"How can I help my children build strength to resist temptation?",
	"How can obeying God’s commandments help me have a happier, more abundant life?"
]

global.prompt_GPT_Points =
	"Review the input and generate a JSON response." +
	"Answer each key with the value '0' for No, '1' for Yes, and '-1' for Not Relevant." +
	"- 'askQuestion' if the player asked a question" +
	"- 'openEnded' if the question asked was open-ended" +
	"- 'onTopic' if the player's text touches on the topic of the goal" +
	"- 'empathetic' if the player's text is empathetic" +
	"- 'teaching' if the player's text is teaching something" +
	"- 'inviteAction' if the player's text is inviting the NPC to act" +
	"- 'inappropriate' if the player's text is inappropriate" +
	"Example: { askQuestion: 1, openEnded: 1, onTopic: 1, empathetic: 1, teaching: -1, inviteAction: -1, inappropriate: 0 }"

#endregion

///GO TO MAIN ROOM
room_goto(roomMainFramework);



