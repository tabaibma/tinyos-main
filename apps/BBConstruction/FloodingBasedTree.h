//

#ifndef FLOODINGBASEDTREE_H
#define FLOODINGBASEDTREE_H

enum {
  AM_FBT = 7,
};

typedef enum FloodingBasedTreeMsgType {
  LEVEL_DISCOVERY,
} FloodingBasedTreeMsgType;

typedef nx_struct FloodingBasedTreeMsg {
  nx_uint16_t nodeid;
  nx_uint16_t m_type;
  nx_uint16_t level_no;
}  FloodingBasedTreeMsg;

#endif
