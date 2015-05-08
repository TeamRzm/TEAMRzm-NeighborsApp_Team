//
//  CreaterRequest_Village.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/7.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Base.h"

@interface CreaterRequest_Village : CreaterRequest_Base

//获取附近小区列表
+ (ASIHTTPRequest*) CreateNearRequestWithLat : (NSString*) lat
                                         lng : (NSString*) lng
                                        size : (NSString*) size;

//关键字查询小区
+ (ASIHTTPRequest*) CreateListRequestWithSearchID : (NSString*) searchID
                                              key : (NSString*) key
                                             size : (NSString*) size;


//按照区域查询小区
+ (ASIHTTPRequest*) CreateListRequestWithID : (NSString*) ID
                                       code : (NSString*) code;

//入住某小区
+ (ASIHTTPRequest*) CreateApplyRequestWithID : (NSString*) ID
                                        data : (NSString*) data
                                       phone : (NSString*) phone
                                     contact : (NSString*) contact
                                   ownerName : (NSString*) ownerName
                                   ownerType : (NSString*) ownerType
                                       house : (NSString*) house;

//我入住的小区
+ (ASIHTTPRequest*) CreateListAppLinesRequest;

//删除我入住的某个小区
+ (ASIHTTPRequest*) CreateDeleteAppLinesRequestWithID : (NSString*) ID;

//切换当前xiaoqu
+ (ASIHTTPRequest*) CreateExchangeRequestWithID : (NSString*) ID;



@end
