/*
 * cbuf.c
 *
 *  Created on: Feb 14, 2024
 *      Author: dstnm
 */

#include "verbBuf.h"

#pragma DATA_SECTION (cbuf, "CE0");

cbuffer cbuf = {{0}, (VBUFLEN-1), 0};

volatile int verbIndx = 0;
int samplerCnt = 0;
Int16 sampleOut = 0;

int verbLength[BUFLENARRAY] = {0, VBUF1_16, VBUF2_8, VBUF5_16, VBUF3_8, VBUF7_16, VBUF4_8, VBUF9_16, VBUF5_8, VBUF11_16, VBUF6_8, VBUF13_16, VBUF7_8, VBUF15_16, VBUFLEN};


/*  loadBuf(float *data)
 *      Load data into circular buffer.
 *      Increment head and tail, overwriting
 *      oldest element when buffer is full.
 */
int loadBuf(Int16 *data){
    // load data element
    cbuf.buf[cbuf.head] = *data;
    // increment head for next load
    cbuf.head = (cbuf.head + 1) % VBUFLEN;

    cbuf.tail =  (cbuf.head + 1) % VBUFLEN;

    return 1;
}




