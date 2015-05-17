//
//  aya_markupParser.h
//  CoreTextView
//
//  Created by Martin.Ren on 13-7-10.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreText/CoreText.h>

@interface aya_markupParser : NSObject
{
    
    NSString            *font;
    UIColor             *color;
    UIColor             *strokeColor;
    float               strokeWidth;
    
    NSMutableArray      *images;
    NSMutableArray      *urlRanges;
}

@property (retain, nonatomic) NSString* font;
@property (retain, nonatomic) UIColor* color;
@property (retain, nonatomic) UIColor* strokeColor;
@property (assign, readwrite) float strokeWidth;

@property (retain, nonatomic) NSMutableArray* images;
@property (retain, nonatomic) NSMutableArray* urlRanges;
-(NSAttributedString*)attrStringFromMarkup:(NSString*)html;

@end