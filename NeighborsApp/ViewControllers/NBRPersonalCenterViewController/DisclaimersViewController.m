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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"免责声明";
    // Do any additional setup after loading the view.
    NSString *aboutHtmlString = [[NSBundle mainBundle] pathForResource:@"about_disclaimers" ofType:@"html"];
    
    NSString *htmlString = [NSString stringWithContentsOfFile:aboutHtmlString encoding:NSUTF8StringEncoding error:nil];
    
    [self setHtmlString:htmlString];
    
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