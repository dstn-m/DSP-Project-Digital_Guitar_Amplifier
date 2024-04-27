/*
 * inputbpf.c
 *
 *  Created on: Apr 12, 2024
 *      Author: dstnm
 */

#include <inputBPF.h>

/* 2ND ORDER CASCADED BUTTERWORTH FILTERS
 */

float bpfb[4] = {0.996738, -0.996738, 0.211325, 0.211325}, bpfa[4] = {1.000000, -0.993476, 1.000000, -0.577350};
Int16 bpfInPrev[3] = {0}, bpfOutPrev[3] = {0}, bpfOutPrev2[3] = {0};

Int16 inputBPF(Int16 *in){

    bpfInPrev[0] = *in;
    // apply HPF
     bpfOutPrev[0] = round(bpfInPrev[0]*bpfb[0] + bpfInPrev[1]*bpfb[1]
                   - (bpfOutPrev[1]*bpfa[1]));


     // apply LPF
     bpfOutPrev2[0] = round(bpfOutPrev[0]*bpfb[2] + bpfOutPrev[1]*bpfb[3]
                    - (bpfOutPrev2[1]*bpfa[3]));

     // shift inputs/outputs
    // bpfInPrev[2] = bpfInPrev[1];
     bpfInPrev[1] = bpfInPrev[0];

    // bpfOutPrev[2] = bpfOutPrev[1];
     bpfOutPrev[1] = bpfOutPrev[0];

    // bpfOutPrev2[2] = bpfOutPrev2[1];
     bpfOutPrev2[1] = bpfOutPrev2[0];

    return bpfOutPrev2[0];
}


