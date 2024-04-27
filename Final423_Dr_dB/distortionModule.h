/*
 * distortionModule.h
 *
 *  Created on: Apr 10, 2024
 *      Author: dstnm
 */

#ifndef DISTORTIONMODULE_H_
#define DISTORTIONMODULE_H_

#include "DSP_Config.h"
#include "math.h"

#define INDXSHIFT 5 // divide by 32
#define MAXINPUT 32767

extern volatile int preampGain;
extern int distLUTindx, sigLevel, sigSign;
extern Int16 distLow, distMid, distTreb;


Int16 distModule1(int* inSig);
Int16 distModule2(Int16* inSig);


#endif /* DISTORTIONMODULE_H_ */
