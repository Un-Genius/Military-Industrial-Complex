event_inherited()

var _team = oFaction.team_info.team+1;

team_info = {
	team: _team,
	color: oFaction.colors[_team]
};

//team		= oFaction.team+1;		// Which team its on
//numColor	= 0;	// number relating to "red" or "blue" using an enum: color.red = 0
//hash_color	= "red";	// "red" or "blue"

b_sm.swap(b_aggressive);