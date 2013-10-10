/*
* @authors : Tharun and Mohammad
**/

configuration GreenBlinkAppC
{
}
implementation
{
  components MainC, GreenBlinkC, LedsC;
  components new TimerMilliC() as Timer;
  
  GreenBlinkC -> MainC.Boot;
  
  GreenBlinkC.MilliTimer -> Timer;
  GreenBlinkC.Leds -> LedsC;
}