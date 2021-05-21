#region ID of Units

unitName	= "noone";

moveSpd	= 1;		// pixel per frame

unit	= unitType.inf; // Type of unit for health
armor	= 0;

maxHp	= 1;		// How much health points they can have
hp		= maxHp;	// How much health points they have

gun		= noone;	// Type of gun
range	= 0;				// How far they can shoot in pixels
cover	= 0;				// Default cover

bulletFrequency = 0;	// Frequency of bullets per second
bulletTiming	= 0;	// Holds timing of last bullet

burstMax	= 0;				// Amount of bullets per burst
burstTiming = 0;	// Timing between bursts
burstTimer	= 0;				// Holds the time till last burst
burstAmount	= 0					// Current amount

maxResCarry	= 0;			// Max resources carried
resCarry	= maxResCarry;	// Resources carried
resRange	= 0;			// Range to transfer resources

ammoUse		= 0;			// How much ammo will be consumed after reloading
maxClipSize	= 0;			// Max bullets shot before reloading
clipSize	= maxClipSize;

#endregion

team		= oManager.team;		// Which team its on
numColor	= oManager.numColor;	// number relating to "red" or "blue" using an enum: color.red = 0
hashColor	= oManager.hashColor;	// "red" or "blue"

// Pathfinding
path = path_add();

// Parent ID
squadID = noone;

// Push so many units out of the way per second
pushTimer = 0;

// Enter vehicle if present
enterVeh	= noone;
riding		= false;

state = action.idle;

moveState = action.idle;

// Play walking sound
movingSound = audio_play_sound(snd_smallArmsWalk0, 110, true);

// Randomize position
audio_sound_set_track_position(movingSound, random_range(0, 5));

// Set volume
audio_sound_gain(movingSound, 0.05, 0);
		
// Randomize pitch
audio_sound_pitch(movingSound, random_range(0.8, 1.2));

// Pause
audio_pause_sound(movingSound);

// Move slightly over if spawned on top of unit
while instance_place(x, y, oHQ) || instance_place(x, y, oHAB)
	y += 32;
	
// Goal
goalX = x;
goalY = y;

pathX = x;
pathY = y;

oldPathX = pathX;
oldPathY = pathY;

// Image direction
dir = 0;

// Update budget
//alarm[0] = 1;