/// @description Suppressed

if(suppressAmount > 0)
{
	// Lower amount
	suppressAmount -= 0.2;
	
	// Reset
	alarm[1] = 1;
}
else
{
	suppressed = false;
	suppressAmount = 0;
}