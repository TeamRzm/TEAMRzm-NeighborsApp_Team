//
//  UIView+BreakLine.m
//  HappigoStore
//
//  Created by Martin.Ren on 15/5/17.
//
//

#import "UIView+BreakLine.h"

@implementation UIView(BreakLine)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) addBreakLineWithStyle : (VIEW_BREAKLINE_STYLE)    _style
                       postion : (CGPoint) _position
                         width : (CGFloat) _width
{
    CGRect positionFrame = CGRectMake(_position.x, _position.y, _width, .5f);
    
    switch (_style)
    {
        default:
        case VIEW_BREAKLINE_STYLE_SOLID:
        {
            //实线
            UIView *breakLineView = [[UIView alloc] initWithFrame:positionFrame];
            breakLineView.backgroundColor = [UIColor colorWithRed:224.0f / 255.0f green:225.0f / 255.0f blue:226.0f / 255.0f alpha:1.0f];
            [self addSubview:breakLineView];
        }
            break;
            
        case VIEW_BREAKLINE_STYLE_DASHED:
        {
            //虚线
            UIImageView *breakLineImageView = [[UIImageView alloc] initWithFrame:positionFrame];
            breakLineImageView.image = [UIImage imageNamed:@"details_bg_dot@2x"];
            [self addSubview:breakLineImageView];
        }
            break;
    }
}

- (void) addBreakLineWithPosition : (VIEW_BREAKLINE_POSITION) _position
                            style : (VIEW_BREAKLINE_STYLE)    _style
                            width : (CGFloat) _width
{
    CGPoint postionPoint = CGPointZero;
    
    switch (_position)
    {
        default:
        case VIEW_BREAKLINE_POSITION_TOP:
        {
            postionPoint = CGPointMake(self.frame.size.width / 2.0f - _width / 2.0f, 0);
        }
            break ;
            
        case VIEW_BREAKLINE_POSITION_BOTTOM:
        {
            postionPoint = CGPointMake(self.frame.size.width / 2.0f - _width / 2.0f, self.frame.size.height - 1);
        }
            break ;
    }
    
    [self addBreakLineWithStyle:_style postion:postionPoint width:_width];
}

@end
