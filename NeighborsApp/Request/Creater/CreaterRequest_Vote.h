//
//  CreaterRequest_Vote.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/6/4.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Base.h"

@interface CreaterRequest_Vote : CreaterRequest_Base

//flag : {0:居民发起,1:物业发起,2:业委会发起}
+ (ASIHTTPRequest*) CreateVoteListRequestWithIndex : (NSString*) _index
                                              size : (NSString*) _size
                                              flag : (NSString*) _flag;


//flag : {0:支持，1反对}
+ (ASIHTTPRequest*)CreateVoteAddRequestWithID : (NSString*) _ID
                                         flag : (NSString*) _flag;

@end
