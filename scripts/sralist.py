#!/usr/bin/env python                                                                                                                                                                
import sys
import os
import collections
import argparse
import json
import subprocess

## for a list containing a species on each line,
## given the path to sraFind file, returns the number
## of occurances for each species. i.e the number of SRAs
## available for each species


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-l", "--org_list", help="path to sra list with 1 column", required=True)
    parser.add_argument("-s", "--sraFind", help="returns number of occurances in sraFind file", required=True)
    parser.add_argument("-o", "--output", help="output", required=True)
    return(parser.parse_args())


def makeSRAlist(output, sraFind):
    org_dictgs = {}
    org_dictg = {}
    sraFind = sraFind
    with open(sraFind, "r") as infile:
        for i,line in enumerate(infile):
            split_line = [x.replace('"', '').replace("'", "").replace("\s"," ") for x in line.strip().split("\t")]
            gs = " ".join(split_line[12].split(" ")[0:2])
            g = " ".join(split_line[12].split(" ")[0:1])
            if split_line[9].startswith("ILLUMINA"):
                if gs in org_dictgs.keys():
                    org_dictgs[gs] += 1
                else:
                    org_dictgs[gs] = 1
            if split_line[9].startswith("ILLUMINA"):
                if g in org_dictg.keys():
                    org_dictg[g] += 1
                else:
                    org_dictg[g] = 1
                    
    outputGENUS = os.path.join(output, "sraG.txt")
    outputSPECIES = os.path.join(output, "sraGS.txt")

    
    os.makedirs(output)
                
    for file in [outputGENUS, outputSPECIES]:
        with open(file, "w") as infile:
            infile.write(json.dumps(org_dictg))
            infile.write(json.dumps(org_dictgs))
    
    return(org_dictg, org_dictgs)
                      

def certainSRAs(output, org_list):
    ''' if a list of sras is given, it returns the sra number for each in the list
    '''

    outputGENUS = os.path.join(output, "sraG.txt")
    outputSPECIES = os.path.join(output, "sraGS.txt")
    outputONLYLIST = os.path.join(output, "sralist.txt")

    #find 'organism_name':SPACEnumber, and return the number
    with open(org_list, "r") as infile:
        for line in infile:
            org = line.strip().split()
            SRA = '"{org[0]} {org[1]}"'.format(**locals())
            cmd = "grep -o '{SRA}:\s\d*' {outputSPECIES} >> {outputONLYLIST}".format(**locals())
                       
            try:
                subprocess.run(cmd,
                               shell=sys.platform !="win32",
                               stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE,
                               check=True)
            except subprocess.CalledProcessError:
                with open(outputONLYLIST, "a") as infile:
                    infile.write("{SRA}: 0\n".format(**locals()))
                    
    return()

         
def main():
    args=get_args()

    makeSRAlist(output=args.output, sraFind=args.sraFind )

    if args.org_list is not None:
        certainSRAs(args.output, args.org_list)

if __name__ == '__main__':
    main()
                 
