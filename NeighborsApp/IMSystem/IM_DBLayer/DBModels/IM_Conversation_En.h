//
//  IM_Conversation_En.h
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IM_Conversation_En : NSObject

@property (nonatomic , assign)      NSInteger       C_Id;
@property (nonatomic , copy)        NSString        *C_UserName;
@property (nonatomic , copy)        NSString        *C_To;
@property (nonatomic , assign)      NSInteger       C_UnReadMsgCount;
@property (nonatomic , assign)      NSInteger       C_LastMsgId;
@property (nonatomic , strong)      NSDate          *C_LastUpdateTime;

@end
