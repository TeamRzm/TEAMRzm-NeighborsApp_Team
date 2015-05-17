//
//  IM_MsgHistory_En.h
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IM_MsgHistory_En : NSObject

@property (nonatomic , assign)      NSInteger       Id;
@property (nonatomic , copy)        NSString        *from;
@property (nonatomic , copy)        NSString        *to;
@property (nonatomic , copy)        NSString        *content;
@property (nonatomic , copy)        NSString        *alert;
@property (nonatomic , copy)        NSString        *fromDeviceToken;
@property (nonatomic , copy)        NSString        *toDeviceToken;
@property (nonatomic , copy)        NSString        *time;


-(id)initWithXmlStr:(NSString *)xmldoc;


@end
