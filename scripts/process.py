#!/bin/python

import sys
import json

def main():
   input_file = sys.argv[1]
   scale_factor = json.load(open(sys.argv[2]))['scale_factor']
   output_file = sys.argv[3]

   with open(input_file) as file:
       lines = file.readlines()
       values = [str(float(l.strip()) * scale_factor) for l in lines]


       with open(output_file,'w') as outf:
           outf.write('\n'.join(values))




if __name__ == '__main__':
    main()
