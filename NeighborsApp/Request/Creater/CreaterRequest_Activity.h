//
//  CreaterRequest_Activity.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/7.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Base.h"

@interface CreaterRequest_Activity : CreaterRequest_Base

//flag : {0:大家发起的,1:我发起的,2:我参与的}
+ (ASIHTTPRequest*) CreateActivityRequestWithIndex : (NSString*) _index
                                              size : (NSString*) _size
                                              flag : (NSString*) _flag;

//获取某活动的报名人员信息表
+ (ASIHTTPRequest*) CreateJoinsRequestWithID : (NSString*) ID
                                       index : (NSString*) index
                                        size : (NSString*) size;

//报名参加某活动
+ (ASIHTTPRequest*) CreateJoinRequestWithID : (NSString*) ID
                                      phone : (NSString*) phone
                                   contrace : (NSString*) contract
                                      count : (NSString*) count;

@end
