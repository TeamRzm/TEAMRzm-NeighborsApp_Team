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

@property (nonatomic , assign)      NSInteger       M_Id;
@property (nonatomic , copy)        NSString        *M_Owner;
@property (nonatomic , copy)        NSString        *M_From;
@property (nonatomic , copy)        NSString        *M_To;
@property (nonatomic , copy)        NSString        *M_Msg;
@property (nonatomic , copy)        NSString        *M_Status;
@property (nonatomic , copy)        NSString        *M_ReveivedEvent;
@property (nonatomic , copy)        NSString        *M_ReadedEvent;
@property (nonatomic , copy)        NSString        *M_ClickEvent;
@property (nonatomic , strong)      NSDate          *M_LastUpdateTime;
@property (nonatomic , copy)        NSString        *M_MsgCode;
@property (nonatomic , copy)        NSString        *M_MsgState;

@end
