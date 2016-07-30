# Smoothie_External_Drive_Interface
This project is to create a hardware interface soltion for using certian external stepper drives on Smoothieboard

Smoothieboard is great at generating smooth stepper motor motions, however there simple aren't enough rescourced
on board to accomodate every possible hardware configuration.  

The concept of this project is to get the features I want without re-writing the smoothie firmware.  I am hoping
this solution will allow me to use the standard firmware, yet properly drive my machines.

Issues this solution will address are:

Delay the direction pulse for slowly reacting stepper drives.
   Smoothie's onboard and many external stepper drives have a very fast step pulse, only about 1µS is required
   Smoothie outputs stepper pulses about 3µS wide, and if the direction will be changing, it changes the direction
   signal about 4µS after the rising edge of the last step pulse.  This is no problem most of the time, because the
   step pulse is completed before the direction line changes.  I have been experiencing a problem on Anaheim Automation
   BLD-75 Drivers because they have built in noise suppression that filters out noise by making sure any step pulses
   are present for longer than 8µS.  Due to this, the direction signal is chagning right in the middle of the direction
   pulse and by the time the drive determines that it really is a step and not noise and performs the step, the direction
   line has been changed and it steps once in the wrong direction.  This doe not happen all the time, it only happens if 
   an axis sets up its own direction change.   I have developed a simple test for this situation and will include the 
   file (testdir.gcode) in this repositroy.  I have proven that delaying the direction signal will indeed solve the problem, 
   however implementing a firmware soltion is extremely difficult, so the first part of this project is to provide a delay 
   of an adjustable amount of time to the direction lines to make this solution expandable to other drives which may have 
   different timing requirements.
   See https://github.com/Smoothieware/Smoothieware/issues/972 for more information about this issue.

Create Differential Step and Direction Signals.
   One of the reasons moderns stepper drives can run effectivly with very short step pulses is they employ a differential 
   input.  These drives will run with a single ended signal, however doing so will make the suceptable to electrical noise
   and they may false step due to noise.  If you filter the noise out, then you end up with the issue above, the best option
   is to provide these drives with a a true differential signal.  A differential signal is normally delivered over a twisted 
   pair, one line is normally high while the other is normally low, when a signal is issued, they reverse, the high line goes 
   low and the low line goes high.  Smoothie does not do this, signals are on one line and either ground or a positive power
   supply line are referenced. Smoothie does not have enough spare io pins as it is, so having it supply differential signals 
   would be difficult.  This solution will input smoothie's single signal step and direction signals and generate differential
   signals better suited to drives with differential inputs
   
Create a hardware lockout when limit switches are engaged.
   Smoothie does not take into consideration which direction something was moving when a limit switch is activated, therefore
   it is possible to move in the same direction that a limit was activated.  This solution allows for disabling of the step 
   signal when a limit signal is present in the direction attempted, this will result in the position in smoohie being incorrect, 
   however it was inacurate due to the limit in the first place.  movement in the opposite direction will still be possible.

Adapt to DB25 connectors commonly used by pc based controls.
   Many old pc based controls used parellel port cards for step and direction signals, this solution will create an easy way
   to make an adapter with DB25 connectors to make an easy plug in replacement based on smoothie.  The solution should be
   able to be reprogrammed for different configurations.

All of these issues can be addressed with some simple hardware, however if discrete gates and logic were used there would be 
customs circuit boards and development to implement it.  Fortuneatly I have found an easier way,  by using a CPLD - Complex 
Programable Logic Device.  Each CPLD contains literally hundreds of logic chips, and can be programmed to assemble them in 
any way needed.  Also, there are many CPLD chips already soldered onto breakout boards making development and implementation
very easy.

I am basing my first attempt off the Altera EPM240T100C5N chip.  They are popular and very inexpensive.
