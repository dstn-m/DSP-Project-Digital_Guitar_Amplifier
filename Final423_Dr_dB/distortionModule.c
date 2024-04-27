/*
 * distortionModule.c
 *
 *  Created on: Apr 10, 2024
 *      Author: dstnm
 */

#include "distortionModule.h"
#include "distortionLUT.h"

volatile int preampGain = 1;    // scale factor for the input signal
int distLUTindx = 0,            // index in the lookup table
        sigLevel = 8192,       // scale factor for the output
        sigLevel2 = 6200,
        sigSign = 1;            // sign of the current signal

Int16 distLow = 0 , distMid = 0, distTreb = 0;

////////////////////////////////////////////////////////////////
Int16 distModule1(int* inSig){
    Int16 outSig;
    // determine sign of input
    sigSign = (*inSig < 0) ? -1 : 1;

    // if input > 32767, set indx to 1023 (max)
    // else divide input by 32, giving max value of 1023 when gain = 1
    distLUTindx = (*inSig >= MAXINPUT) ? (DISTLUTSIZE - 1) : abs(*inSig) >> INDXSHIFT;

    // apply asymmetrical clipping
        // use tanh for neg
        // use atan for positive
    outSig = (sigSign) ? (Int16)(sigSign*(sigLevel2*TANH[distLUTindx])):
                         (Int16)(sigSign*(sigLevel2*ATAN[distLUTindx]));

    return outSig;

}

////////////////////////////////////////////////////////////////
Int16 distModule2(Int16* inSig){
    Int16 outSig;

    // determine sign of input
    //sigSign = (*inSig < 0) ? -1 : 1;     // uncomment if distModule1 is not run before calling distModule2

    // if input > 32767, set indx to 1023 (max)
    // else divide input by 32, giving max value of 1023 when gain = 1
    distLUTindx = (*inSig >= MAXINPUT) ? (DISTLUTSIZE - 1) : abs(*inSig) >> INDXSHIFT;

    // apply symmetrical clipping
        // use atan
    outSig = (sigSign) ? (Int16)(sigSign*sigLevel*ATAN[distLUTindx]) :
                         (Int16)(sigSign*sigLevel*ATAN[distLUTindx]);

    return outSig;

}


