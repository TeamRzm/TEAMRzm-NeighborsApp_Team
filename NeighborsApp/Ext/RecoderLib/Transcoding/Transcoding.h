//
//  Transcoding.h
//  amrAndWavaReader
//
//  Created by Martin.Ren on 13-3-1.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#ifndef __Transcoding_h__
#define __Transcoding_h__

#include <stdio.h>

#include "TranscodingDefine.h"

#include "interf_enc.h"

typedef long long               sBit_64;
typedef int                     sBit_32;
typedef short                   sBit_16;
typedef char                    sBit_8;

typedef unsigned long long      uBit_64;
typedef unsigned int            uBit_32;
typedef unsigned short          uBit_16;
typedef unsigned char           uBit_8;


uBit_16 ReadUBit16(char* bis);

uBit_32 ReadUBit32(char* bis);

sBit_64 ReadSBit64(char* bis);


size_t getFileSize(const char * strFileName);



//从CAF中获取所有有效的PCM数据
//读取caf文件内容传入_caf_data,执行该函数以后,_caf_data中数据将去除Caf文件头,得到真实pcm数据
int SkipPcmDataFromCAFData(char *_caf_data);

/*
//编码相关方法
 参数
    _pcm_data:          PCM数据通过从caf文件执行SkipPcmDataFromCAFData得到
    _pcm_data_size:     PCM数据大小
    _write_amr_fpath:   转换后的amr文件路径
    _channles:          转换后wav文件的声道数量 一般为 '1'
    _bits_per_sample:   转换后wav文件的采样位数 一般为 '16'
 
 返回:
    > 0 : 成功
    <＝0: 失败
*/
int EnCodePCMToAmr(char *_pcm_data, size_t _pcm_data_size, const char *_write_amr_fpath, int _channles, int _bits_per_sample);

int EnCodeWavToAmr(const char *_wav_data, char *_amr_data_buff);


//解码相关方法
int DeCodeAmrToWav(const char *_amr_data, char *_wav_data_buff);

#endif
