//
//  NSString+ContverHtml.m
//  BBG
//
//  Created by Martin.Ren on 13-4-12.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "NSString+ContverHtml.h"
#import "FaceImgCode.h"
#import "SBJson.h"

@implementation NSString (ContverHtml)

//Chat显示字符串转成传输字符串
- (NSString*) displayStrToTranStr
{
//[BISHI]
    
    NSError *error;
    //
    NSString *ChatStr = self;
    NSString *NewRegxStr=ChatStr;
    NSString *regexStr  =  @"[\\[]{1}[^\\[\\]]*?\[\\]]{1}";
    NSRegularExpression *regexExpression = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
    if (regexExpression != nil)
    {
        NSDictionary *FaceDict;
        if (nil == FaceDict)
        {
            NSBundle            *bundle = [NSBundle mainBundle];
            NSString            *path = [bundle pathForResource:@"face" ofType:@"xml"];
            FaceDict = [[NSDictionary alloc] initWithContentsOfFile:path];
        }
        NSTextCheckingResult *Result   =[regexExpression firstMatchInString:NewRegxStr options:NSMatchingReportProgress range:NSMakeRange(0, NewRegxStr.length)];
        while(Result)
        {
            NSString *str           =   [NewRegxStr substringWithRange:Result.range];
            NSString *oringinStr    =   str;
            oringinStr              =   [oringinStr stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"[em]"];
            oringinStr              =   [oringinStr stringByReplacingCharactersInRange:NSMakeRange(oringinStr.length-1, 1) withString:@"[/em]"];
            NSArray *keys=[FaceDict allKeys];
            for(id key in keys)
            {
                if([oringinStr isEqualToString:(NSString *)key])
                {
                  //  NSString    *replaceStr=str;3
                  //  replaceStr  =   [[replaceStr stringByReplacingOccurrencesOfString:@"[" withString:@"[em]"] stringByReplacingOccurrencesOfString:@"]" withString:@"[/em]"];
                    ChatStr     =   [ChatStr stringByReplacingOccurrencesOfString:str withString:oringinStr];
                    break;
                }
            }            
            NewRegxStr      =   [NewRegxStr substringFromIndex:Result.range.location+Result.range.length];
            Result          =   [regexExpression firstMatchInString:NewRegxStr options:NSMatchingReportProgress range:NSMakeRange(0, NewRegxStr.length)];
        }
    }
    return [ChatStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//Chat传输字符串转成显示字符串
- (NSString*) tranStrToDisplayStr
{
  //  [em]bishi[/em]
    NSError *error;
    
    NSString *tranStr = self;
    NSString *NewRegxStr    =tranStr;
    NSString *regexStr  =  @"\\[em\\]{1}([^\\[\\]])*\\[/em\\]";
    NSRegularExpression *regexExpression = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
    if (regexExpression != nil)
    {
       
        NSDictionary *FaceDict;
        if (nil == FaceDict)
        {
            NSBundle            *bundle = [NSBundle mainBundle];
            NSString            *path = [bundle pathForResource:@"face" ofType:@"xml"];
            FaceDict = [[NSDictionary alloc] initWithContentsOfFile:path];
        }
        NSTextCheckingResult *Result   =[regexExpression firstMatchInString:NewRegxStr options:NSMatchingReportProgress range:NSMakeRange(0, NewRegxStr.length)];
        while(Result)
        {
            NSString *str           =   [NewRegxStr substringWithRange:Result.range];
            NSString *oringinStr    =   str;
            //oringinStr              =   [[oringinStr stringByReplacingOccurrencesOfString:@"[em]" withString:@""] stringByReplacingOccurrencesOfString:@"[/em]" withString:@""];
            NSArray *keys=[FaceDict allKeys];
            for(id key in keys)
            {
                if([oringinStr isEqualToString:(NSString *)key])
                {
                    NSString    *replaceStr=str;
                    replaceStr  =   [[replaceStr stringByReplacingOccurrencesOfString:@"[em]" withString:@"["] stringByReplacingOccurrencesOfString:@"[/em]" withString:@"]"];
                    tranStr     =   [tranStr stringByReplacingOccurrencesOfString:str withString:replaceStr];
                    break;
                }
            }
            NewRegxStr    =   [NewRegxStr substringFromIndex:Result.range.location+Result.range.length];
            Result  =[regexExpression firstMatchInString:NewRegxStr options:NSMatchingReportProgress range:NSMakeRange(0, NewRegxStr.length)];
        }
    }
    return tranStr;
}

- (NSString*) markupStringToHtml
{
    NSError *error;
    
    NSString *markupStr = self;
    
    NSString *regexStr  = @"((\\[emotion\\]){1}(((?!(\\[/emotion\\])).)*)(\\[/emotion\\]){1})";
    
    NSRegularExpression *regexExpression = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
    
    if (regexExpression != nil)
    {
        NSTextCheckingResult *firstMatch = [regexExpression firstMatchInString:markupStr options:0 range:NSMakeRange(0, [markupStr length])];
        
        if (firstMatch)
        {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *faceImgStr = @"";
            
            //从urlString中截取数据
            NSString *faceStr = [markupStr substringWithRange:resultRange];
            
            NSString *faceRegexStr = @"\\].*\\[";
            
            NSRegularExpression *regexFaceExp    = [NSRegularExpression regularExpressionWithPattern:faceRegexStr options:0 error:&error];
            
            NSTextCheckingResult *facefirstMatch = [regexFaceExp firstMatchInString:faceStr options:0 range:NSMakeRange(0, [faceStr length])];
            
            if (facefirstMatch)
            {
                NSRange faceresultRange = [facefirstMatch rangeAtIndex:0];
                
                faceImgStr = [faceStr substringWithRange:faceresultRange];
                
                faceImgStr = [faceImgStr stringByReplacingOccurrencesOfString:@"]" withString:@""];
                faceImgStr = [faceImgStr stringByReplacingOccurrencesOfString:@"[" withString:@""];
                
            }
            
            NSString *replceMarkup = [NSString stringWithFormat:@"<img style=\"width:24px;height:24px;\" src=\"%@\">", [[FaceImgCode Instance] FaceCodeToFileName:faceImgStr]];
            
            markupStr = [markupStr stringByReplacingCharactersInRange:resultRange withString:replceMarkup];
            
            markupStr = [markupStr markupStringToHtml];
        }
        else
        {
            markupStr = [NSString stringWithFormat:@"<p style=\"font-family:Helvetica;font-size:13px;\">%@</p>", markupStr];
            return markupStr;
        }
    }
    
    return markupStr;
}

- (NSDictionary*) jasonStrToDict
{
    return [self JSONValue];
}

@end
