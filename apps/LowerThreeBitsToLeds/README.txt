/************************************************************/
README file for LowerThreeBitsToLed 
/************************************************************/

1. LowerThreeBitsToLedAppc.nc

This file contains the wirings (interfaces) for the LowerThreeBitsToLedC. We used a Timer and an Led.

2. LowerThreeBitsToLedc.nc

This file contains the module and the actual implementation of our application. The implementation details are as follows:

     a. We declare and initialize to zero a counter variable of unsigned integer type.
 
     b. When the application is booted, we start the timer which ticks every 0.125 ms. 

     c. When the timer is fired, we increment counter and also check for the lower three bits in the counter. We light up the leds corresponding to the lower three bits.

3. testscript.py

This testscript simulates the LowerThreeBitsToLed App. 

Usage:

% python testscript.py 200

You can pass the number of events you want to run as a command line argument. In the above example I asked for 200 events. If no argument is given, 100 events are run by default.

The description of the code is in the comments.
