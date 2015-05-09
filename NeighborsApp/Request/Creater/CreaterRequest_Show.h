//
//  CreaterRequest_Show.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/8.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Base.h"

@interface CreaterRequest_Show : CreaterRequest_Base


//type(0：亲邻圈，1：预警信息)
+ (ASIHTTPRequest*) CreateShowListRequestWithIndex : (NSString*) _index
                                              size : (NSString*) _size
                                              type : (NSString*) _type;

+ (ASIHTTPRequest*) CreateShowPostReuqetWithInfo : (NSString*) _info
                                             tag : (NSString*) _tag
                                            flag : (NSString*) _flag
                                           files : (NSArray*) files;

@end
