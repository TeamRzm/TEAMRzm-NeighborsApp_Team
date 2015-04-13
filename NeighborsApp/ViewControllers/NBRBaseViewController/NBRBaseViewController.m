//
//  NBRBaseViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/13.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"

@interface NBRBaseViewController ()

@end

@implementation NBRBaseViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) resignFirstResponderWithView : (UIView*) _resgignView
{
    [_resgignView resignFirstResponder];
}

- (void) setDoneStyleTextFile : (UITextField*) _textFiled
{
    _textFiled.returnKeyType = UIReturnKeyDone;
    [_textFiled addTarget:self action:@selector(resignFirstResponderWithView:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
