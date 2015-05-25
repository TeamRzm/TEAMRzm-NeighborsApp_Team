//
//  CreaterRequest_Residence.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/25.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Base.h"

@interface CreaterRequest_Residence : CreaterRequest_Base


//flag:{0:小区动态,1:小区推荐动态（banner）,2:业委会公告，3:业委会会议记录}
+ (ASIHTTPRequest*) CreateResidenceNewsRequestWithFlag : (NSString*) _flag
                                                  size : (NSString*) _size
                                                 index : (NSString*) _index;

@end
