//
//  ComplaintsStateCell.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/25.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NBRBaseViewController.h"
#import "ComplaintsStateCell.h"

@implementation ComplaintsStateCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.layer.masksToBounds = YES;
    }
    
    return self;
}

- (void) setDateDict : (NSDictionary*) _dataDict isAction : (BOOL) isAction
{
    //时间格式转换
    NSDate *createDate = [NBRBaseViewController dateWithString:[_dataDict stringWithKeyPath:@"created"]];
    NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
    dataFormat.dateFormat = @"YYYY年M月d日 H:mm";
    
    UITextField *titleLable = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, kNBR_SCREEN_W - 10 - 50, 50.0f / 2.0f - 3)];
    titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
    titleLable.userInteractionEnabled = NO;
    titleLable.textColor = kNBR_ProjectColor_DeepBlack;
    titleLable.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    titleLable.text = [_dataDict stringWithKeyPath:@"content"];
    
    UITextField *dateLable = [[UITextField alloc] initWithFrame:CGRectMake(50, 50.0f / 2.0f + 3, kNBR_SCREEN_W - 10 - 50, 50.0f / 2.0f - 3)];
    dateLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
    dateLable.userInteractionEnabled = NO;
    dateLable.textColor = kNBR_ProjectColor_DeepBlack;
    dateLable.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    dateLable.text = [dataFormat stringFromDate:createDate];
    
    [self.contentView addSubview:titleLable];
    [self.contentView addSubview:dateLable];
    
    UIView *actionView;
    UIView *aciontLine;
    
    if (isAction)
    {
        titleLable.textColor = [UIColor colorWithRed:32.0f / 255.0f green:85.0f / 255.0f blue:123.0f / 255.0f alpha:1.0f];
        dateLable.textColor = [UIColor colorWithRed:32.0f / 255.0f green:85.0f / 255.0f blue:123.0f / 255.0f alpha:1.0f];
        
        actionView = [[UIView alloc] initWithFrame:CGRectMake(50.0f / 2.0f - 20 / 2.0f,
                                                              50.0f / 2.0f - 20 / 2.0f - 10,
                                                              20,
                                                              20)];
        actionView.layer.cornerRadius = 20 / 2.0f;
        actionView.layer.borderColor = [UIColor colorWithRed:188.0f / 255.0f green:219.0f / 255.0f blue:241.0f / 255.0f alpha:1.0f].CGColor;
        actionView.layer.borderWidth = 1.5f;
        actionView.backgroundColor = [UIColor colorWithRed:59.0f / 255.0f green:151.0f / 255.0f blue:218.0f / 255.0f alpha:1.0f];
        
        aciontLine = [[UIView alloc] initWithFrame:CGRectMake(50.0f / 2.0f - 2.0f / 2.0f,
                                                              50.0f / 2.0f - 20 / 2.0f - 5,
                                                              2,
                                                              50 - (50.0f / 2.0f - 20 / 2.0f - 5))];
        aciontLine.backgroundColor = [UIColor colorWithRed:198.0f / 255.0f green:199.0f / 255.0f blue:201.0f / 255.0f alpha:1.0f];
        aciontLine.layer.masksToBounds = YES;
        
        self.contentView.layer.masksToBounds = YES;
        [self.contentView addSubview:aciontLine];
        [self.contentView addSubview:actionView];
    }
    else
    {
        actionView = [[UIView alloc] initWithFrame:CGRectMake(50.0f / 2.0f - 15 / 2.0f,
                                                              50.0f / 2.0f - 15 / 2.0f - 10,
                                                              15,
                                                              15)];
        actionView.layer.cornerRadius = 15 / 2.0f;
        actionView.backgroundColor = [UIColor colorWithRed:198.0f / 255.0f green:199.0f / 255.0f blue:201.0f / 255.0f alpha:1.0f];
        
        
        aciontLine = [[UIView alloc] initWithFrame:CGRectMake(50.0f / 2.0f - 2.0f / 2.0f,
                                                              0,
                                                              2,
                                                              50.0f)];
        aciontLine.backgroundColor = [UIColor colorWithRed:198.0f / 255.0f green:199.0f / 255.0f blue:201.0f / 255.0f alpha:1.0f];
        aciontLine.layer.masksToBounds = YES;
        
        self.contentView.layer.masksToBounds = YES;
        [self.contentView addSubview:aciontLine];
        [self.contentView addSubview:actionView];
    }
    
    
    
    return ;
}

@end
