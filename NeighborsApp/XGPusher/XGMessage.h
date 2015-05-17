//
//  XGMessage.h
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/17.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XGMessage : NSObject

//谁发来的
@property (nonatomic, copy) NSString *from;
//发给谁的
@property (nonatomic, copy) NSString *to;
//内容
@property (nonatomic, copy) NSString *content;
//推送标题
@property (nonatomic, copy) NSString *alert;
//发给哪个设备
@property (nonatomic, copy) NSString *toDeviceToken;
//从哪个设备来
@property (nonatomic, copy) NSString *fromDeviceToken;

- (NSString*) getMessgeJSONString;

- (id) initWithJSON : (NSString*) _jSonString;

@end
