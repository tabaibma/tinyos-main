/**
* @authors : Tharun and Mohammad
* Assignment 3 of ESE575
*/

#include <Timer.h>
#include "BBConstruction.h"

#define MAX_NEIGHBORS 50

module BBConstructionC {
  uses interface Boot;
  uses interface Packet;
  uses interface AMSend;
  uses interface Receive;
  uses interface Random;
  uses interface Timer<TMilli> as MilliTimer1;
  uses interface Timer<TMilli> as MilliTimer2;
  uses interface SplitControl;
}
implementation {
  uint16_t my_color = WHITE;
  message_t pkt;
  int16_t neighborList[MAX_NEIGHBORS];
  uint16_t neighborsTotal = 0;
  bool busy = FALSE;
  NeighborInfo_t n;


  void sendBBMessage(BBConstructionMsgType msgType) {
   // dbg("BBConstructionC", "Sending bb Message at time: %s \n", sim_time_string());
    if (!busy) {
      BBConstructionMsg* npkt = (BBConstructionMsg*)(call Packet.getPayload(&pkt, sizeof(BBConstructionMsg)));
      npkt->nodeid = TOS_NODE_ID;
      npkt->msgType = msgType;
      npkt->color = my_color;
      if (npkt == NULL) {
        return;
      }
      if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BBConstructionMsg)) == SUCCESS) {
        busy = TRUE;
      }
    }
  }

  void sendMessage() {
  }
  
  void initializeNeighbors() {
    uint16_t i;
    for (i = 0; i < MAX_NEIGHBORS; i++) {
     neighborList[i] = -1;
    }
  }

  event void Boot.booted() {
   //dbg("BBConstructionC", "Booted node: %d at %s \n", TOS_NODE_ID, sim_time_string());
      call SplitControl.start();
  }
  
  event void SplitControl.startDone(error_t err) {
    if (err == SUCCESS) {
     //  dbg("BBConstructionC", "Component started at %s \n", sim_time_string());
       initializeNeighbors();
       call MilliTimer1.startPeriodic(2000);
       call MilliTimer2.startPeriodic(4500);
    }
    else {
      call SplitControl.start();
    }
  }
    
  void printNeighbors() {
    uint16_t i;
    dbg("BBConstructionC", "Neighbors are");
    for (i = 0; i < neighborsTotal; i++) {
      dbg("BBConstructionC", "%d", neighborList[i]);
    }
    dbg("BBConstructionC", "\n");
  }
 
 bool hasWhiteNeighbors() {
  uint16_t i;
  for (i = 0; i < MAX_NEIGHBORS; i++) {
    if (neighborList[i] == WHITE) 
      return TRUE;
  }
  return FALSE;
 }

 void color_neighbors_grey() {
 
 }
 
  event void MilliTimer1.fired() {
   sendBBMessage(HELLO);
   //dbg("BBConstructionC", "Sending neighbor msg at %s \n", sim_time_string());
   //dbg("BBConstructionC", "I'm node %d and my color is %d at %s \n", TOS_NODE_ID,my_color, sim_time_string());
   if (TOS_NODE_ID == 1) {
    if (my_color == WHITE) {
      my_color = GREY;
    }
   }
 } 
 event void MilliTimer2.fired() {
      if ((my_color == GREY) && (hasWhiteNeighbors())) {
//      dbg("BBConstructionC", "my color is %d \n", my_color);
      my_color = BLACK;
      dbg("BBConstructionC", "I turned black \n");
      sendBBMessage(COLOR_GREY);
    }
 }
       

  
 event void SplitControl.stopDone(error_t err) {
    //dbg("BBConstructionC", "Component stopped at %s \n", sim_time_string());
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if ((err == FAIL) || (err == ECANCEL)) {
      dbg("BBConstructionC", "Sending error at %s \n", sim_time_string()); 
    }
    if (&pkt == msg) {
      busy = FALSE;
    }
  }

   void processNeighborMsg(uint16_t nodeid, uint16_t color) {
     neighborList[nodeid] = color;
 }

  void processColorMsg(uint16_t nodeid) {
   if (my_color == WHITE) {
    // dbg("BBConstructionC", "Coloring grey, received from %d \n", nodeid);
     my_color = GREY;
   }
  }

  void processBBConstructionMsg(BBConstructionMsg *bbpkt) {
       switch(bbpkt->msgType) {
        case HELLO:    // dbg("BBConstructionC", "Neighbor Message received from %d at %s \n",bbpkt->nodeid,  sim_time_string()); 
	     		processNeighborMsg(bbpkt->nodeid, bbpkt->color);
			break;
	case COLOR_GREY: //dbg("BBConstructionC", "Color Grey received from %d at %s \n",bbpkt->nodeid,  sim_time_string()); 
	     		processColorMsg(bbpkt->nodeid);
			break;
	default: break;
	}
   }



  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(BBConstructionMsg)) {
      BBConstructionMsg* bbpkt = (BBConstructionMsg*)payload;
      processBBConstructionMsg(bbpkt);
    }
    return msg;
 }
}
  