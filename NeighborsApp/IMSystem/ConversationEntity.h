//
//  ConversationEntity.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/14.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageEntity.h"


@interface ConversationEntity : NSObject
//会话当前收到的最后一个消息
@property (nonatomic, strong) MessageEntity *lastMessage;
@end
