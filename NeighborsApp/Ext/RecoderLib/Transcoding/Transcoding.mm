//
//  File.c
//  amrAndWavaReader
//
//  Created by Martin.Ren on 13-3-1.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#include "Transcoding.h"
#include <string.h>

//从CAF中获取所有有效的PCM数据
int SkipPcmDataFromCAFData(char *_caf_data)
{
    if (!_caf_data)
    {
        return -1;
    }
    
    char *copy_caf_data_old = _caf_data;
    
    uBit_32 mFileType = ReadUBit32(copy_caf_data_old);
    
    if (0x63616666 != mFileType)
    {
        printf("GetPcmDataFromCAFData:This file data buff is't caf file!\n");
        return -1;
    }
    
    _caf_data += 4;
    
    //Bit_16 mFileVersion = ReadBit16(_caf_data);
    _caf_data += 2;
    
    //Bit_16 mFileFlags = ReadBit16(_caf_data);
    _caf_data += 2;

    //desc free data
    uBit_32 magics[3] = {0x64657363, 0x66726565, 0x64617461};
    
    for (int i = 0; i < 3; ++i)
    {
        
        uBit_32 mChunkType = ReadUBit32(_caf_data);
        _caf_data += 4;
        
        if (magics[i] != mChunkType)
        {
            printf("GetPcmDataFromCAFData:Read ChunkType faild!\n");
            return  -1;
        }
        
        uBit_32 mChunkSize = ReadSBit64(_caf_data);
        _caf_data += 8;
        
        if (mChunkSize <= 0)
        {
            printf("GetPcmDataFromCAFData:Read ChunkSize faild!\n");
            return -1;
        }
        
        if (i == 2)
        {
            return _caf_data - copy_caf_data_old;
        }
        
        _caf_data += mChunkSize;
        
    }
    
    return -1;
}


//编码相关方法
#define PCM_FRAME_SIZE 160 

int ReadPCMFrameData(short speech[], char* fpwave, int nChannels, int nBitsPerSample)
{
	int nRead = 0;
	int x = 0, y=0;
	
	// 原始PCM音频帧数据
	unsigned char  pcmFrame_8b1[PCM_FRAME_SIZE];
	unsigned char  pcmFrame_8b2[PCM_FRAME_SIZE<<1];
	unsigned short pcmFrame_16b1[PCM_FRAME_SIZE];
	unsigned short pcmFrame_16b2[PCM_FRAME_SIZE<<1];
	
    nRead = (nBitsPerSample/8) * PCM_FRAME_SIZE*nChannels;
	if (nBitsPerSample==8 && nChannels==1)
    {
		//nRead = fread(pcmFrame_8b1, (nBitsPerSample/8), PCM_FRAME_SIZE*nChannels, fpwave);
        memcpy(pcmFrame_8b1,fpwave,nRead);
		for(x=0; x<PCM_FRAME_SIZE; x++)
        {
			speech[x] =(short)((short)pcmFrame_8b1[x] << 7);
        }
    }
	else
		if (nBitsPerSample==8 && nChannels==2)
        {
			//nRead = fread(pcmFrame_8b2, (nBitsPerSample/8), PCM_FRAME_SIZE*nChannels, fpwave);
            memcpy(pcmFrame_8b2,fpwave,nRead);
            
			for( x=0, y=0; y<PCM_FRAME_SIZE; y++,x+=2 )
            {
				// 1 - 取两个声道之左声道
				speech[y] =(short)((short)pcmFrame_8b2[x+0] << 7);
				// 2 - 取两个声道之右声道
				//speech[y] =(short)((short)pcmFrame_8b2[x+1] << 7);
				// 3 - 取两个声道的平均值
				//ush1 = (short)pcmFrame_8b2[x+0];
				//ush2 = (short)pcmFrame_8b2[x+1];
				//ush = (ush1 + ush2) >> 1;
				//speech[y] = (short)((short)ush << 7);
            }
        }
		else
			if (nBitsPerSample==16 && nChannels==1)
            {
				//nRead = fread(pcmFrame_16b1, (nBitsPerSample/8), PCM_FRAME_SIZE*nChannels, fpwave);
                memcpy(pcmFrame_16b1,fpwave,nRead);
                
				for(x=0; x<PCM_FRAME_SIZE; x++)
                {
					speech[x] = (short)pcmFrame_16b1[x+0];
                }
            }
			else
				if (nBitsPerSample==16 && nChannels==2)
                {
					//nRead = fread(pcmFrame_16b2, (nBitsPerSample/8), PCM_FRAME_SIZE*nChannels, fpwave);
                    memcpy(pcmFrame_16b2,fpwave,nRead);
                    
					for( x=0, y=0; y<PCM_FRAME_SIZE; y++,x+=2 )
                    {
						//speech[y] = (short)pcmFrame_16b2[x+0];
						speech[y] = (short)((int)((int)pcmFrame_16b2[x+0] + (int)pcmFrame_16b2[x+1])) >> 1;
                    }
                }
	
	// 如果读到的数据不是一个完整的PCM帧, 就返回0
	return nRead;
}

int EnCodePCMToAmr(char *_pcm_data, size_t _pcm_data_size, const char *_write_amr_fpath, int _channles, int _bits_per_sample)
{
    size_t maxLen = _pcm_data_size;
    
    char* oldBuf = _pcm_data;
    /* input speech vector */
    
	short speech[160];
	
	/* counters */
	int byte_counter, frames = 0, bytes = 0;
	
	/* pointer to encoder state structure */
	void *enstate;
	
	/* requested mode */
	enum Mode req_mode = MR122;
	int dtx = 0;
	
	/* bitstream filetype */
	unsigned char amrFrame[32];
    
    //开始写文件
    FILE *amr_out_file = fopen(_write_amr_fpath, "wb");
    
    if (amr_out_file == NULL)
    {
        printf("EnCodePCMToAmr:Can't open or create the output file!\n");
        return -1;
    }
    
    //写amr文件头
    fwrite("#!AMR\n", strlen("#!AMR\n"), 1, amr_out_file);
	
	enstate = Encoder_Interface_init(dtx);
	
	while(1)
    {
		// read one pcm frame
        if ((_pcm_data - oldBuf + 320) > maxLen)
        {
            break;
        }
        
		int nRead = ReadPCMFrameData(speech, _pcm_data, _channles, _bits_per_sample);
        
        _pcm_data += nRead;
        
		
		frames++;
		
		byte_counter = Encoder_Interface_Encode(enstate, req_mode, speech, amrFrame, 0);
		
		bytes += byte_counter;
        
		fwrite(amrFrame, sizeof (unsigned char), byte_counter, amr_out_file);
    }
	
    fclose(amr_out_file);
    
	Encoder_Interface_exit(enstate);
    
	return 1;
}

int EnCodeWavToAmr(const char *_wav_data, char *_amr_data_buff)
{
    return 0;
}


//解码相关方法
int DeCodeAmrToWav(const char *_amr_data, char *_wav_data_buff)
{
    return 0;
}


uBit_16 ReadUBit16(char* bis)
{
    uBit_16 result = 0;
    result += ((uBit_16)(bis[0])) << 8;
    result += (uBit_8)(bis[1]);
    return result;
}

uBit_32 ReadUBit32(char* bis)
{
    uBit_32 result = 0;
    result += ((uBit_32) ReadUBit16(bis)) << 16;
    bis+=2;
    result += ReadUBit16(bis);
    return result;
}

sBit_64 ReadSBit64(char* bis)
{
    sBit_64 result = 0;
    result += ((sBit_64) ReadUBit32(bis)) << 32;
    bis+=4;
    result += ReadUBit32(bis);
    return result;
}

size_t getFileSize(const char * strFileName)
{
    FILE * fp = fopen(strFileName, "r");
    fseek(fp, 0L, SEEK_END);
    size_t size = ftell(fp);
    fclose(fp);
    return size;
}