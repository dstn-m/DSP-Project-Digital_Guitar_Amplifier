/*
 * toneStack.h
 *
 *  Created on: Apr 3, 2024
 *      Author: dstnm 'n' lcsass
 */



#ifndef TONESTACK_H_
#define TONESTACK_H_

#include "DSP_Config.h"
#include "stdlib.h"
#include "math.h"

#define MPI 3.1415
#define MPI2 6.283
#define MPIFOURTH 0.785375
#define SHIFT9  512
#define SHIFT10 1024
#define SHIFT11 2048
#define SHIFT12 4096
#define SHIFT14 16384
#define SHIFT15 32767
#define SHIFT16 65536


extern volatile int eqB, bPrev, eqM, mPrev, eqT, tPrev;

extern float gainLUT[5];
extern float bassGain, midGain, trebGain;
extern Int16 toneStackInBuf[3];
extern Int16 maxInput;
extern Int32 filtSum;

void setEQ();
Int16 toneStack(Int16* inSig);
Int16 lowFilt(Int16* inSig);
Int16 midFilt(Int16* inSig);
Int16 highFilt(Int16* inSig);


#endif /* TONESTACK_H_ */
