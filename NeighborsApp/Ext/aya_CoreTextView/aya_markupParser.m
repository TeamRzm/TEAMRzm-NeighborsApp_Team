//
//  aya_markupParser.m
//  CoreTextView
//
//  Created by Martin.Ren on 13-7-10.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import "aya_markupParser.h"

/*
 正则表达式
 表情（EM） :((\[em\]){1}(((?!(\[/emotion\])).)*)(\[/em\]){1})
 图片（IMG）:((\[img\]){1}(((?!(\[/img\])).)*)(\[/img\]){1})
 
 
 正则字符串
 表情（EM） :((\\[em\\]){1}(((?!(\\[/emotion\\])).)*)(\\[/em\\]){1})
 图片（IMG）:((\\[img\\]){1}(((?!(\\[/img\\])).)*)(\\[/img\\]){1}) 
 
 拼接正则:
 ((\\[em\\]){1}(((?!(\\[/emotion\\])).)*)(\\[/em\\]){1})|((\\[img\\]){1}(((?!(\\[/img\\])).)*)(\\[/img\\]){1})
 */

#define REGEX_STRING @"\\[em\\]{1}([^\\[\\]])*\\[/em\\]{1}(.*?)|\\[url\\]{1}([^\\[\\]])*\\[/url\\]{1}(.*?)"

NSDictionary *FaceDict;

static void deallocCallback( void* ref ){
//    (__bridge id)ref = nil;
}
static CGFloat ascentCallback( void *ref )
{
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}

static CGFloat descentCallback( void *ref )
{
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"descent"] floatValue];
}

static CGFloat widthCallback( void* ref )
{
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}



@implementation aya_markupParser

@synthesize font, color, strokeColor, strokeWidth;
@synthesize images,urlRanges;

-(id)init
{
    self = [super init];
    if (self) {
        self.font = @"Helvetica";
//        self.color = [UIColor blackColor];
        self.color = kNBR_ProjectColor_DeepGray;
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
        self.images = [NSMutableArray array];
        self.urlRanges = [NSMutableArray array];
    }
    return self;
}

#define CONTENT_TYPE_TEXT @"TEXT"
#define CONTENT_TYPE_UNIT @"UNIT"

- (NSAttributedString*)attrStringFromMarkup: (NSString*) markup
{
    NSMutableAttributedString* aString =
    [[NSMutableAttributedString alloc] initWithString:@""];
    
    NSRegularExpression* regex = [[NSRegularExpression alloc]
                                  initWithPattern:REGEX_STRING
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil];
    NSArray* chunks = [regex matchesInString:markup options:0 range:NSMakeRange(0, [markup length])];
    
    NSMutableArray *typeArr = [[NSMutableArray alloc] init];
    NSMutableArray *cottArr = [[NSMutableArray alloc] init];
    
    NSUInteger currSeek = 0;
    for (NSTextCheckingResult *b in chunks)
    {
        NSString *checkMarkStr = @"";
        
        NSRange textRange = NSMakeRange(currSeek, b.range.location - currSeek);
        checkMarkStr = [markup substringWithRange:textRange];
        NSLog(@"%@,%d",checkMarkStr, checkMarkStr.length);
        
        if (checkMarkStr.length != 0)
        {
            [cottArr addObject:checkMarkStr];
            [typeArr addObject:CONTENT_TYPE_TEXT];
        }
        
        checkMarkStr = [markup substringWithRange:b.range];
        [cottArr addObject:checkMarkStr];
        [typeArr addObject:CONTENT_TYPE_UNIT];
        
        currSeek = (b.range.location + b.range.length);
    }
    
    if (currSeek < [markup length])
    {
        NSRange textRange = NSMakeRange(currSeek, [markup length] - currSeek);
        NSString *checkMarkStr = [markup substringWithRange:textRange];
        [cottArr addObject:checkMarkStr];
        [typeArr addObject:CONTENT_TYPE_TEXT];
    }
    
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)self.font,
                                             15, NULL);
    
    //创建文本对齐方式
    CTTextAlignment alignment = kCTLeftTextAlignment;//左对齐 kCTRightTextAlignment为右对齐
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec=kCTParagraphStyleSpecifierAlignment;//指定为对齐属性
    alignmentStyle.valueSize=sizeof(alignment);
    alignmentStyle.value=&alignment;
    
    //创建文本行间距
    CGFloat lineSpace = 5.0f;//间距数据
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec=kCTParagraphStyleSpecifierLineSpacing;//指定为行间距属性
    lineSpaceStyle.valueSize=sizeof(lineSpace);
    lineSpaceStyle.value=&lineSpace;
    
    
    //换行模式
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByWordWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    //创建样式数组
    CTParagraphStyleSetting settings[]={
        alignmentStyle,lineSpaceStyle,lineBreakMode
    };
    
    //设置样式
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 4);
    
    for (int i = 0; i < [typeArr count]; i++)
    {
        NSString *typeString = [typeArr objectAtIndex:i];
        NSString *contString = [cottArr objectAtIndex:i];
        
        if ([typeString isEqualToString:CONTENT_TYPE_TEXT])
        {   
            NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                   (id)self.color.CGColor, kCTForegroundColorAttributeName,
                                   (__bridge id)fontRef, kCTFontAttributeName,
                                   nil];
            
            NSMutableAttributedString *subaString = [[NSMutableAttributedString alloc] initWithString:contString attributes:attrs];
            
            
            [aString appendAttributedString:subaString];
        }
        
        if ([typeString isEqualToString:CONTENT_TYPE_UNIT])
        {
            if ([[contString lowercaseString] rangeOfString:@"[url]"].length > 0)
            {
                contString = [contString substringWithRange:NSMakeRange(5, contString.length - 5 - 6)];
                
                NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                       (id)[UIColor blueColor].CGColor, kCTForegroundColorAttributeName,
                                       (__bridge id)fontRef, kCTFontAttributeName,
                                       (id)[NSNumber numberWithInt:kCTUnderlineStyleSingle],(NSString *)kCTUnderlineStyleAttributeName,
                                       nil];
                
                [urlRanges addObject:NSStringFromRange(NSMakeRange(aString.length, contString.length))];
                
                NSMutableAttributedString *subaString = [[NSMutableAttributedString alloc] initWithString:contString attributes:attrs];
                
                [aString appendAttributedString:subaString];
            }
            else
            {
                if (nil == FaceDict)
                {
                    NSBundle            *bundle = [NSBundle mainBundle];
                    NSString            *path = [bundle pathForResource:@"face" ofType:@"xml"];
                    FaceDict = [[NSDictionary alloc] initWithContentsOfFile:path];
                }
                
                NSString *fileName = [FaceDict valueForKey:contString];
                
                if (nil == fileName || fileName.length == 0)
                {
                    NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                           (id)self.color.CGColor, kCTForegroundColorAttributeName,
                                           (__bridge id)fontRef, kCTFontAttributeName,
                                           nil];
                    
                    NSMutableAttributedString *subaString = [[NSMutableAttributedString alloc] initWithString:contString attributes:attrs];
                    
                    
                    [aString appendAttributedString:subaString];
                }
                else
                {
                    [self.images addObject:
                     [NSDictionary dictionaryWithObjectsAndKeys:
                      [NSNumber numberWithInt:24], @"width",
                      [NSNumber numberWithInt:24], @"height",
                      fileName, @"fileName",
                      [NSNumber numberWithInt: [aString length]], @"location",
                      nil]
                     ];
                    
                    CTRunDelegateCallbacks callbacks;
                    callbacks.version       = kCTRunDelegateVersion1;
                    callbacks.getAscent     = ascentCallback;
                    callbacks.getDescent    = descentCallback;
                    callbacks.getWidth      = widthCallback;
                    callbacks.dealloc       = deallocCallback;
                    
                    NSDictionary* imgAttr = [NSDictionary dictionaryWithObjectsAndKeys: //2
                                             [NSNumber numberWithInt:24], @"width",
                                             [NSNumber numberWithInt:24], @"height",
                                             nil];
                    
                    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(imgAttr)); //3
                    
                    NSMutableAttributedString *subString = [[NSMutableAttributedString alloc] initWithString:@"E"];
                    
                    [subString addAttribute:(NSString*)kCTRunDelegateAttributeName value:(__bridge id)(delegate) range:NSMakeRange(0, 1)];
                    
                    [subString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[UIColor clearColor].CGColor range:NSMakeRange(0, 1)];
                    
                    CFRelease(delegate);
                    
                    [aString appendAttributedString:subString];
                }
            }
        }
    }
    
    CFRelease(fontRef);
    
    NSMutableAttributedString *subString = [[NSMutableAttributedString alloc] initWithString:@" "];
    [aString appendAttributedString:subString];
    
    [aString addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(__bridge id)paragraphStyle range:NSMakeRange(0, aString.string.length)];
    
    return (NSAttributedString*)aString;
}

- (void) dealloc
{
    self.font = nil;
    self.color = nil;
    self.strokeColor = nil;
    self.images = nil;
}

@end