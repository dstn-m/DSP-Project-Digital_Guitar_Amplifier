/*
 * toneStack.c
 *
 *  Created on: Apr 3, 2024
 *      Author: dstnm 'n' lcsass
 */

#include "toneStack.h"


#define EQMAX 10
#define EQLEN 5

volatile int  eqB = 5, bPrev = 5, eqM = 5, mPrev = 5, eqT = 5, tPrev = 5;

float gainLUT[5] = {0.04, 0.16, 0.36, .64, 1};

float bassGain = 1, midGain = 1, trebGain = 1;

// 75 - 150
float blowEQ[EQLEN] = {0.997552, -0.997552, 0.004885, 0.004885}, alowEQ[EQLEN] = {1.000000, -0.995103, 1.000000, -0.990230};

// 350 - 1000
float bmidEQ[EQLEN] = {0.988675, -0.988675, 0.031699, 0.031699}, amidEQ[EQLEN] = {1.000000, -0.977351, 1.000000, -0.936602};

// 2000 - 10000
float bhiEQ[EQLEN] = {0.938488, -0.938488, 0.253427, 0.253427}, ahiEQ[EQLEN] = {1.000000, -0.876976, 1.000000, -0.493145};

// filter buffers
Int16 toneStackInBuf[3] = {0},
      lowBuf[3] = {0}, lowOut[3] = {0}, lowOut2[3] = {0},
      midBuf[3] = {0}, midOut[3] = {0}, midOut2[3] = {0},
      hiBuf[3]  = {0}, hiOut[3]  = {0}, hiOut2[3]  = {0};

//Int32 filtSumL = 0, filtSumM = 0, filtSumT = 0;
Int16 maxInput = 0;

Int16 lowFilt(Int16* inSig){
    lowBuf[0] = *inSig;

    // apply HPF
    lowOut[0] = round(toneStackInBuf[0]*blowEQ[0] + toneStackInBuf[1]*blowEQ[1]
                  - (lowOut[1]*alowEQ[1]));


    // apply LPF
    lowOut2[0] = round(lowOut[0]*blowEQ[2] + lowOut[1]*blowEQ[3]
                   - (lowOut2[1]*alowEQ[3]));

    // shift inputs/outputs

    lowOut[1] = lowOut[0];

    lowOut2[1] = lowOut2[0];


       return lowOut2[0];

}

Int16 midFilt(Int16* inSig){
    midBuf[0] = *inSig;

    // apply HPF
    midOut[0] = round(toneStackInBuf[0]*bmidEQ[0] + toneStackInBuf[1]*bmidEQ[1]
                   - (midOut[1]*amidEQ[1]));


    // apply LPF
    midOut2[0] = round(midOut[0]*bmidEQ[2] + midOut[1]*bmidEQ[3]
                   - (midOut2[1]*amidEQ[3]));

    // shift inputs/outputs

    midOut[1] = midOut[0];

    midOut2[1] = midOut2[0];

       return midOut2[0];

}


Int16 highFilt(Int16* inSig){
    hiBuf[0] = *inSig;

    // apply HPF
    hiOut[0] = round(toneStackInBuf[0]*bhiEQ[0] + toneStackInBuf[1]*bhiEQ[1]
                  - (hiOut[1]*ahiEQ[1]));


    // apply LPF
    hiOut2[0] = round(hiOut[0]*bhiEQ[2] + hiOut[1]*bhiEQ[3]
                   - (hiOut2[1]*ahiEQ[3]));

    // shift inputs/outputs

    hiOut[1] = hiOut[0];

    hiOut2[1] = hiOut2[0];

    return hiOut2[0];

}

// update the EQ gain settings
void setEQ(){
    //float tmpA, tmpB;
    bassGain = gainLUT[eqB - 1];
    midGain  = gainLUT[eqM - 1];
    trebGain = gainLUT[eqT - 1];

}

