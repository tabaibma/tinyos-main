""" This script generates topology file for tossim simulations.
    Usage:
    python topo_generator.py <file_name> <number_of_nodes> <graph_density> (or) python topo_generator.py
    Arguments: file_name - a string of file name for your topology (default topo1.txt)
    number_of_nodes - The number of nodes you want the topology for. (default 16)
    graph_density - a value between 0.0 and 1.0. Given any two nodes, this is the probability with 
    which the link exists between them. A probability of 1 gives you a completely
    connected graph and a probability of 0 gives you a completely isolated graph (default 0.40)

    Sample Usage: 
    python topo_generator.py topo16.txt 16 1
    Gives a completely connected graph of 16 nodes """

import random
import itertools
import sys

def main():
     if (len(sys.argv)) == 1:
          topo_file = "topo1.txt"
          nodes = 16
          density = 0.40
     else:
          try:
               topo_file = str(sys.argv[1])
               nodes = int(sys.argv[2])
               density = float(sys.argv[3])
          except (IndexError,ValueError) as ex:
               print ex, ". Usage: python topo_generator.py <file_name> <number_of_nodes> <graph_density(0 - 1)>"
               sys.exit()

     topo_con = open(topo_file, "w")
     
     for i in range(1,nodes+1):
          for j in range(i,nodes+1):
               if (i == j):
                    continue
               if random.random() < density:
                    topo_con.write(str(i)+" "+str(j)+" "+str(random.randrange(-65, -55, 1))+"\n")
                    topo_con.write(str(j)+" "+str(i)+" "+str(random.randrange(-65, -55, 1))+"\n")
     
     topo_con.close()
     print "Topology created in "+str(topo_file)
                    
if __name__=="__main__":
     main()
     
