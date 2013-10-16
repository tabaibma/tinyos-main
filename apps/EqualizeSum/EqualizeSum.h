//

#ifndef EQUALIZESUM_H
#define EQUALIZESUM_H

enum {
  AM_EQ_SUM = 7,
};

typedef nx_struct EqualizeSumMsg {
  nx_uint16_t nodeid;
  nx_uint16_t n1;
  nx_uint16_t n2;
  nx_uint16_t n3;
} EqualizeSumMsg;

#endif
