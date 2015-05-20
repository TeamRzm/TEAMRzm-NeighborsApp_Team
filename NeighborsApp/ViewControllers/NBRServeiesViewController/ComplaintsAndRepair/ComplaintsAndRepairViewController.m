//
//  ComplaintsAndRepairViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/20.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "ComplaintsAndRepairViewController.h"
#import "CommitNewContentViewController.h"

@interface ComplaintsAndRepairViewController ()
{
    NSInteger   currSegmentIndex;
}
@end

@implementation ComplaintsAndRepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投诉与报修";
    
    currSegmentIndex = 0;
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightAddItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tianjia01"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarbuttonAction:)];
    self.navigationItem.rightBarButtonItem = rightAddItem;
}

- (void) rightBarbuttonAction : (id) sender
{
    if (currSegmentIndex == 0)
    {
        CommitNewContentViewController *newContentViewControlelr = [[CommitNewContentViewController alloc] initWithNibName:nil bundle:nil];
        newContentViewControlelr.title = @"我要投诉";
        newContentViewControlelr.mode = COMMIT_TO_MODE_COMPLAIN;
        
        [self.navigationController pushViewController:newContentViewControlelr animated:YES];
    }
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
