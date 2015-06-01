//
//  DisclaimersViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/19.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "DisclaimersViewController.h"

@interface DisclaimersViewController ()

@end

@implementation DisclaimersViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *aboutHtmlStringPath = [[NSBundle mainBundle] pathForResource:@"about_disclaimers" ofType:@"html"];
    NSString *aboutHtmlString = [NSString stringWithContentsOfFile:aboutHtmlStringPath encoding:NSUTF8StringEncoding error:nil];
    
    self = [super  initWithViewControllerTitle:@"免责声明"
                                    textString:aboutHtmlString
                                      textFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f]
                                     textColor:kNBR_ProjectColor_DeepGray];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
