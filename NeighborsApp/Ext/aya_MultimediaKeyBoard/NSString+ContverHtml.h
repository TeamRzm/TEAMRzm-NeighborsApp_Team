//
//  NSString+ContverHtml.h
//  BBG
//
//  Created by Martin.Ren on 13-4-12.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@interface NSString (ContverHtml)

- (NSString*) markupStringToHtml;
- (NSDictionary*) jasonStrToDict;

//Chat显示字符串转成传输字符串
- (NSString*) displayStrToTranStr;

//Chat传输字符串转成显示字符串
- (NSString*) tranStrToDisplayStr;
@end
