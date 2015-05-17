//
//  IM_MsgHistory_En.m
//  BBG
//
//  Created by 7mallsevenk on 13-7-9.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "IM_MsgHistory_En.h"
//#import "DDXMLDocument.h"
#import "AppSessionMrg.h"

@implementation IM_MsgHistory_En

@synthesize Id;
@synthesize from;
@synthesize to;
@synthesize alert;
@synthesize fromDeviceToken;
@synthesize toDeviceToken;
@synthesize time;

- (id)initWithXmlStr:(NSString *)xmldoc
{
    self    =   [super init];
    if(self)
    {
//        NSError* error = nil;
//        DDXMLDocument* xmlDoc = [[DDXMLDocument alloc] initWithXMLString:xmldoc options:0 error:&error];
//        
//        if (error)
//        {
//            //非合法的xml
//            NSLog(@"%@",[error localizedDescription]);
//            return nil ;
//        }
//        
//        if (error)
//        {
//            //读取节点错误
//            NSLog(@"%@",[error localizedDescription]);
//            return nil;
//        }
//        DDXMLNode *child_node    = [[xmlDoc nodesForXPath:@"//ZSMsg"    error:nil] lastObject];
//        self.M_From           =   [[[child_node nodesForXPath:@"From"     error:nil] objectAtIndex:0] stringValue];
//        self.M_MsgCode        =  [[[child_node nodesForXPath:@"MsgCode" error:nil] lastObject] stringValue];
//        self.M_Msg            =   [[[child_node nodesForXPath:@"Body" error:nil] lastObject] stringValue];
//        self.M_LastUpdateTime =   [self getTimeDateFromString:[[[child_node nodesForXPath:@"Time"     error:nil] objectAtIndex:0] stringValue]];
////        self.M_MsgType        =   [[[child_node nodesForXPath:@"From"     error:nil] objectAtIndex:0] stringValue];
//        self.M_Owner          =   [[[SessionMgr Instance]getSessionValueWithKey:SYSKEY_USERINFO] u_userNumber];
//        self.M_Status         =   @"Received";
//        self.M_MsgState       =   @"Received";
//        self.M_To             =   [[[SessionMgr Instance]getSessionValueWithKey:SYSKEY_USERINFO] u_userNumber];
//        self.M_ClickEvent     =    [[[child_node nodesForXPath:@"ClickEvent" error:nil] objectAtIndex:0] stringValue];
//        self.M_ReadedEvent    =    [[[child_node nodesForXPath:@"ReadEvent" error:nil] objectAtIndex:0] stringValue];
//        self.M_ReveivedEvent  =    [[[child_node nodesForXPath:@"ReveivedEvent" error:nil] objectAtIndex:0] stringValue];
    }
    return self;
}

-(NSDate *)getTimeDateFromString:(NSString *)timestr
{
    NSDateFormatter *formatter= [[NSDateFormatter alloc]init];

    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  
    return [formatter dateFromString:timestr];
}
@end
