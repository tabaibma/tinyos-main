#include "Timer.h"

configuration HilTimerMicroC {
  provides interface Init;
  provides interface Timer<TMicro> as TimerMicro[uint8_t num];
  provides interface LocalTime<TMicro>;
}
implementation {

  enum {
    TIMER_COUNT = uniqueCount(UQ_TIMER_MICRO)
  };

  components AlarmCounterMicroP, new AlarmToTimerC(TMicro),
    new VirtualizeTimerC(TMicro, TIMER_COUNT),
    new CounterToLocalTimeC(TMicro);

  Init = AlarmCounterMicroP;

  TimerMicro = VirtualizeTimerC;
  VirtualizeTimerC.TimerFrom -> AlarmToTimerC;
  AlarmToTimerC.Alarm -> AlarmCounterMicroP;

  LocalTime = CounterToLocalTimeC;
  CounterToLocalTimeC.Counter -> AlarmCounterMicroP;
}
