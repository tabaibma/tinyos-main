/************************************************************/
README file for GreenBlink 
/************************************************************/

1. GreenBlinkAppC.nc

This file contains the wirings (interfaces) for the GreenBlinkC. We use a timer and Led for this application.

2. GreenBlinkC.nc

This file contains the module and actual implementation of our application. The implementation details are as follows:

When the application is booted, we start the timer which ticks periodically at 0.125 ms.

Whenever the timer is fired. We let the GreenLED to toggle. We assume that GreenLED is led1.

3. testscript.py

This testscript simulates the GreenBlink App. 

Usage:

% python testscript.py 200

You can pass the number of events you want to run as a command line argument. In the above example I asked for 200 events. If no argument is given, 100 events are run by default.

The description of the code is in the comments.

