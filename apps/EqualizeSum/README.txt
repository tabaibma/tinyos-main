/************************************************************/
README file for EqualizeSum 
/************************************************************/

1. EqualizeSumAppC.nc

This file contains the wirings (interfaces) for the EqualizeSumC . We use Packet, SplitControl, AMSend, Receive and Random interfaces for this application.

2. EqualizeSumC.nc

This file contains the module and actual implementation of our application. The implementation details are as follows:

When the application is booted, We start the component. 
When the component is started, we broadcast our message which contains 3 random numbers.
The message is received by another node and the processing is done as per the assignment specification

3. testscript.py

This testscript simulates the EqualizeSum App. 

Usage:

% python testscript.py 200

You can pass the number of events you want to run as a command line argument. In the above example I asked for 200 events. If no argument is given, 100 events are run by default.

The description of the code is in the comments.

