//
//  NBRChatSettingViewController.m
//  NeighborsApp
//
//  Created by jason on 15/5/16.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRChatSettingViewController.h"

@interface NBRChatSettingViewController ()

@end

@implementation NBRChatSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"聊天设置"];
    [self initSubView];
    
    
}

#pragma mark Init Method
-(void) initSubView
{
    settingArr = [[NSMutableArray alloc] init];
    
    [settingArr addObject:[NSArray arrayWithObjects:@"消息免打扰",@"设置当前聊天背景",@"清空聊天记录", nil]];
    [settingArr addObject:[NSArray arrayWithObjects:@"举报", nil]];
    
    
    myTableview =[[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kNBR_SCREEN_W, kNBR_SCREEN_H) style:UITableViewStyleGrouped];
    [myTableview setBackgroundView:nil];
    [myTableview setBackgroundColor:[UIColor clearColor]];
    [myTableview setDelegate:self];
    [myTableview setDataSource:self];
    [self.view addSubview:myTableview];
    
}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [settingArr count];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[settingArr objectAtIndex:section] count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApplyCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *titlestr = [[settingArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 5.0f, kNBR_SCREEN_W-90.0f, 35.0f)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:16.0f]];
    [titleLabel setTextColor:kNBR_ProjectColor_DeepGray];
    [titleLabel setText:titlestr];
    [cell addSubview:titleLabel];
    
    if (indexPath.row == 0 && indexPath.section == 0)
    {
        UISwitch *switchbutton = [[UISwitch alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W-60.0f, 5.0f, 35.0f, 35.0f)];
        [switchbutton setOn:YES];
        
        [switchbutton addTarget:self action:@selector(ChangeSwitchValue:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:switchbutton];
        
        
    }
    
    return cell;
    
}

-(void) ChangeSwitchValue:(UISwitch *) sender
{
//    [sender setOn:!sender.on];
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
