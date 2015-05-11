//
//  NBRTabbarController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/3/26.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRTabbarController.h"
#import "NBRLoginViewController.h"

@interface NBRTabbarController ()

@end

@implementation NBRTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showLoginViewControllerWithAnimtion : (BOOL) animtion
{
    NBRLoginViewController *nVC = [[NBRLoginViewController alloc] initWithNibName:@"NBRLoginViewController" bundle:nil];
    
    UINavigationController *nNavVC = [[UINavigationController alloc] initWithRootViewController:nVC];
    
    [self presentViewController:nNavVC animated:animtion completion:^{
        
    }];
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
