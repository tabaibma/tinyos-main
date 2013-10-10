# Authors : Tharun and Mohammad
# Testscript for LowerThreeBitsToLed Application 
from TOSSIM import *
import sys
 
# creating an object of Tossim and getting a node from the simulation
t = Tossim([])
m = t.getNode(32);

# Adding channels to the simulation, to send the Debugging statements to
# stdout
t.addChannel("Boot", sys.stdout)
t.addChannel("LowerThreeBitsToLedsC", sys.stdout)
t.addChannel("LedsC", sys.stdout)

# Boot the mote
m.bootAtTime(100);

# Running 100 events, 1st event will boot the mote, rest 99 will 
# increment counter and light up Leds
for i in range(100):
    t.runNextEvent()

print "ran testscript"
