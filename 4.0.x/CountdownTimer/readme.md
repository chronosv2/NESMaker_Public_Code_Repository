#Countdown Timer
This set of scripts allows you to have a Countdown Timer. Note that it runs off of global timer ticks, so 1 timer unit is 256 ticks, or about 4.26 seconds.  
I know how to make this more customizable but I'll be doing it for version 4.1.0 with NESMaker's new Plugin system.

I recommend unpacking these scripts to your own folder in the UserScripts folder.

## How to Use
### Defines
Change the following  
**Name:** Handle Game Timer  
**Script:** [Wherever-you-unpack-the-ASM-files]\HandleGameTimer.asm

Define the following  
**Name:** Handle Tick  
**Define:** SCR_COUNTDOWN_TIMER  
**Script:** [Wherever-you-unpack-the-ASM-files]\Timer_Tick.asm

If you wish to use the tile, change one of the Tile defines to point to the Refill Tile.
To handle disabling the timer if you warp to the underworld, change Warp Tile define to WarpToScreen.

Note that you're going to need a variable regardless to enable and disable your timer, or the game will
always be ticing it. In the script this is called CurrentLevel, but you could rename it in the script and in your user variables to whatever you might want it to be.
You'll also (as of v4.0.11) need to create three variables to contain your timer's maximum and reference them in your code. In the case of the script as it is, those are MyWater100, MyWater10 and MyWater1. In the case of how I implemented it, I set the default value of MyWater10 to 2 and MyWater1 to 5 for a timer of 25.
