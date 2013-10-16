/**
* @authors : Tharun and Mohammad
* Assignment 3 of ESE575
*/

#include <Timer.h>
#include "EqualizeSum.h"

configuration EqualizeSumAppC {
}
implementation {
  components MainC;
  components EqualizeSumC as App;
  components ActiveMessageC;
  components new AMSenderC(AM_EQ_SUM);
  components new AMReceiverC(AM_EQ_SUM);	      
  components RandomC;

  App.Boot -> MainC;
  App.Packet -> AMSenderC;
  App.SplitControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Receive -> AMReceiverC;
  App.Random -> RandomC;
}