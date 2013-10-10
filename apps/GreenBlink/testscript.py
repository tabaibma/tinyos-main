# Authors : Tharun and Mohammad
# Testscript for GreenBlink Application 

from TOSSIM import *
import sys
 
def main():
    """ contains simulation for our app """


    # creating an object of Tossim and getting a node from the simulation
    t = Tossim([])
    m = t.getNode(32);

    # Getting the number of events from the command line arguments
    # default is 100 events
    if (len(sys.argv)) != 2:
        event_count = 100
    else:
        try:
            event_count = int(sys.argv[1])
        except ValueError, ex:
            print ex
            sys.exit()

    print "Running simulation with "+str(event_count)+" events"

    # Adding channels to the simulation, to send the Debugging statements to
    # stdout
    t.addChannel("Boot", sys.stdout)
    t.addChannel("GreenBlinkC", sys.stdout)
    t.addChannel("LedsC", sys.stdout)

    # Boot the mote
    m.bootAtTime(100);

    # Running 100 events, 1st event will boot the mote, rest 99 eventsn
    # will toggle the green led
    for i in range(event_count):
        t.runNextEvent()

    print "End of Simulation"


if __name__ == "__main__":
    main()
