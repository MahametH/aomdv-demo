# wireless-AOMDV.tcl
# A simple example for AOMDV simulation

# ======================================================================
# Define options
# ======================================================================
set val(chan)           Channel/WirelessChannel     ;# channel type
set val(prop)           Propagation/TwoRayGround    ;# radio-propagation model
set val(netif)          Phy/WirelessPhy             ;# network interface type
set val(mac)            Mac/802_11                  ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue     ;# interface queue type
set val(ll)             LL                          ;# link layer type
set val(ant)            Antenna/OmniAntenna         ;# antenna model
set val(ifqlen)         50                          ;# max packet in ifq
set val(rp)             AOMDV                       ;# routing protocol

set opt(x)              800                         ;# X dimension of the topography
set opt(y)              800                         ;# Y dimension of the topography

# ======================================================================
# Default Script Options
# ======================================================================
set opt(nn)				20			                ;# Number of Nodes
set opt(ns)				10			                ;# Nodes  Speed
set opt(pt)				10			                ;# Pause time
set opt(cn)    5                                    ;# Number of connections

set opt(st)           100                         ;# Simulation Time
set opt(dataRate)       [expr 1.0*256*8]            ;# Packet size=256 bytes
set opt(out)            "wireless-AOMDV"            ;# Trace file

# ======================================================================
# Read arguments
# ======================================================================
proc usage {} {
    global argv0

    puts "\nusage: $argv0 \[-nn <nodes>\] \[-ns <nodes speed (optional, default=10)>\] \[-pt <pause time (optional, default=10)>\] \[-st <simulation time>\] \[-cn <connections>\] \[-out <output file name (optional, , default=wireless-AOMDV)>\]\n"
}

proc getopt {argc argv} {
	global opt
	lappend optlist nn ns pt st cn out

	for {set i 0} {$i < $argc} {incr i} {
		set arg [lindex $argv $i]
		if {[string range $arg 0 0] != "-"} continue

		set name [string range $arg 1 end]
		set opt($name) [lindex $argv [expr $i+1]]
	}
}

# Main Program
getopt $argc $argv

getopt $argc $argv

if { $argc < 6 } {
	usage
	exit 
}

if { $opt(nn) == "" || $opt(st) == "" || $opt(cn) == "" } {
	usage 
	exit 
}

if { $opt(nn) == 0 } {
	usage
	exit
}

# ------------------------------------------------------------------------------
# General definition
# ------------------------------------------------------------------------------
set ns_		[new Simulator]                         ;# Instantiate the simulator
set topo	[new Topography]                        ;# Define topology

# Trace file definition
set tracefd	[open $opt(out).tr w]
set namtrace    [open $opt(out).nam w]

$ns_ trace-all $tracefd
$ns_ namtrace-all-wireless $namtrace $opt(x) $opt(y)

# Declare finish program
proc finish {} {
	global ns_ tracefd namtrace opt
	$ns_ flush-trace
	close $tracefd
	close $namtrace
	
	exit 0
}

# Define topology
$topo load_flatgrid $opt(x) $opt(y)

# Create God(Generate Operations Director): stores table of shortest no of hops from 1 node to another
set god_ [create-god $opt(nn)]

# Define how node should be created
# Global node setting
$ns_ node-config -adhocRouting $val(rp) \
                 -llType $val(ll) \
                 -macType $val(mac) \
                 -ifqType $val(ifq) \
                 -ifqLen $val(ifqlen) \
                 -antType $val(ant) \
                 -propType $val(prop) \
                 -phyType $val(netif) \
                 -channelType $val(chan) \
		 		 -topoInstance $topo \
		 		 -agentTrace ON \
                 -movementTrace ON \
                 -routerTrace ON \
                 -macTrace ON

# Create the specified number of nodes [$opt(nn)] and "attach" them to the channel.
for {set i 0} {$i < $opt(nn) } {incr i} {
	set node_($i) [$ns_ node]
	$node_($i) random-motion 1		;# disable random motion
}

# Node InitialPosition
for {set i 0} {$i < $opt(nn) } {incr i} {
    $node_($i) set X_ [expr rand()*500]
    $node_($i) set Y_ [expr rand()*500]
    $node_($i) set Z_ 0
}

for {set i 0} {$i < $opt(nn)} {incr i} {
    $ns_ initial_node_pos $node_($i) 20
}

for {set i 0} {$i < $opt(cn)} {incr i} {

    #Setup a UDP connection
    set udp_($i) [new Agent/UDP]
    $ns_ attach-agent $node_($i) $udp_($i)
    set null_($i) [new Agent/Null]
    $ns_ attach-agent $node_([expr $i+2]) $null_($i)
    $ns_ connect $udp_($i) $null_($i)

    #Setup a CBR over UDP connection
    set cbr_($i) [new Application/Traffic/CBR]
    $cbr_($i) attach-agent $udp_($i)
    $cbr_($i) set type_ CBR
    $cbr_($i) set packet_size_ 256
    $cbr_($i) set rate_ $opt(dataRate)
    $cbr_($i) set interval_ 0.001
    $cbr_($i) set random_ false

    $ns_ at 0.0 "$cbr_($i) start"
    $ns_ at $opt(st) "$cbr_($i) stop"
}

# Random motion
for {set j 0} {$j < 10} {incr j} {
    for {set i 0} {$i < $opt(nn)} {incr i} {
        set xx_ [expr rand()*$opt(x)]
        set yy_ [expr rand()*$opt(y)]
        set rng_time [expr rand()*$opt(st)]
        $ns_ at $rng_time "$node_($i) setdest $xx_ $yy_ 15.0"   ;
    }
}

# Tell nodes when the simulation ends
for {set i 0} {$i < $opt(nn) } {incr i} {
    $ns_ at $opt(st) "$node_($i) reset";
}

$ns_ at $opt(st) "finish"
$ns_ run