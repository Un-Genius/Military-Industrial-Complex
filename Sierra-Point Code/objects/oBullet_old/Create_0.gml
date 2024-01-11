/*
Goals for bullet mechanic

	- Accuracy determines what hits & misses which creates
	an environment where bullets can fly overhead.
	
	- Cover counters Accuracy. Higher the cover, higher the accuracy
	needed to hit.
	
	- If accuracy is high enough, damage will be increased.

	- Accuracy affects how well it flys to target.
	
	- Bullets change shape depending on who shoots it.
	
	- Bullets have different damage values depending on target.
	
	- Bullets cant penetrate certain targets depending on shooter.
	
	- Bullets can break cover if accuracy and penetration is high enough
*/

// Set accuracy
accuracy = 100;

// Set bullet type for damage
bulletType = gunType.rifle;

// Set default team
team = 0;
numColor = 0;

// Remember old position
preX = x;
preY = y;

// Make the bullet smaller
image_xscale = 0.50;
image_yscale = 0.50;

// Play sound
randAudio("snd_smallArmsFire", 9, 0.1, 0.01, 0.8, 1.2, x, y);

// Create Shooting smoke particles
alarm[0] = 2;