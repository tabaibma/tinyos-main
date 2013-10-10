/**
* Authors: Tharun and Mohammad
**/

configuration LowerThreeBitsToLedsAppC 
{
}
implementation 
{
  components MainC, LowerThreeBitsToLedsC as CountApp, LedsC;	       
  components new TimerMilliC() as Timer;
  
  CountApp -> MainC.Boot;

  CountApp.MilliTimer -> Timer;
  CountApp.Leds -> LedsC;
}

