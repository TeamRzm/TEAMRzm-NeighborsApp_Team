//
//  SearchPlotListViewController.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/8.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "SearchPlotListViewController.h"
#import "CreaterRequest_Village.h"

@interface SearchPlotListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *dateSourceArray;
    UITableView     *boundTableView;
    
    ASIHTTPRequest *searchVillageRequest;
    
    ASIHTTPRequest *nearVillAgeRequest;
}

@end

@implementation SearchPlotListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dateSourceArray = [[NSMutableArray alloc] init];
    
    boundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    boundTableView.delegate = self;
    boundTableView.dataSource = self;
    [self.view addSubview:boundTableView];
    
    [self requestListByKey:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) requestListByKey : (NSString*) _key
{
    searchVillageRequest = [CreaterRequest_Village CreateListRequestWithSearchID:@"" key:_key size:@"50"];
    
    __weak ASIHTTPRequest *blockRequest = searchVillageRequest;
    
    [blockRequest setCompletionBlock:^{
        
        [self removeLoadingView];
        
        NSDictionary *resposneDict = [blockRequest.responseString JSONValue];
        
        if ([CreaterRequest_Village CheckErrorResponse:resposneDict errorAlertInViewController:self])
        {
            dateSourceArray = [NSMutableArray arrayWithArray:[resposneDict arrayWithKeyPath:@"data\\result"]];
            
            [boundTableView reloadData];
            
            return ;
        }
    }];
    
    [self setDefaultRequestFaild:blockRequest];
    
    [searchVillageRequest startAsynchronous];
    [self addLoadingView];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dateSourceArray.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNBR_TABLEVIEW_CELL_NOIDENTIFIER];
    
    cell.textLabel.text = dateSourceArray[indexPath.row][@"name"];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectDict = dateSourceArray[indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchPlotListViewController:didselectDict:)])
    {
        [self.delegate searchPlotListViewController:self didselectDict:selectDict];
    }
    
    return ;
}


@end
