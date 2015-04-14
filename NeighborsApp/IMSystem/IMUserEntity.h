//
//  IMUserEntity.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/14.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMUserEntity : NSObject
//头像
@property (nonatomic, copy) NSString *avterUrl;
//昵称
@property (nonatomic, copy) NSString *nickName;
//用户标示
@property (nonatomic, copy) NSString *customID;
@end
