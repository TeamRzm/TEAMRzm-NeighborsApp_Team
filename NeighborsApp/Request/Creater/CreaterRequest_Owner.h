//
//  CreaterRequest_Owner.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/26.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Base.h"

@interface CreaterRequest_Owner : CreaterRequest_Base

//业委会基本信息
+ (ASIHTTPRequest*) CreateInfoRequest;

//业委会成员列表
+ (ASIHTTPRequest*) CreateMemberListRequest;

//读取业委会维修基金信息
+ (ASIHTTPRequest*) CreateFundRequestWithIndex : (NSString*) _index
                                          size : (NSString*) _size
                                         start : (NSString*) _start
                                           end : (NSString*) _end;
@end
