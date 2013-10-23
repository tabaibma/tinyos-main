#include <Atm128Timer.h>

configuration AlarmCounterMicroP
{
  provides interface Init;
  provides interface Alarm<TMicro, uint32_t> as AlarmMicro32;
  provides interface Counter<TMicro, uint32_t> as CounterMicro32;
}
implementation
{
  components new Atm128AlarmAsyncC(TMicro, ATM128_CLK8_DIVIDE_32);

  Init = Atm128AlarmAsyncC;
  AlarmMicro32 = Atm128AlarmAsyncC;
  CounterMicro32 = Atm128AlarmAsyncC;
}
