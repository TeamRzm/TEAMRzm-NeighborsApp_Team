//
//  MsessageEntity.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/14.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMUserEntity.h"

@interface MessageEntity : NSObject
@property (nonatomic, strong) IMUserEntity  *to;
@property (nonatomic, strong) IMUserEntity  *from;
@property (nonatomic, copy)   NSString      *content;
@end
