//
//  UserEntity.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/3.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "AbsEntity.h"

@interface UserEntity : AbsEntity

@property (nonatomic, copy)     NSString* nickName;
@property (nonatomic, copy)     NSString* userId;
@property (nonatomic, copy)     NSString* userName;
@property (nonatomic, copy)     NSString* token;
@property (nonatomic, copy)     NSString* avatar;
@property (nonatomic, strong)   NSDictionary *region;

@end
