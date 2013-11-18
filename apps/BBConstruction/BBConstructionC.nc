/**
* @authors : Tharun and Mohammad
* Assignment 3 of ESE575
*/

#include <Timer.h>
#include "BBConstruction.h"

module BBConstructionC {
  uses interface Boot;
  uses interface Packet;
  uses interface AMSend;
  uses interface Receive;
  uses interface Random;
  uses interface SplitControl;
}
implementation {
  uint16_t my_color = WHITE;
  message_t pkt;
  bool busy = FALSE;
  uint16_t initial_node = 1;

  void sendMessage() {
    dbg("BBConstructionC", "Sending Message at time: %s \n", sim_time_string());
    if (!busy) {
      BBConstructionMsg* fbtpkt = (BBConstructionMsg*)(call Packet.getPayload(&pkt, sizeof(BBConstructionMsg)));
      fbtpkt->nodeid = TOS_NODE_ID;
      fbtpkt->m_type = LEVEL_DISCOVERY;
      if (TOS_NODE_ID == 1) 
        fbtpkt->level_no = 1;
      else
        fbtpkt->level_no = my_level + 1;        
      dbg("BBConstructionC", "Sending Level Discovery with level no %d from %d \n", fbtpkt->level_no, fbtpkt->nodeid);
      if (fbtpkt == NULL) {
          return;
      }    
      if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BBConstructionMsg)) == SUCCESS) {
         busy = TRUE;
      }
    }
  }


  event void Boot.booted() {
   dbg("BBConstructionC", "Booted node: %d at %s \n", TOS_NODE_ID, sim_time_string());
      call SplitControl.start();
  }
  
  event void SplitControl.startDone(error_t err) {
    if (err == SUCCESS) {
       dbg("BBConstructionC", "Component started at %s \n", sim_time_string());
       if (TOS_NODE_ID == 1)  {
         my_level = 0;
         sendMessage();
       }
    }
    else {
      call SplitControl.start();
    }
  }
    

  event void SplitControl.stopDone(error_t err) {
    dbg("BBConstructionC", "Component stopped at %s \n", sim_time_string());
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if ((err == FAIL) || (err == ECANCEL)) {
      dbg("BBConstructionC", "Sending error at %s \n", sim_time_string()); 
    }
    if (&pkt == msg) {
      busy = FALSE;
    }
  }

  void processBBConstruction(uint16_t nodeid, BBConstructionMsgType m_type, uint16_t level_no) {
      if (my_level != 100) {
        return;
      }
      dbg("BBConstructionC", "Received level discovery message from %d and level no is  %d \n", nodeid, level_no);
      my_level = level_no;
      sendMessage();
   }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(BBConstructionMsg)) {
      BBConstructionMsg* fbtpkt = (BBConstructionMsg*)payload;
      processBBConstruction(fbtpkt->nodeid, fbtpkt->m_type, fbtpkt->level_no);      
    }
    return msg;
  }
}

  