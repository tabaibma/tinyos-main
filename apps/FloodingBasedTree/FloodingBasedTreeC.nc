/**
* @authors : Tharun and Mohammad
* Assignment 3 of ESE575
*/

#include <Timer.h>
#include "FloodingBasedTree.h"

module FloodingBasedTreeC {
  uses interface Boot;
  uses interface Packet;
  uses interface AMSend;
  uses interface Receive;
  uses interface Random;
  uses interface SplitControl;
  uses interface Timer<TMilli> as MilliTimer;
}
implementation {
  uint16_t my_level = 100;
  message_t pkt;
  bool busy = FALSE;

  void sendMessage() {
  // dbg("FloodingBasedTreeC", "Sending Message at time: %s \n", sim_time_string());
    if (!busy) {
      FloodingBasedTreeMsg* fbtpkt = (FloodingBasedTreeMsg*)(call Packet.getPayload(&pkt, sizeof(FloodingBasedTreeMsg)));
      fbtpkt->nodeid = TOS_NODE_ID;
      fbtpkt->m_type = LEVEL_DISCOVERY;
      if (TOS_NODE_ID == 1) 
        fbtpkt->level_no = 1;
      else
        fbtpkt->level_no = my_level + 1;        
     // dbg("FloodingBasedTreeC", "Sending Level Discovery with level no %d from %d \n", fbtpkt->level_no, fbtpkt->nodeid);
      if (fbtpkt == NULL) {
          return;
      }    
      if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(FloodingBasedTreeMsg)) == SUCCESS) {
         busy = TRUE;
      }
    }
  }


  event void Boot.booted() {
  // dbg("FloodingBasedTreeC", "Booted node: %d at %s \n", TOS_NODE_ID, sim_time_string());
      call SplitControl.start();
  }
  
  event void SplitControl.startDone(error_t err) {
    if (err == SUCCESS) {
    //   dbg("FloodingBasedTreeC", "Component started at %s \n", sim_time_string());
       if (TOS_NODE_ID == 1) 
         call MilliTimer.startOneShot(10240);
    }
    else {
      call SplitControl.start();
    }
  }
    
  event void MilliTimer.fired() {
      my_level = 0;
      dbg("FloodingBasedTreeC", "My level is %d \n", my_level);
      sendMessage();
  }

  event void SplitControl.stopDone(error_t err) {
    dbg("FloodingBasedTreeC", "Component stopped at %s \n", sim_time_string());
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if ((err == FAIL) || (err == ECANCEL)) {
      dbg("FloodingBasedTreeC", "Sending error at %s \n", sim_time_string()); 
    }
    if (&pkt == msg) {
      busy = FALSE;
    }
  }

  void processFloodingBasedTree(uint16_t nodeid, FloodingBasedTreeMsgType m_type, uint16_t level_no) {
      if (my_level != 100) {
        return;
      }
      dbg("FloodingBasedTreeC", "My level is  %d at time %s \n",level_no, sim_time_string());
      my_level = level_no;
      sendMessage();
   }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(FloodingBasedTreeMsg)) {
      FloodingBasedTreeMsg* fbtpkt = (FloodingBasedTreeMsg*)payload;
     // dbg("FloodingBasedTreeC", "Received FBTMsg at %s from %d \n", sim_time_string(), fbtpkt->nodeid);
      processFloodingBasedTree(fbtpkt->nodeid, fbtpkt->m_type, fbtpkt->level_no);      
    }
    return msg;
  }
}

  