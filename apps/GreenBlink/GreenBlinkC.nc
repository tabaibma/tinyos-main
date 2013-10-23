/**
* Implementation for GreenBlink Application. Toggle the GreenLed at
* 8000 Hz.
**/

#include "Timer.h"

module GreenBlinkC @safe()
{
  uses interface Timer<TMicro> as MilliTimer;
  uses interface Leds;
  uses interface Boot;
}
implementation
{
  event void Boot.booted()
  {
    dbg("GreenBlinkC", "GreenLed is booted \n");
    call MilliTimer.startPeriodic(125);
  }

  event void MilliTimer.fired()
  {
    dbg("GreenBlinkC", "GreenLed fired @ %s.\n", sim_time_string());
    call Leds.led1Toggle();
  }
}