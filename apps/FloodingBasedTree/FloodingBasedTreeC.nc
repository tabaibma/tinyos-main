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
  uint16_t my_level = 100; // Using 100 as an initial sentinel value, nothing significant
  message_t pkt;
  bool busy = FALSE;

  void sendMessage() {
  // dbg("FloodingBasedTreeC", "Sending Message at time: %s \n", sim_time_string());
    if (!busy) {
      FloodingBasedTreeMsg* fbtpkt = (FloodingBasedTreeMsg*)(call Packet.getPayload(&pkt, sizeof(FloodingBasedTreeMsg)));
      fbtpkt->nodeid = TOS_NODE_ID;
      
      if (TOS_NODE_ID == 1) 
        fbtpkt->level_no = 1; // fbtpkt->level_no contains the level number of the neighbors
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
    // If you are node 1, you are the root and you have to initiate the flooding. 
    // I'm calling the millitimer at 10240ms as opposed to 10000ms in the specification as the simulation time has some offset
       if (TOS_NODE_ID == 1) 
         call MilliTimer.startOneShot(10240);
    }
    else {
      call SplitControl.start();
    }
  }
    
  event void MilliTimer.fired() {
      my_level = 0; // Root initializes it level to 0
      dbg("FloodingBasedTreeC", "My level is  %d at time %s \n", my_level, sim_time_string());
      sendMessage(); // And broadcasts the message to neighbors
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

  void processFloodingBasedTree(FloodingBasedTreeMsg* fbtpkt) {
      if (my_level != 100) {
        return;      // if the level has already been set by previous message, the function returns doing nothing. This prevents infinite loops/flooding.
      }
      my_level = fbtpkt->level_no;
      dbg("FloodingBasedTreeC", "My level is  %d at time %s \n",my_level, sim_time_string());
      dbg_clear("FloodingBasedTreeCStream", "%d %d %d\n", fbtpkt->nodeid, TOS_NODE_ID, my_level);
      sendMessage();
   }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(FloodingBasedTreeMsg)) {
      FloodingBasedTreeMsg* fbtpkt = (FloodingBasedTreeMsg*)payload;
     // dbg("FloodingBasedTreeC", "Received FBTMsg at %s from %d \n", sim_time_string(), fbtpkt->nodeid);
      processFloodingBasedTree(fbtpkt);      
    }
    return msg;
  }
}

  