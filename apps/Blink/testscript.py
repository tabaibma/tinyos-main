from TOSSIM import *
import sys
 
t = Tossim([])
m = t.getNode(32);

t.addChannel("Boot", sys.stdout)
t.addChannel("BlinkC", sys.stdout)
t.addChannel("LedsC", sys.stdout)

m.bootAtTime(100);

t.runNextEvent()
t.runNextEvent()

for i in range(100):
    t.runNextEvent()

print "Running TestScript"
