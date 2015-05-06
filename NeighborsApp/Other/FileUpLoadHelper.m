//
//  FileUpLoadHelper.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/6.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "FileUpLoadHelper.h"
#import "NSString+MD5.h"
#import "NSString+base64.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "CreaterRequest_File.h"

#define UPLOAD_SERVER_URLPATH   @"http://file.joolin.net/upload.cmd"

//授权服务编号
#define UPLOAD_AID              @"14562954-33f0-423c-b8c8-f0a49f764107"

//上传服务类别
#define UPLOAD_CID              @"761563f6-0a95-4d32-983e-98b59fb062eb"

//服务器授权密码
#define UPLOAD_SECURITY         @"2bk7YXvG"

@interface FileUpLoadHelper()
{
    NSMutableArray *updaloadRequests;
    NSInteger currentUploadIndex;
    
    NSMutableArray *resultDictArr;
}

@end


@implementation FileUpLoadHelper

- (id) init
{
    self = [super init];
    
    if (self)
    {
        updaloadRequests = [[NSMutableArray alloc] init];
        resultDictArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addUploadImage : (UIImage*) _image
{
    ASIFormDataRequest *subRequest = [self uploadFile:UIImageJPEGRepresentation(_image, .5f)];
    
    [updaloadRequests addObject:subRequest];
}

- (void) startUpload
{
    currentUploadIndex = -1;
    
    [self nextUploadRequest];
}

- (void) stopUpload
{
    for (ASIFormDataRequest *subRequest in updaloadRequests)
    {
        [subRequest clearDelegatesAndCancel];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(fileUpLoadHelper:downloadedFialdWithIndex:)])
        {
            [self.delegate fileUpLoadHelper:self downloadedFialdWithIndex:currentUploadIndex];
        }
    }
}

- (NSString*) getSigWithSeed : (NSTimeInterval) _time
{
    //(授权应用编号+授权配置编号+时间戳)
    NSString *wordStr = [NSString stringWithFormat:@"%@%@%.0f", UPLOAD_AID, UPLOAD_CID, _time];
    
    //MD5(授权应用编号+授权配置编号+时间戳)
    wordStr = [wordStr md5Str];
    
    //wordStr + SECURITY
    wordStr = [NSString stringWithFormat:@"%@%@", wordStr,UPLOAD_SECURITY];
    
    //MD5(wordStr + SECURITY)
    wordStr = [wordStr md5Str];
    
    return wordStr;
}

- (ASIFormDataRequest*) uploadFile : (NSData*) fileData
{
    NSDate *nowDate = [NSDate date];
    NSTimeInterval seed = [nowDate timeIntervalSince1970];
    NSString *seedString = [NSString stringWithFormat:@"%.0f", seed];
    
    NSDictionary *parmsDict = @{
                                @"aid"  : UPLOAD_AID,
                                @"cid"  : UPLOAD_CID,
                                @"sig"  : [self getSigWithSeed:seed],
                                @"seed" : seedString,
                                @"path" : @"",
                                @"data" : @"uploadImg.jpg",
                                };
    
    
    ASIFormDataRequest *dataUploadRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:UPLOAD_SERVER_URLPATH]];
    [dataUploadRequest setRequestMethod:@"POST"];
    [dataUploadRequest setPostFormat:ASIMultipartFormDataPostFormat];
    dataUploadRequest.timeOutSeconds = 25;
    
    for (NSString *subKey in parmsDict.allKeys)
    {
        [dataUploadRequest addPostValue:parmsDict[subKey] forKey:subKey];
    }

    [dataUploadRequest addData:fileData withFileName:@"uploadImg.jpg" andContentType:@"image/jpeg" forKey:@"data"];
    
    __weak ASIFormDataRequest *blockRequest = dataUploadRequest;
    __weak FileUpLoadHelper *blockSelf = self;
    
    [dataUploadRequest setCompletionBlock:^{
        
        if (!blockRequest)
        {
            return ;
        }
        
        NSDictionary *responseDict = [blockRequest.responseString JSONValue];
        
        if ( ((NSNumber*)responseDict[@"data"][@"code"][@"state"]).integerValue !=0 )
        {
            [self stopUpload];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(fileUpLoadHelper:downloadedFialdWithIndex:)])
            {
                
            }
        }
        else
        {
            NSString *sizeString = ITOS(((NSNumber*)responseDict[@"data"][@"result"][@"fileSize"]).integerValue);
            NSString *typeString = ITOS(((NSNumber*)responseDict[@"data"][@"result"][@"type"]).integerValue);
            
            __weak ASIHTTPRequest *saveInfoRequest = [CreaterRequest_File CreateSaveFileInfoRequestWithURL:responseDict[@"data"][@"result"][@"url"]
                                                                                                len:sizeString
                                                                                               mime:responseDict[@"data"][@"result"][@"mimeType"]
                                                                                               type:typeString];
            
            [saveInfoRequest setCompletionBlock:^{
                
                NSDictionary *saveInfoRequestResponseDict = [saveInfoRequest.responseString JSONValue];
                
                if ( ((NSNumber*)saveInfoRequestResponseDict[@"data"][@"code"][@"state"]).integerValue !=0 )
                {
                    [self stopUpload];
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(fileUpLoadHelper:downloadedFialdWithIndex:)])
                    {
                        [self.delegate fileUpLoadHelper:self downloadedFialdWithIndex:currentUploadIndex];
                    }
                    
                    return ;
                }
                
                [resultDictArr addObject:@{
                                           @"url"       : saveInfoRequestResponseDict[@"data"][@"result"][@"url"],
                                           @"fileId"    : saveInfoRequestResponseDict[@"data"][@"result"][@"fileId"]
                                           }];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(fileUpLoadHelper:downloadedIndex:downloadTotal:)])
                {
                    [self.delegate fileUpLoadHelper:self downloadedIndex:currentUploadIndex downloadTotal:updaloadRequests.count];
                }
                
                [self nextUploadRequest];
            }];
            
            [saveInfoRequest setFailedBlock:^{
                [self stopUpload];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(fileUpLoadHelper:downloadedFialdWithIndex:)])
                {
                    [self.delegate fileUpLoadHelper:self downloadedFialdWithIndex:currentUploadIndex];
                }
            }];
            
            [saveInfoRequest startAsynchronous];
        }
    }];
    
    [dataUploadRequest setFailedBlock:^{
        [self stopUpload];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(fileUpLoadHelper:downloadedFialdWithIndex:)])
        {
            [self.delegate fileUpLoadHelper:self downloadedFialdWithIndex:currentUploadIndex];
        }
    }];
    
    return dataUploadRequest;
}

- (void) nextUploadRequest
{
    currentUploadIndex ++;
    
    if (currentUploadIndex >= updaloadRequests.count)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(fileUpLoadHelper:allDownloadedResponseDictArr:)])
        {
            [self.delegate fileUpLoadHelper:self allDownloadedResponseDictArr:resultDictArr];
        }
        return ;
    }
    
    ASIFormDataRequest *nextRequest = updaloadRequests[currentUploadIndex];
    
    [nextRequest startAsynchronous];
}

@end
