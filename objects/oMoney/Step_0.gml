y -= 0.15;

t = (t + increment) mod 360;
shift = amplitude * dsin(t);
 
//clone the movement from the object's speed and direction
xx += vspeed;
x = xx + shift; //vertical wave motion

// Change alpha value
image_alpha -= lifeAlpha;