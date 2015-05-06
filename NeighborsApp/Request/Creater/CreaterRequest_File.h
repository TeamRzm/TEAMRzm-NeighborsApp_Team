//
//  CreaterRequest_File.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/6.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Base.h"

@interface CreaterRequest_File : CreaterRequest_Base

//保存上传的文件信息
+ (ASIHTTPRequest*) CreateSaveFileInfoRequestWithURL : (NSString*) _url
                                                 len : (NSString*) _len
                                                mime : (NSString*) _mime
                                                type : (NSString*) _type;

@end
