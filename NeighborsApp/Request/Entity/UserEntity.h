//
//  UserEntity.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/3.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "AbsEntity.h"

@interface UserEntity : AbsEntity

@property (nonatomic, strong) NSString* nickName;
@property (nonatomic, strong) NSString* villageId;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* villageName;
@property (nonatomic, strong) NSString* token;

@end
