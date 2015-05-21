//
//  UIView+BreakLine.h
//  HappigoStore
//
//  Created by Martin.Ren on 15/5/17.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    VIEW_BREAKLINE_POSITION_UNKWON,
    VIEW_BREAKLINE_POSITION_TOP,
    VIEW_BREAKLINE_POSITION_BOTTOM
}VIEW_BREAKLINE_POSITION;

typedef enum
{
    VIEW_BREAKLINE_STYLE_SOLID,   //实线
    VIEW_BREAKLINE_STYLE_DASHED,  //虚线
}VIEW_BREAKLINE_STYLE;

@interface UIView(BreakLine)

- (void) addBreakLineWithPosition : (VIEW_BREAKLINE_POSITION) _position
                            style : (VIEW_BREAKLINE_STYLE)    _style
                            width : (CGFloat) _width;

- (void) addBreakLineWithStyle : (VIEW_BREAKLINE_STYLE)    _style
                       postion : (CGPoint) _position
                         width : (CGFloat) _width;



@end
