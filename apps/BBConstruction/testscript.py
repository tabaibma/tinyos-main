# Authors : Tharun and Mohammad
# Testscript for GreenBlink Application 

from TOSSIM import *
import sys
 
def main():
    """ contains simulation for our app """

    # creating an object of Tossim and getting a node from the simulation
    t = Tossim([])
    r = t.radio()

    # Getting the params from the command line arguments
    # default is 500 events
    if (len(sys.argv)) != 4:
        topo_file = "topo.txt"
        event_count = 5000
        nodes = 5
    else:
        try:
            topo_file = str(sys.argv[1])
            event_count = int(sys.argv[2])
            nodes = int(sys.argv[3])
        except ValueError, ex:
            print ex
            sys.exit()

    # adding graph
    # I've used the topology provided in http://www.tinyos.net/dist-2.0.0/tinyos-2.0.0/doc/html/tutorial/lesson11.html
    # However, I'm using only two nodes in my simulation (specification says so)
    f = open(topo_file, "r")
    print "Adding Topology from "+str(topo_file)+" which is as follows:"
    print " ", "Src", "Dest", "Gain"
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
            for i in range(1, nodes + 1):
                t.getNode(i).addNoiseTraceReading(val)

    for i in range(1, nodes + 1):
        print "Creating noise model for ",i;
        t.getNode(i).createNoiseModel()


    print "Running simulation with "+str(event_count)+" events and "+str(nodes)+" nodes and on "+topo_file
    
    motes = [t.getNode(i) for i in range(1, nodes + 1)]

    # Adding channels to the simulation, to send the Debugging statements to
    # stdout
    t.addChannel("Boot", sys.stdout)
    t.addChannel("BBConstructionC", sys.stdout)

    # Boot the motes
    for mote in motes: 
        mote.bootAtTime(100);

    #Running events
    for i in range(event_count):
        t.runNextEvent()

    print "End of Simulation"

if __name__ == "__main__":
    main()
