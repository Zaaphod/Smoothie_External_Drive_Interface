;This is to test for the stepper driver for slow reaction to the step pulse
;If the driver takes longer than 4µS to actually step, it could possibly step once in the opposite direction
;This would only happen if an axis sets it's own direction.  ie, X will be reversing, so the last X step also 
;sets the X direction
;This test is designed to make this happen in the same direction repeatedly so the error can be detected.
;Each time this program is run, the machine would be off by -20 steps in the x direction
;because not only does it not step in the correct direction, it makes one step backwards instead.
;run testdir2.gcode to prove the drift does not happen if an axis does not reverse on itself.
;
 G00 X0 Y0
 G01 Y10  ;move Y+ set X to go +
 G01 X10  ;move X+ set X to go -  This will step once in the wrong direction for an error of -2 steps
 G01 X0   ;move X- set Y to go -
 G01 Y0   ;move Y- set X to go +
 G01 X10  ;move X+ set X to go -  This will step once in the wrong direction for an error of -2 steps
 G01 X0   ;move X- set Y to go +
 G01 Y10  ;move y+ set X to go +
 G01 X10  ;move X+ set X to go -  This will step once in the wrong direction for an error of -2 steps
 G01 X0   ;move X- set Y to go -
 G01 Y0   ;move Y- set X to go +
 G01 X10  ;move X+ set X to go -  This will step once in the wrong direction for an error of -2 steps
 G01 X0   ;move X- set Y to go +
 G01 Y10  ;move y+ set X to go +
 G01 X10  ;move X+ set X to go -  This will step once in the wrong direction for an error of -2 steps
 G01 X0   ;move X- set Y to go -
 G01 Y0   ;move Y- set X to go +
 G01 X10  ;move X+ set X to go -  This will step once in the wrong direction for an error of -2 steps
 G01 X0   ;move X- set Y to go +
 G01 Y10  ;move y+ set X to go +
 G01 X10  ;move X+ set X to go -  This will step once in the wrong direction for an error of -2 steps
 G01 X0   ;move X- set Y to go -
 G01 Y0   ;move Y- set X to go +
 G01 X10  ;move X+ set X to go -  This will step once in the wrong direction for an error of -2 steps
 G01 X0   ;move X- set Y to go +
 G01 Y10  ;move y+ set X to go +
 G01 X10  ;move X+ set X to go -  This will step once in the wrong direction for an error of -2 steps
 G01 X0   ;move X- set Y to go -
 G01 Y0   ;move Y- set X to go +
 G01 X10  ;move X+ set X to go -  This will step once in the wrong direction for an error of -2 steps
 G01 X0   ;move X- set Y to go +
 G01 Y10  ;move y+ set X to go +
 G01 Y0
 G01 X0
