/*
 * cbuf.h
 *
 *  Created on: Feb 14, 2024
 *      Author: nikol
 */
#include "DSP_Config.h"

#ifndef VERBBUF_H_
#define VERBBUF_H_

#define VBUFLEN      16384
#define VBUF15_16    (VBUFLEN * 15)/16
#define VBUF7_8      (VBUFLEN * 7) /8
#define VBUF13_16    (VBUFLEN * 13)/16
#define VBUF6_8      (VBUFLEN * 3)/4
#define VBUF11_16    (VBUFLEN * 11)/16
#define VBUF5_8      (VBUFLEN * 5)/8
#define VBUF9_16     (VBUFLEN * 9)/16
#define VBUF4_8      VBUFLEN / 2
#define VBUF7_16     (VBUFLEN * 7)/16
#define VBUF3_8      (VBUFLEN * 3)/8
#define VBUF5_16     (VBUFLEN * 5)/16
#define VBUF2_8      (VBUFLEN)/4
#define VBUF1_16     (VBUFLEN)/16


#define SAMPLEOFFSET 6

#define BUFLENARRAY 16

extern volatile int verbIndx;

typedef struct{
    Int16   buf[VBUFLEN];
    uint16_t head;
    uint16_t tail;
} cbuffer;

extern int verbLength[BUFLENARRAY];

extern int samplerCnt;
extern Int16 sampleOut;

// function
int loadBuf(Int16 *data);

#endif /* VERBBUF_H_ */
