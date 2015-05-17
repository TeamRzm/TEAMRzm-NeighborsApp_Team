//
//  IM_RequestFriendHistory_En.h
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IM_RequestFriendHistory_En : NSObject

@property (nonatomic , assign)      NSInteger       R_Id;
@property (nonatomic , copy)        NSString        *R_Owner;
@property (nonatomic , copy)        NSString        *R_From;
@property (nonatomic , copy)        NSString        *R_Msg;
@property (nonatomic , copy)        NSString        *R_Status;
@property (nonatomic , strong)      NSDate          *R_LastUpdateTime;

@end
