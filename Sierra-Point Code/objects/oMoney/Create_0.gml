suppliesAmount = 0;

lifeDuration = 3;
lifeAlpha = 1 / (lifeDuration * room_speed);

alarm[0] = lifeDuration * room_speed;

t = 0;
increment = 2; //degrees -- freq = 1 oscillation per second (1Hz) in a 30 fps room
amplitude = 5; //pixels of peak oscillation
 
//clone the y-position (or use x instead if you're doing horizontal oscillation)
xx = x;