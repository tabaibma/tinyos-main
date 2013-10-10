/**
* Authors : Tharun and Mohammad
* Implementation of LowerThreeBitsToLeds
* More details are in the README.txt
**/

module LowerThreeBitsToLedsC @safe() {
  uses {
    interface Leds;
    interface Boot;
    interface Timer<TMilli> as MilliTimer;
  }
}
implementation {
  uint16_t counter = 0;

  event void Boot.booted() {
    dbg("LowerThreeBitsToLedsC", "Booted, Timer started. \n");
    call MilliTimer.startPeriodic(0.125);
    }

  event void MilliTimer.fired() {
    dbg("LowerThreeBitsToLedsC", "Current Counter is %d \n", counter);

    counter++;
    if (counter & 0x1) {
       call Leds.led0On();
    }
    else {
       call Leds.led0Off();
    }
    if (counter & 0x2) {
       call Leds.led1On();
    }
    else {
       call Leds.led1Off();
    }
    if (counter & 0x4) {
       call Leds.led2On();
    }
    else {
       call Leds.led2Off();
    }
  }
}
  
    
	       