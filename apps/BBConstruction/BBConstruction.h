//

#ifndef BBCONSTRUCTION_H
#define BBCONSTRUCTION_H

enum {
  AM_BBC = 7,
};

typedef enum {
  WHITE,
  GREY,
  BLACK
} color_t;

typedef enum BBConstructionMsgType {
  HELLO,
  COLOR_GREY
} BBConstructionMsgType;

typedef nx_struct colorMsg {
  nx_uint16_t nodeid;
} colorMsg_t;

typedef struct NeighborInfo {
  uint16_t nodeid;
  color_t color;
} NeighborInfo_t;

typedef nx_struct NeighborMsg {
  nx_uint16_t color;
} NeighborMsg_t;
  

typedef nx_struct BBConstructionMsg {
  nx_uint16_t nodeid;
  nx_uint16_t msgType;
  nx_uint16_t color;
}  BBConstructionMsg;

#endif
