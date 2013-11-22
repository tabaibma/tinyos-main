# Authors : Tharun and Mohammad
# Testscript for GreenBlink Application 

""" This file contains the simulation for Floodingbased Tree as given 
    in Assignment 4, task 1.

    Usage:
    python testscript.py <topology_file_name> (or) python testscript.py
    Note: when used as "python testscript.py", it takes the topology file topo.txt, which 
          must be in your directory. 

    Sample Usage:
    python testscript.py topo16.txt """
 


from TOSSIM import *
import sys

def main():
    """ contains simulation for our app """
    simulate(debug = False)

def simulate(debug = False):
    # creating an object of Tossim and getting a node from the simulation
    t = Tossim([])
    r = t.radio()

    # Getting the params from the command line arguments
    # default is 50000 events
    event_count = 50000
    if (len(sys.argv)) == 1:
        topo_file = "topo.txt"
    else:
        try:
            topo_file = str(sys.argv[1])
        except (ValueError, IndexError) as ex:
            print ex, ". Usage: python testscript.py <topology_file>"
            sys.exit()

    # adding graph
    f = open(topo_file, "r")
    if debug:
        print "Adding Topology from "+str(topo_file)+" which is as follows:"
        print " ", "Src", "Dest", "Gain"
    lines = f.readlines()
    all_nodes = set()
    for line in lines:
        s = line.split()
        if (len(s) > 0):
            if debug:
                print " ", s[0], " ", s[1], " ", s[2];
            all_nodes.add(int(s[0]))
            all_nodes.add(int(s[1]))
            r.add(int(s[0]), int(s[1]), float(s[2]))
    nodes = max(all_nodes)

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
        if debug:
            print "Creating noise model for ",i;
        t.getNode(i).createNoiseModel()


    print "Running simulation with "+str(event_count)+" events and "+str(nodes)+" nodes and on "+topo_file
    
    motes = [t.getNode(i) for i in range(1, nodes + 1)]

    # Adding channels to the simulation, to send the Debugging statements to stdout
    t.addChannel("Boot", sys.stdout)
    t.addChannel("FloodingBasedTreeC", sys.stdout)

    # Boot the motes
    for mote in motes: 
        mote.bootAtTime(100);

    #Running events
    for i in range(event_count):
        t.runNextEvent()

    print "End of Simulation"

    
if __name__ == "__main__":
    main()
