// pt.p
//      To get the echo pulse on pin P8 15.
//      assemble:  pasm -v3 -b pt.p    (could be pasm_2 if you follow directions
.setcallreg r29.w0  //  Going to use r31 for interrupt
.origin 0
.entrypoint T811
#define CTRL 0x22000 //Start of control registers.
T811:
   mov r8,CTRL      //set r8 for the lbbo 
   ldi r12, 0     // Local memory address for pru0 data memory
   ldi r2, 0      // zero to zero the cycle counter
TB1:
  qbbs TB1,r31,15 // wait here for echo line to go low

// WAIT FOR THE ECHO PULSE
TB2:
  qbbc TB2,r31,15 // wait here for echo line to go high - start of pulse

// START THE CYCLE COUNTER

  lbbo r9,r8,0,4  // Get the control register
  set r9,3        // Set the cycle counter enable
  sbbo r9,r8,0,4  // Put back to the register to start

// WAIT FOR THE PULSE TO END

TB3:
  qbbs TB3,r31,15 // wait here until echo line goes low.

// STOP THE CYCLE COUNTER
  lbbo r9,r8,0,4  // get control register
  clr r9,3        // clear counter to disable
  sbbo r9,r8,0,4  // put back
  ldi r10,1       // not neccessary, was going to use as signal

// GET THE CYCLE COUNT AND PUT IN PRU0 LOCAL DATA MEMORY

  lbbo r11,r8,12,4  // get the CYCLE count
  sbbo r10,r12,0,8  // put r10 & r11 (the unused signal & cycle count) in
                    // pru0 data memory
  sbbo r2,r8,12,4  // Zero the cycle count

//  SEND INTERRUPT SIGNAL TO LINUX SIDE

  mov r31.b0,35    //Send interrupt to Linux side

  lbbo r11,r12,8,4 // Check for end flag from Linux side
  qbne TB1,r11,2   // go back for more
TB4:
  halt
