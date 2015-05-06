//
//  CreaterRequest_Conv.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/7.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Base.h"

@interface CreaterRequest_Conv : CreaterRequest_Base

//根据登陆的小区获取便民信息，并按照距离从近到远拍训
+ (ASIHTTPRequest*) CreateListRequestWithIndex : (NSString*) index
                                          size : (NSString*) size
                                           lat : (NSString*) lat
                                           lng : (NSString*) lng;

@end
