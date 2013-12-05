 
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
import networkx as nx
import matplotlib.pyplot as plt
import os
import re
from openopt import DSP

def main():
    """ contains simulation for our app """
    simulate(debug = False, noise_model="meyer-heavy.txt")

def simulate(debug = False, noise_model = "meyer-heavy.txt"):
    # creating an object of Tossim and getting a node from the simulation
    t = Tossim([])
    r = t.radio()

    # Getting the params from the command line arguments
    # default is 50000 events
    event_count = 50000
    if (len(sys.argv)) == 1:
        topo_file = "./topologies/topo.txt"
    else:
        try:
            topo_file = str(sys.argv[1])
        except (ValueError, IndexError) as ex:
            print ex, ". Usage: python testscript.py <topology_file>"
            sys.exit()

    # adding graph
    main_graph = nx.Graph()
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
            main_graph.add_edge(int(s[0]), int(s[1]))
    nodes = max(all_nodes)
    mst = nx.minimum_spanning_tree(main_graph)
    
    print "Running simulation with "+str(event_count)+" events and "+str(nodes)+" nodes and on "+topo_file+" with noise model from "+noise_model
    # noise models
    # I've used the noise models as per http://www.tinyos.net/dist-2.0.0/tinyos-2.0.0/doc/html/tutorial/lesson11.html
    noise = open(noise_model, "r")
    lines = noise.readlines()

    for line in lines:
        strp = line.strip()
        if (strp != ""):
            val = int(strp)
            for i in range(1, nodes + 1):
                t.getNode(i).addNoiseTraceReading(val)

    # creating noise model
    for i in range(1, nodes + 1):
        if debug:
            print "Creating noise model for ",i;
        t.getNode(i).createNoiseModel()
    
    motes = [t.getNode(i) for i in range(1, nodes + 1)]

    # Adding channels to the simulation, to send the Debugging statements to stdout
    temp_file = open("mst.txt", 'w')
    t.addChannel("Boot", sys.stdout)
    t.addChannel("BBConstructionC", sys.stdout)
    t.addChannel("BBConstructionCStream", temp_file)

    # Boot the motes
    for mote in motes: 
        mote.bootAtTime(100);
    #Running events
    for i in range(event_count):
        t.runNextEvent()
    temp_file.close()

    # Creating bbgraph using nx
    bb_tree = nx.Graph()
    edge_list = []
    black_nodes = []
    readTree = open("mst.txt", 'r')
    for line in readTree:
        s = line.split()
        if (len(s) > 0):
            edge_list.append((int(s[0]), int(s[1])))
            black_nodes.append(int(s[0]))
    readTree.close()
    os.remove("mst.txt") #deleting temp file mst.txt

    black_nodes = set(black_nodes)
    grey_nodes = all_nodes - black_nodes
    
    bb_tree.add_nodes_from(all_nodes)
    bb_tree.add_edges_from(edge_list)
    pos = nx.circular_layout(bb_tree)

    #dominating set from openopt
    p = DSP(main_graph)
    r = p.solve('interalg', iprint=0)
    dom_set = set(r.solution)
    non_dom = all_nodes - dom_set

    ds_tree = nx.Graph()
    ds_tree.add_nodes_from(all_nodes)
    for node in dom_set:
        ds_tree.add_edges_from(nx.edges(main_graph, nbunch = node))
    pos_ds = nx.circular_layout(ds_tree)
    
    # plotting all the graph in one figure
    plt.subplot(131)
    nx.draw(main_graph)
    plt.title("Actual Graph")
    plt.subplot(132)
    nx.draw_networkx_nodes(ds_tree, pos_ds, 
                           nodelist = list(dom_set), 
                           node_color = "Black",
                           alpha = 0.7)
    nx.draw_networkx_nodes(ds_tree, pos_ds,
                           nodelist = list(non_dom),
                           node_color = "Green")
    #drawing edges and labels
    nx.draw_networkx_edges(ds_tree, pos_ds)
    nx.draw_networkx_labels(ds_tree,pos_ds)
    plt.title("Optimal Dominating Set")
    plt.subplot(133)
    # draw nodes
    nx.draw_networkx_nodes(bb_tree,pos,
                       nodelist=list(black_nodes),
                       node_color='Black',
                       alpha = 0.7)
    nx.draw_networkx_nodes(bb_tree,pos,
                       nodelist=list(grey_nodes), 
                       node_color='Green')
    #drawing edges and labels
    nx.draw_networkx_edges(bb_tree,pos)
    nx.draw_networkx_labels(bb_tree,pos)
    # plot it
    plt.title("Our BBTree")
    figure_file = "bb"+(re.match(r"(\..*/)?(.*)\.(.*)", topo_file)).group(2)+".png"
    figure_loc = "./figures/"+figure_file
    plt.savefig(figure_loc)
    plt.show()
    
    print "End of Simulation using "+noise_model
    return
    
if __name__ == "__main__":
    main()
