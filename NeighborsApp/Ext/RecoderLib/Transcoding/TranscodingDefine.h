//
//  TranscodingDefine.h
//  amrAndWavaReader
//
//  Created by Martin.Ren on 13-3-1.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#ifndef __TranscodingDefine_h__
#define __TranscodingDefine_h__

#include <stdio.h>
#include <stdint.h>
#include "Transcoding.h"
#include "wavwriter.h"
#include "interf_dec.h"

//对文件操作
int TranscodingCafToAmr(const char *inCafFilePath, const char *outAmrFilePath);
int TranscodingAmrToWav(const char *inAmrFilePath, const char *outWavFilePath);

#endif
