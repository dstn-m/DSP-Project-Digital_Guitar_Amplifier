// Welch, Wright, & Morrow, 
// Real-time Digital Signal Processing, 2011

///////////////////////////////////////////////////////////////////////
// Filename: ISRs.c
//
// Synopsis: Interrupt service routine for codec data transmit/receive
//
// Original ISRs file is a simple pass-through routine. This was modified
// to include all stages necessary to implement a basic digitial guitar amplifier
//
// input filter -> distortion -> 3-band EQ -> modulation effects -> volume attenuation -> output
///////////////////////////////////////////////////////////////////////
#include <stdbool.h>
#include "inputBPF.h"
#include "DSP_Config.h" 
#include "distortionModule.h"
#include "toneStack.h"
#include "verbBuf.h"
#include "sinLUT5Hz.h"

// Data is received as 2 16-bit words (left/right) packed into one
// 32-bit word.  The union allows the data to be accessed as a single 
// entity when transferring to and from the serial port, but still be 
// able to manipulate the left and right channels independently.

#define LEFT  0
#define RIGHT 1

volatile union {
	Uint32 UINT;
	Int16 Channel[2];
} CodecDataIn, CodecDataOut;


// volatile variables for user control
volatile int bypassDist = 0, 	// allows user to bypass the distortion stage
			 ampVolume  = 10; 	// 11 selectable volume levels, 10 is max
volatile int phaseFreq = 5,		// default phaser freq = 5Hz
			 phaseEn   = 0;		// enable/disable the phaser effect


/* add any global variables here */
Int16 input;
// ratio of user selected frequency to phaser default frequency
float phaseRatio = 0.0;
// scalars applied to output signal to manipulate the volume level
float volLevels[11] = {0.0, 0.01, 0.04, 0.09, 0.16, 0.25, 0.36, 0.49, 0.64, 0.81, 1.0};
// tracker variable
int maxOut = 0;
// circular buffer for delay/reverb
extern cbuffer cbuf;

interrupt void Codec_ISR()
///////////////////////////////////////////////////////////////////////
// Purpose:   Codec interface interrupt service routine  
//
// Input:     None
//
// Returns:   Nothing
//
// Calls:     CheckForOverrun, ReadCodecData, WriteCodecData
//
// Notes:     None
///////////////////////////////////////////////////////////////////////
{                    
	/* add any local variables here */
	float xRight;
	Int16 distOut, tonestackOut, verbOut, verbIn;
	int bpfOut, distIn;
	static Int16 output = 0;


 	if(CheckForOverrun())					// overrun error occurred (i.e. halted DSP)
		return;								// so serial port is reset to recover

  	CodecDataIn.UINT = ReadCodecData();		// get input data samples
	
	/* add your code starting here */

	// this example simply copies sample data from in to out
  	input  = CodecDataIn.Channel[ LEFT];
  	xRight = CodecDataIn.Channel[ RIGHT];

  	///////////
  	// debug- track magnitude of input
  	//maxInput = (abs(input) > maxInput) ? abs(input) : maxInput;
  	///////////

    ///////////////////////////////////////
    ///////    INPUT FILTERING    /////////
    ///////////////////////////////////////
  	// bandlimit the input btwn 100Hz & 8kHz
  	// and attenuate signal for additional headroom

  	bpfOut = ((inputBPF(&input)) >> 1);

    ///////////////////////////////////////
    ///////    DISTORTION STAGE   /////////
    ///////////////////////////////////////

  	// apply preamp gain
  	distIn = bpfOut * preampGain;

  	// run asymmetrical distortion - more even harmonics
  	distOut = (distModule1(&distIn));
  	// run symmetrical distortion - more odd harmonics, additional clipping
  	distOut = distModule2(&distOut);

    ///////////////////////////////////////
    ///////     EQUALIZER STAGE   /////////
    ///////////////////////////////////////
  	// allow user to bypass distortion and feed original input signal into tonestack
  	toneStackInBuf[0] = (bypassDist) ? distOut :  (Int16)bpfOut;

  	// PERFORM LOW, MID, AND HIGH FREQ FILTERING
  	distLow  = lowFilt(&toneStackInBuf[0]);
  	distMid  = midFilt(&toneStackInBuf[0]);
  	distTreb = highFilt(&toneStackInBuf[0]);
  	// shift buffer
  	toneStackInBuf[1] = toneStackInBuf[0];

  	// apply user selected gain on the bands
  	tonestackOut = (Int16)(bassGain * distLow) +
  	                (Int16)(midGain * distMid) +
  	               (Int16)(trebGain * distTreb);

    ///////////////////////////////////////
    /////     MODULATION STAGE      ///////
    ///////////////////////////////////////

  	// MODULATION INCLUDES 'REVERB' WITH OPTIONAL PHASER EFFECT

  	// sinusoid generator with LUT for phaser LFO
  	static float phIndx = 0;
  	phaseRatio = (float)phaseFreq / f0;

  	// gather every x-th sample
    if(samplerCnt == 0){
    	// calculate the LFO LUT index
        phIndx += phaseRatio;
        if(phIndx > (PHSIZE-1)){
            phIndx = phIndx - (PHSIZE);
        }
        // use 'dampened' signal -> the output of mid freq filter as input to delay buffer
            // apply phaser if enabled
            verbIn = (phaseEn) ?  (Int16)((distMid >> 1)*sLUT[(int)phIndx]) :
                                           distMid >> 1;
        // load the signal into the circular buffer
        loadBuf(&verbIn);
    }

    // increment the sampler counter
  	samplerCnt = (samplerCnt + 1) % SAMPLEOFFSET;

  	// if verb indx = 0, disable reverb on output
  	    // else read samples from the buffer
  			// sample read is dictated by the user-selected verbIndx -> see verbBuf.c file
  	sampleOut = (verbIndx == 0) ? 0 : (cbuf.buf[(cbuf.head + 1 + (VBUFLEN - verbLength[verbIndx])) % VBUFLEN]);


    ///////////////////////////////////////
    ////////     OUTPUT STAGE     / ///////
    ///////////////////////////////////////

  	// add the delayed sample to the current output signal
  	verbOut = (Int16)(tonestackOut + sampleOut);

  	///////////
  	// debug variable to monitor the magnitude of the output signal:
  	//maxOut = (abs(verbOut) > maxOut) ? abs(verbOut) : maxOut;
  	///////////

  	// apply user-selected volume attenuation
  	output = (Int16)(volLevels[ampVolume] * verbOut);

  	// route signal to output channels
	CodecDataOut.Channel[ LEFT] = output;
	CodecDataOut.Channel[RIGHT] = output;

	/* end your code here */

	WriteCodecData(CodecDataOut.UINT);		// send output data to  port
}

