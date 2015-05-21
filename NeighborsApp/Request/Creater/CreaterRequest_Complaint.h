//
//  CreaterRequest_ComplaintViewController.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/20.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CreaterRequest_Base.h"

@interface CreaterRequest_Complaint : CreaterRequest_Base

//发布投诉或者报修
//type(0：投诉，1：报修)
+ (ASIHTTPRequest*) CreateComplaintPostRequestWithContact : (NSString *) _contact
                                                    phone : (NSString *) _phone
                                                  address : (NSString *) _address
                                                  content : (NSString *) _content
                                                    files : (NSArray  *) _files
                                                     type : (NSString *) _type;

//投诉或报修列表
//type{0:投诉 1:报修}
//flag{0:大家发的 1:我发的}
+ (ASIHTTPRequest*) CreateComplaintListRequestWithType : (NSString *) _type
                                                  flag : (NSString *) _flag
                                                 index : (NSString *) _index
                                                  size : (NSString *) _size;


@end
