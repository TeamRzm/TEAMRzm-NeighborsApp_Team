//
//  IM_NotificationHistory_En.h
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IM_NotificationHistory_En : NSObject

@property (nonatomic , assign)      NSInteger       N_Id;
@property (nonatomic , copy)        NSString        *N_MsgID;
@property (nonatomic , copy)        NSString        *N_Title;
@property (nonatomic , copy)        NSString        *N_Owner;
@property (nonatomic , copy)        NSString        *N_From;
@property (nonatomic , copy)        NSString        *N_To;
@property (nonatomic , copy)        NSString        *N_Msg;
@property (nonatomic , copy)        NSString        *N_Status;
@property (nonatomic , copy)        NSString        *N_ReveivedEvent;
@property (nonatomic , copy)        NSString        *N_ReadedEvent;
@property (nonatomic , copy)        NSString        *N_ClickEvent;
@property (nonatomic , strong)      NSDate          *N_LastUpdateTime;
@property (nonatomic , copy)        NSString        *N_MsgCode;
@property (nonatomic , copy)        NSString        *N_MsgState;
- (id)initWithXMLstr:(NSString *)xml;
@end
