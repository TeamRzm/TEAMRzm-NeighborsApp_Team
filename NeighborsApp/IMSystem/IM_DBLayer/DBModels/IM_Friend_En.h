//
//  IM_Friend_En.h
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IM_Friend_En : NSObject

@property (nonatomic , assign)      NSInteger       F_Id;
@property (nonatomic , copy)        NSString        *F_Owner;
@property (nonatomic , copy)        NSString        *F_UserName;
@property (nonatomic , copy)        NSString        *F_Nikename;
@property (nonatomic , copy)        NSString        *F_Picurl;
@property (nonatomic , strong)      NSDate          *F_Both;
@property (nonatomic , copy)        NSString        *F_Sex;
@property (nonatomic , copy)        NSString        *F_Constellation;
@property (nonatomic , strong)      NSDate          *F_LastUpdateTime;
@property (nonatomic , copy)        NSString        *F_Remark;
@property (nonatomic , copy)        NSString        *F_FriendShipID;
@property (nonatomic , copy)        NSString        *F_Age;
@property (nonatomic , copy)        NSString        *F_DelFlag;

@end
