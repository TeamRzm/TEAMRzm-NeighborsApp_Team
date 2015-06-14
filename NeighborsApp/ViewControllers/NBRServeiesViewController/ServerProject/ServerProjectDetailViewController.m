//
//  ServerProjectDetailViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/6/12.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "ServerProjectDetailViewController.h"
#import "NewsTableViewCell.h"

@interface ServerProjectDetailViewController () <UITableViewDataSource, UITableViewDelegate,NewsTableViewCellDelegate>
{
    UITableView *boundTableView;
}
@end

@implementation ServerProjectDetailViewController

- (id) initWithDict : (NSDictionary*) _dataDict
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    [self.view addSubview:boundTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    cell.delegate = self;
    
    NSDictionary *subDict = @{};
    
    [cell setDateDict:subDict numerOfLine:0];
    
    return cell;
}

@end
