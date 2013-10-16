# Authors : Tharun and Mohammad
# Testscript for GreenBlink Application 

from TOSSIM import *
import sys
 
def main():
    """ contains simulation for our app """


    # creating an object of Tossim and getting a node from the simulation
    t = Tossim([])
    m1 = t.getNode(1);
    m2 = t.getNode(2);
    r = t.radio()

    # adding graph
    # I've used the topology provided in http://www.tinyos.net/dist-2.0.0/tinyos-2.0.0/doc/html/tutorial/lesson11.html
    # However, I'm using only two nodes in my simulation (specification says so)
    f = open("topo.txt", "r")

    lines = f.readlines()
    for line in lines:
        s = line.split()
        if (len(s) > 0):
            print " ", s[0], " ", s[1], " ", s[2];
            r.add(int(s[0]), int(s[1]), float(s[2]))

    # noise models
    # I've used the noise models as per http://www.tinyos.net/dist-2.0.0/tinyos-2.0.0/doc/html/tutorial/lesson11.html
    noise = open("meyer-heavy.txt", "r")
    lines = noise.readlines()

    for line in lines:
        strp = line.strip()
        if (strp != ""):
            val = int(strp)
            for i in range(1, 4):
                t.getNode(i).addNoiseTraceReading(val)

    for i in range(1, 4):
        print "Creating noise model for ",i;
        t.getNode(i).createNoiseModel()

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
    t.addChannel("EqualizeSumC", sys.stdout)

    # Boot the mote
    m1.bootAtTime(100);
    m2.bootAtTime(100);

    # Running 100 events, 1st event will boot the mote, rest 99 eventsn
    # will toggle the green led
    for i in range(event_count):
        t.runNextEvent()

    print "End of Simulation"


if __name__ == "__main__":
    main()
