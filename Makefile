CC=gcc
PRU_ASM=pasm
DTC=dtc

all:
	@echo ">> Generating PRU binary"
	$(PRU_ASM) -V3 -b pt.p
	@echo ">> Compiling Sonar Example"
	$(CC) -c -o pt.o pt.c
	$(CC) -lpthread -lprussdrv -o pt pt.o
	@echo ">> Compiling device tree overlay"
	$(DTC) -O dtb -o prujts-00A0.dtbo -b 0 -@ prujts-00A0.dts
	@echo ">> copy prujts-00A0.dtbo to /lib/firmware"
	@echo ">> enable with: echo \"prujts\" > > /sys/devices/bone_capemgr.*/slots"
	
clean:
	rm -rf pt pt.o pt.bin prujts-00A0.dtbo
    
