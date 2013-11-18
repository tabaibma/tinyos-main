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
  LEVEL_DISCOVERY,
} BBConstructionMsgType;

typedef struct NeighborInfo {
  uint16_t nodeid;
  color_t color;
} NeighborInfo_t;

typedef nx_struct NeighborMsg {
  nx_uint16_t nodeid;
  nx_uint16_t color;
} NeighborMsg_t;
  

typedef nx_struct BBConstructionMsg {
  nx_uint16_t nodeid;
  nx_uint16_t m_type;
  nx_uint16_t level_no;
}  BBConstructionMsg;

#endif
