#!/usr/bin/env python
#coding utf-8

import os, sys
from sys import argv
from time import sleep

def run(cmd):
    print cmd
    os.system(cmd)

if __name__ == "__main__":
    #cmd = 'nohup ../../bin/run_concrest exampleKLEE4.c > x & ' 
    #run(cmd)
    sleep(3600)
    cmd = 'killall -9 engine symbiosisse symbiosisSolver'
    run(cmd)

