//
//  CreaterRequest_Logroll.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/5.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Base.h"

@interface CreaterRequest_Logroll : CreaterRequest_Base

//accepted : {-1:所有，0:未解决，1:已解决}
//flag : {0:大家发起的,1:我发起的}
+ (ASIHTTPRequest*) CreateLogrollRequestWithIndex : (NSString*) _index
                                             size : (NSString*) _size
                                         accepted : (NSString*) _accepted
                                             isMy : (NSString*) _flag;

+ (ASIHTTPRequest*) CreateLogrollCommitRequestWithTitle : (NSString*) _title
                                                   info : (NSString*) _info
                                                  files : (NSArray*)  _files
                                                    tag : (NSString*) _tag;

@end
