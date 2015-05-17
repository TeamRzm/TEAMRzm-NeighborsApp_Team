//
//  aya_coreTextView.h
//  CoreTextView
//
//  Created by Martin.Ren on 13-7-10.
//  Copyright (c) 2013年 Martin.Ren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "aya_markupParser.h"

@class aya_coreTextView;

@protocol aya_coreTextViewDelegate <NSObject>

- (void) aya_coreTextView : (aya_coreTextView*) _coreTextView willClickUrlUnit : (NSString*) _url;

@end

@interface aya_coreTextView : UIView
{
    NSAttributedString    *attString;
    
    NSMutableArray      *images;
    NSMutableArray      *imagesData;
    NSMutableArray      *urlRanges;
    
    aya_markupParser    *parser;
    
    
    CTFramesetterRef    _coreTextFramerSetter;
    CTFrameRef          _coreTextFrame;
}

@property (nonatomic, assign) id<aya_coreTextViewDelegate> delegate;

- (id) initWithMarkUpString : (NSString*) _markUpString width : (CGFloat) _width x : (CGFloat) _x y : (CGFloat) _y;

@end
