/**
* @authors : Tharun and Mohammad
* Assignment 4n of ESE575
*/

#include <Timer.h>
#include "FloodingBasedTree.h"

configuration FloodingBasedTreeAppC {
}
implementation {
  components MainC;
  components FloodingBasedTreeC as App;
  components ActiveMessageC;
  components new AMSenderC(AM_FBT);
  components new AMReceiverC(AM_FBT);	      
  components RandomC;

  App.Boot -> MainC;
  App.Packet -> AMSenderC;
  App.SplitControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Receive -> AMReceiverC;
  App.Random -> RandomC;
}