#!/usr/bin/env python
import subprocess
import argparse


def aomdv(args):
	print("AOMDV SIMULATION")
	print("\n\n\n")
	tf = args['output'] + ".tr"
	sf = args['output'] + ".nam"
	print("** Running Tcl file with ns2 **")
	subprocess.Popen(
		[
			'ns', 'wireless-AOMDV.tcl', '-nn', str(args['nodenumber']), '-ns', str(args['nodespeed']), 
			'-pt', str(args['pausetime']), '-st', str(args['simulationtime']), '-cn', str(args['connection']),
			'-out', args['output']
		]
	).wait()
	print("** Running Awk file with awk **")
	subprocess.Popen(['awk', '-f', 'wireless-AOMDV.awk', tf]).wait()
	print("** Running Nam file with nam **")
	subprocess.Popen(['nam', sf]).wait()
	print("\n\n")


if __name__ == '__main__':
	# Construct the argument parser
	ap=argparse.ArgumentParser(description="AOMDV SIMULATION PROGRAM")

	# Add the arguments to the parser
	ap.add_argument("-nn", "--nodenumber", type=int,
					required=True, help="Number of Nodes")
	ap.add_argument("-ns", "--nodespeed", type=int,
					default=10, help="Nodes Speed")
	ap.add_argument("-pt", "--pausetime", type=int,
					default=10, help="Pause Time")
	ap.add_argument("-st", "--simulationtime", type=int,
					required=True, help="Simulation Time")
	ap.add_argument("-cn", "--connection", type=int,
					required=True, help="Connections")
	ap.add_argument("-out", "--output",	default="wireless-AOMDV",
					help="Output filename")

	args=vars(ap.parse_args())
	aomdv(args)
