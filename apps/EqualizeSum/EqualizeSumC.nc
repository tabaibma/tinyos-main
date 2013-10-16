/**
* @authors : Tharun and Mohammad
* Assignment 3 of ESE575
*/

#include <Timer.h>
#include "EqualizeSum.h"

module EqualizeSumC {
  uses interface Boot;
  uses interface Packet;
  uses interface AMSend;
  uses interface Receive;
  uses interface Random;
  uses interface SplitControl;
}
implementation {

  message_t pkt;
  uint16_t local1; 
  uint16_t local2;
  uint16_t local3;
  uint32_t localSum;
  uint32_t remoteSum;
  bool busy = FALSE;

  void sendMessage() {
    dbg("EqualizeSumC", "Sending Message at time: %s \n", sim_time_string());
    if (!busy) {
      EqualizeSumMsg* espkt = (EqualizeSumMsg*)(call Packet.getPayload(&pkt, sizeof(EqualizeSumMsg)));
      espkt->nodeid = TOS_NODE_ID;
      espkt->n1 = call Random.rand16();
      espkt->n2 = call Random.rand16();
      espkt->n3 = call Random.rand16();
      local1 = espkt->n1;
      local2 = espkt->n2;
      local3 = espkt->n3;
      localSum = local1 + local2 + local3;
      dbg("EqualizeSumC", "Sending %d, %d and %d \n", espkt->n1, espkt->n2, espkt->n3);
      if (espkt == NULL) {
          return;
      }    
      if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(EqualizeSumMsg)) == SUCCESS) {
         busy = TRUE;
      }
    }
  }

  void processReceivedNumbers(uint16_t n1, uint16_t n2, uint16_t n3) {
    dbg("EqualizeSumC", "Received %d, %d and %d \n", n1, n2, n3);
    remoteSum = n1+n2+n3;
    if (localSum >= remoteSum) {
      dbg("EqualizeSumC", "Local Sum(%d) is greater than or equal to Remote Sum(%d), so doing nothing \n", localSum, remoteSum);
    }
    else {
      dbg("EqualizeSumC", "Local Sum(%d) is less that Remote Sum(%d) \n", localSum, remoteSum);
      local1 = n1;
      local2 = n2;
      local3 = n3;
      localSum = local1 + local2 + local3;
      dbg("EqualizeSumC", "New local numbers are %d, %d and %d, Sum = %d \n", local1, local2, local3, localSum);      
    }
  }

  event void Boot.booted() {
   dbg("EqualizeSumC", "Booted node: %d at %s \n", TOS_NODE_ID, sim_time_string());
      call SplitControl.start();
  }
  
  event void SplitControl.startDone(error_t err) {
    if (err == SUCCESS) {
       dbg("EqualizeSumC", "Component started at %s \n", sim_time_string());
       sendMessage();
    }
    else {
      call SplitControl.start();
    }
  }

  event void SplitControl.stopDone(error_t err) {
    dbg("EqualizeSumC", "Component stopped at %s \n", sim_time_string());
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if ((err == FAIL) || (err == ECANCEL)) {
      dbg("EqualizeSumC", "Sending error at %s \n", sim_time_string()); 
    }
    if (&pkt == msg) {
      busy = FALSE;
    }
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(EqualizeSumMsg)) {
      EqualizeSumMsg* espkt = (EqualizeSumMsg*)payload;
      processReceivedNumbers(espkt->n1,espkt->n2,espkt->n3);
    }
    return msg;
  }

}
  