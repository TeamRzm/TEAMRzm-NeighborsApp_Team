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

//发送预警消息
+ (ASIHTTPRequest*) CreateShowPostReuqetWithInfo : (NSString*) _info
                                             tag : (NSString*) _tag
                                            flag : (NSString*) _flag
                                           files : (NSArray*) files;

//获取回复列表
+ (ASIHTTPRequest*) CreateShowRepliesRequestWithID : (NSString*) ID
                                             index : (NSString*) index
                                              size : (NSString*) size;

//回复里帮信息
+ (ASIHTTPRequest*) CreateShowReplyRequestWithID : (NSString*) _ID
                                            info : (NSString*) _info
                                           files : (NSArray*) _files;

//删除
//type {0,里手帮，1:回复消息}
+ (ASIHTTPRequest*) CreateDeleteRequestWithID : (NSString*) _ID
                                         type : (NSString*) _type;

//接受回复
+ (ASIHTTPRequest*) CreateAcceptRequestWithID : (NSString*) _ID;


@end
  