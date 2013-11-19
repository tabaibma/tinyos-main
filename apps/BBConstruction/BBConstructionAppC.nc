/**
* @authors : Tharun and Mohammad
* Assignment 4n of ESE575
*/

#include <Timer.h>
#include "BBConstruction.h"

configuration BBConstructionAppC {
}
implementation {
  components MainC;
  components BBConstructionC as App;
  components ActiveMessageC;
  components new AMSenderC(AM_BBC);
  components new AMReceiverC(AM_BBC);	      
  components new TimerMilliC() as Timer;
  components new TimerMilliC() as Timer2;
  components RandomC;

  App.Boot -> MainC;
  App.Packet -> AMSenderC;
  App.SplitControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Receive -> AMReceiverC;
  App.MilliTimer1 -> Timer;
  App.MilliTimer2 -> Timer2;
  App.Random -> RandomC;
}