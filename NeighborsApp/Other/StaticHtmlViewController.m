//
//  StaticHtmlViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/19.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "StaticHtmlViewController.h"

@interface StaticHtmlViewController ()
{
    UIWebView       *boundWebView;
    
    NSString        *boundWebviewHtmlString;
}
@end

@implementation StaticHtmlViewController

- (id) initWithHtmlString : (NSString *) htmlString
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        boundWebviewHtmlString = htmlString;
    }
    return self;
}

- (void) setHtmlString : (NSString *) htmlString
{
    boundWebviewHtmlString = htmlString;
    [boundWebView loadHTMLString:htmlString baseURL:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    boundWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H)];
    boundWebView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (boundWebviewHtmlString)
    {
        [boundWebView loadHTMLString:boundWebviewHtmlString baseURL:nil];
    }
    
    [self.view addSubview:boundWebView];
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
