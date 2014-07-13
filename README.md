Prutimer
========
Example of using the PRUSS on the BEAGLEBONE to time a pulse.

pt.c - Initialize the Pruss, send trigger pulse to the HC-SR04, waits for response from the PRUSS, reads the cycle count
       from the data memory of PRU0.  Computes the distance and displays on terminal.
       
pt.p - The PRUSS waits for echo to go high, starts cycle counter, waits for echo to go low, stops cycle counter and moves
       cycle count to local PRU0 data memory, zeros the counter and send signal to Linux side.
       
prujts-00A0.dts - The device tree overlay to enable the PRUSS
