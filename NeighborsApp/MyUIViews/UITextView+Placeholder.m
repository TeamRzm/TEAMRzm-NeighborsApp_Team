//
//  UITextView+Placeholder.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/18.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "UITextView+Placeholder.h"

@implementation UITextView(Placeholder)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setPlaceHolder : (NSString*) _placeHolder
{
    UITextField *placeHolder = (UITextField*)[self viewWithTag:0xBBBB];
    
    self.delegate = self;
    self.returnKeyType = UIReturnKeyDone;
    
    if (!placeHolder)
    {
        placeHolder = [[UITextField alloc] initWithFrame:CGRectMake(5, 7.5, CGRectGetWidth(self.frame) - 10, CGRectGetHeight(self.frame) - 10)];
        placeHolder.font = self.font;
        placeHolder.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        placeHolder.textColor = [UIColor lightGrayColor];
        placeHolder.tag = 0xBBBB;
        placeHolder.userInteractionEnabled = NO;
        
        [self addSubview:placeHolder];
    }
    
    placeHolder.text = _placeHolder;
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void) textViewDidChange:(UITextView *)textView
{
    UITextField *placeHolder = (UITextField*)[self viewWithTag:0xBBBB];
    
    if (textView.text.length > 0 )
    {
        placeHolder.hidden = YES;
    }
    else
    {
        placeHolder.hidden = NO;
    }
}

@end
