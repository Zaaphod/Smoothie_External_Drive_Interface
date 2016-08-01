# Smoothie_External_Drive_Interface
This project is to create a hardware interface solution for using certain external stepper drives on Smoothieboard

Smoothieboard is great at generating smooth stepper motor motions, however there simple aren't enough resources
on board to accommodate every possible hardware configuration.  

The concept of this project is to get the features I want without re-writing the smoothie firmware.  I am hoping
this solution will allow me to use the standard firmware, yet properly drive my machines.

Issues this solution will address are:

Delay the direction pulse for slowly reacting stepper drives
     Smoothie's on-board and many external stepper drives have a very fast step pulse, only about 1µS is required
     Smoothie outputs stepper pulses about 3µS wide, and if the direction will be changing, it changes the direction
     signal about 4µS after the rising edge of the last step pulse.  This is no problem most of the time, because the
     step pulse is completed before the direction line changes.
     I have been experiencing a problem on Anaheim Automation BLD-75 Drivers because they have built in noise suppression
     that filters out noise by making sure any step pulses are present for longer than 8µS.  Due to this, the direction
     signal is changing right in the middle of the direction pulse and by the time the drive determines that it really
     is a step and not noise and performs the step, the direction line has been changed and it steps once in the
     wrong direction.  This doe not happen all the time, it only happens if an axis sets up its own direction change.
     I have developed a simple test for this situation and will include the file (testdir.gcode) in this repository.
     I have proven that delaying the direction signal will indeed solve the problem, however implementing a firmware
     solution is extremely difficult, so the first part of this project is to provide a delay of an adjustable amount
     of time to the direction lines to make this solution expandable to other drives which may have different timing
     requirements.  
See https://github.com/Smoothieware/Smoothieware/issues/972 for more information about this issue.

Create Differential Step and Direction Signals
     One of the reasons moderns stepper drives can run effectively with very short step pulses is they employ a differential
     input.  These drives will run with a single ended signal, however doing so will make the susceptible to electrical noise
     and they may false step due to noise.  If you filter the noise out, then you end up with the issue above, the best option
     is to provide these drives with a a true differential signal.  A differential signal is normally delivered over a twisted
     pair, one line is normally high while the other is normally low, when a signal is issued, they reverse, the high line goes
     low and the low line goes high.  Smoothie does not do this, signals are on one line and either ground or a positive power
     supply line are referenced. Smoothie does not have enough spare io pins as it is, so having it supply differential signals
     would be difficult.  This solution will input smoothie's single signal step and direction signals and generate differential
     signals better suited to drives with differential inputs.

Create a hardware lockout when limit switches are engaged
     Smoothie does not take into consideration which direction something was moving when a limit switch is activated, therefore
     it is possible to move in the same direction that a limit was activated.  This solution allows for disabling of the step
     signal when a limit signal is present in the direction attempted, this will result in the position in smoothie being
     incorrect, however it was inaccurate due to the limit in the first place.  movement in the opposite direction will still
     be possible.

Disable Step Output when drives are disabled
     Smoothie uses a drive enable signal to tell it's on-board drives to be on or off, this can also be wired to external drives
     However in some applications it is a VERY bad idea to disable the stepper drives during any kind of halt situation.
     It in fact can be downright dangerous.  Examples include machines using a stepper to hold up a vertical load, if the
     drive is suddenly disabled, the load could come crashing down.  Also many high speed cutting machines can be dangerous
     if the steppers are no longer holding position while the cutting tool is engaged in the material and the drives are suddenly
     disabled and no longer have holding torque.  The inertia of the spindle continuing to turn the cutting tool with no force
     holding anything in place and break the bit, or the spiral of the bit could pull the bit all the way through the machine table
     until the collet stops it, and then the collet could start a friction fire with the material... etc..  For these machines, 
     instead of wiring up the enable pin, this solution will instead intercept the step pulses when the enable signal is deactivated.
     When the drives are 'enabled' steps will pass through to the driver normally.

Adapt to DB25 connectors commonly used by pc based controls
     Many old pc based controls used parallel port cards for step and direction signals, this solution will create an easy way to
     make an adapter with DB25 connectors to make an easy plug in replacement based on smoothie.  The solution should be able to be
     reprogrammed for different configurations.

All of these issues can be addressed with some simple hardware, however if discrete gates and logic were used there would be customs
circuit boards and development to implement it.  Fortunately I have found an easier way,
by using a CPLD - Complex Programmable Logic Device.  Each CPLD contains literally hundreds of logic chips, and can be programmed
to assemble them in any way needed.  Also, there are many CPLD chips already soldered onto breakout boards making development and
implementation very easy.

I am basing my first attempt off the Altera EPM240T100C5N chip.  They are popular and very inexpensive, and also available on
suitable breakout boards.

Update:  I have branched this over to a EPM570T100C5N chip.  The only reason for doing so is that I got one in the main faster
than the other one.  The EMP570 chip does have more programmable gates, which aren't needed for this project, however it does
have one drawback: it as 4 less I/O pins than the EMP240.  This is because with the added logic included, it needed a way to
get more power to the chip, so 4 I/O pins were removed and replaced with 2 more ground and 2 more power pins.  The pins were all
re-arranged to accommodate this shortage, however please note, there is a 3.3V power pin in on pin 18 of one of the parallel ports!!
this pin is supposed to be ground!  If there is no connection to pin 18, there should not be a problem, or if there is, then this
pin could be cut from the board to eliminate the connection then pin 18 could be jumpered to pin 19.  I am updating the EMP240
schematic to match the EMP570 schematic more closely.  The EMP240 will be a better choice for this project due to the extra
I/O lines and the fact that is has no conflict with pin 18 on one port. 