import random
import sys

def main():

    if (len(sys.argv)) != 4:
        topo_file = "topo_gen.txt"
        nodes = 16
        density = 0.40
    else:
        try:
            topo_file = str(sys.argv[1])
            nodes = int(sys.argv[2])
            density = float(sys.argv[3])
        except ValueError, ex:
            print ex
            sys.exit()

    topo_con = open(topo_file, "w")

    for i in range(1,nodes+1):
        for j in range(1,nodes+1):
            if (i == j):
                continue
            if random.random() < density:
                topo_con.write(str(i)+" "+str(j)+" "+str(random.randrange(-65, -55, 1))+"\n")
    topo_con.close()

if __name__=="__main__":
    main()
                
