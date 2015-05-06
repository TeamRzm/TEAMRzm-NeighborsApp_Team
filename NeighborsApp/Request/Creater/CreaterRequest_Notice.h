//
//  CreaterRequest_Notice.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/7.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Base.h"

@interface CreaterRequest_Notice : CreaterRequest_Base

//获得我收到的消息列表 flag : {0:社区通知，1:好友申请通知}
+ (ASIHTTPRequest*) CreateListRequestWithIndex : (NSString*) index
                                          size : (NSString*) size
                                          flag : (NSString*) flag;

//标记已读消息
+ (ASIHTTPRequest*) CreateMarkRequestWithID : (NSString*) ID;

@end
