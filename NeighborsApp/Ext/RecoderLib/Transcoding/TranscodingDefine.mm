//
//  TranscodingDefine.c
//  amrAndWavaReader
//
//  Created by Martin.Ren on 13-3-1.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#include "Transcoding.h"

int TranscodingCafToAmr(const char *inCafFilePath, const char *outAmrFilePath)
{
    const char *inputFile = inCafFilePath;
    const char *outPutFile = outAmrFilePath;
    
    //读取caf文件到内存
    size_t cafSize = getFileSize(inputFile);
    
    char *cafFileBuff = (char*)malloc(sizeof(char) * (cafSize + 1));
    cafFileBuff[cafSize] = '\0';
    FILE *inFile = fopen(inputFile, "rb");
    
    int i = 0;
    
    while (!feof(inFile))
    {
        cafFileBuff[i] = fgetc(inFile);
        i++;
    }
    
    //去掉caf文件头
    int nPos  = 0;
    char* buf = cafFileBuff;
    int maxLen = cafSize;
    
    
    nPos += SkipPcmDataFromCAFData(buf);
    if (nPos >= maxLen)
    {
        return -1;
    }
    
    //这时取出来的是纯pcm数据
    buf += nPos;
    
    //encode
    EnCodePCMToAmr(buf, maxLen - nPos, outPutFile, 1, 16);
    
    fclose(inFile);
    
    free(cafFileBuff);
    
    cafFileBuff = NULL;
    buf = NULL;
    
    return 1;
    
}

/* From WmfDecBytesPerFrame in dec_input_format_tab.cpp */
const int sizes[] = { 12, 13, 15, 17, 19, 20, 26, 31, 5, 6, 5, 5, 0, 0, 0, 0 };


int TranscodingAmrToWav(const char *inAmrFilePath, const char *outWavFilePath)
{
	FILE* inFile;
	char header[6];
	int n;
	void *wav, *amr;
    
	inFile = fopen(inAmrFilePath, "rb");
    
	if (!inFile)
    {
		printf("TranscodingAmrToCaf:Can't open or create %s\n", inAmrFilePath);
		return -1;
	}
    
	n = fread(header, 1, 6, inFile);
    
	if (n != 6 || memcmp(header, "#!AMR\n", 6))
    {
		printf("TranscodingAmrToCaf:Bad header\n");
		return -1;
	}
    
	wav = wav_write_open(outWavFilePath, 8000, 16, 1);
	
    if (!wav)
    {
		printf("TranscodingAmrToCaf:Can't open or create %s\n", outWavFilePath);
		return -1;
	}
    
	amr = Decoder_Interface_init();
	while (1)
    {
		uint8_t buffer[500], littleendian[320], *ptr;
		int size, i;
		int16_t outbuffer[160];
		/* Read the mode byte */
		n = fread(buffer, 1, 1, inFile);
		if (n <= 0)
			break;
		/* Find the packet size */
		size = sizes[(buffer[0] >> 3) & 0x0f];
		n = fread(buffer + 1, 1, size, inFile);
		if (n != size)
			break;
        
		/* Decode the packet */
		Decoder_Interface_Decode(amr, buffer, outbuffer, 0);
        
		/* Convert to little endian and write to wav */
		ptr = littleendian;
		for (i = 0; i < 160; i++) {
			*ptr++ = (outbuffer[i] >> 0) & 0xff;
			*ptr++ = (outbuffer[i] >> 8) & 0xff;
		}
		wav_write_data(wav, littleendian, 320);
	}
	fclose(inFile);
	Decoder_Interface_exit(amr);
	wav_write_close(wav);
	return 0;
}
