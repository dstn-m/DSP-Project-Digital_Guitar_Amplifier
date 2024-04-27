// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2011
 
///////////////////////////////////////////////////////////////////////
// Filename: main.c
//
// Synopsis: Main program file for demonstration code
//
///////////////////////////////////////////////////////////////////////

#include "DSP_Config.h"
#include "toneStack.h"

int main()
{    
	
	// initialize DSP board
  	DSP_Init();

	// call StartUp for application specific code
	// defined in each application directory
	StartUp();
	
	// main stalls here, interrupts drive operation 
  	while(1) {
        // update EQ settings if user changes a knob in the GUI
  	  if((eqB != bPrev) || (eqM != mPrev) || (eqT != tPrev)){
  	    bPrev = eqB;
  	    mPrev = eqM;
  	    tPrev = eqT;
  	    setEQ();
  	  }

  	}   
}


