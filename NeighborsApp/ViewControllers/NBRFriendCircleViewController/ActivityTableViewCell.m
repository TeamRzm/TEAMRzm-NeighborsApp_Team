//
//  ActivityTableViewCell.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/18.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "ActivityTableViewCell.h"

@interface ActivityTableViewCell()
{
    EGOImageView *activityBackGoundImageView;
    UIImageView  *leftTagImageView;
    UIView       *bottomView;
    UIView       *activityMaskView;
    UILabel      *titleLabel;
    UILabel      *dateLable;
}

@end

@implementation ActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) heightWithEntity:(ActivityDateEntity *)_entity isDetail:(BOOL)_isDetail
{
    if (_isDetail)
    {
        return 20.0f + 150.0f;
    }
    else
    {
        return 20.0f + 150.0f + 32.0f;
    }
}

+ (CGFloat) heightWithEntity : (ActivityDateEntity *) _entity
{
    return [ActivityTableViewCell heightWithEntity:_entity isDetail:NO];
}

- (void) configWithEntity : (ActivityDateEntity*) _entity isDetail : (BOOL) _isDetail
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    //活动海报
    activityBackGoundImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"defaultActivity"]];
    activityBackGoundImageView.contentMode = UIViewContentModeScaleAspectFill;
    activityBackGoundImageView.imageURL = [NSURL URLWithString:_entity.backGounrdUrl];
    activityBackGoundImageView.frame = CGRectMake(10, 10, kNBR_SCREEN_W - 20, 150);
    activityBackGoundImageView.layer.borderColor = kNBR_ProjectColor_LightGray.CGColor;
    activityBackGoundImageView.layer.borderWidth = 0.5f;
    activityBackGoundImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:activityBackGoundImageView];
    
    //左上标签
    leftTagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 48.5, 50)];
    
    NSMutableParagraphStyle *contentViewStyle = [[NSMutableParagraphStyle alloc] init];
    contentViewStyle.lineHeightMultiple = 1;
    contentViewStyle.lineSpacing = 4.0f;
    contentViewStyle.paragraphSpacing = 3.0f;
    
    UIFont *contentFont = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:10.0f];
    
    NSDictionary *formatDict = @{
                                 NSFontAttributeName               : contentFont,
                                 NSParagraphStyleAttributeName     : contentViewStyle,
                                 NSForegroundColorAttributeName    : kNBR_ProjectColor_StandWhite,
                                 };
    
    //    CGRect contentStringSize = [_entity.leftTagStr boundingRectWithSize:CGSizeMake(CGRectGetWidth(leftTagImageView.frame), 1000)
    //                                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
    //                                                             attributes:formatDict
    //                                                                context:nil];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:_entity.leftTagStr];
    
    [attString addAttributes:formatDict range:NSMakeRange(0, _entity.leftTagStr.length)];
    
    UILabel *tagStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(leftTagImageView.frame), CGRectGetHeight(leftTagImageView.frame))];
    tagStringLabel.font = contentFont;
    tagStringLabel.numberOfLines = 2;
    tagStringLabel.textAlignment = NSTextAlignmentCenter;
    tagStringLabel.textColor = kNBR_ProjectColor_StandWhite;
    tagStringLabel.attributedText = attString;
    [leftTagImageView addSubview:tagStringLabel];
    
    switch (_entity.activityState)
    {
        case ACTIVITY_STATE_RES:
            leftTagImageView.image = [UIImage imageNamed:@"activity_01"];
            tagStringLabel.text = [NSString stringWithFormat:@"报名中\n%@", _entity.leftTagStr];
            break;
            
        case ACTIVITY_STATE_STARTING:
            leftTagImageView.image = [UIImage imageNamed:@"activity_01"];
            tagStringLabel.text = [NSString stringWithFormat:@"已开始\n%@", _entity.leftTagStr];
            break;
            
        case ACTIVITY_STATE_END:
            leftTagImageView.image = [UIImage imageNamed:@"activity_02"];
            tagStringLabel.text = [NSString stringWithFormat:@"已结束\n%@", _entity.leftTagStr];
            break;
            
        case ACTIVITY_STATE_VAIL:
            leftTagImageView.image = [UIImage imageNamed:@"activity_03"];
            tagStringLabel.text = [NSString stringWithFormat:@"已过期\n%@", _entity.leftTagStr];
            break;
            
        case ACTIVITY_STATE_UNKOWN:
        default:
            break;
    }
    [activityBackGoundImageView addSubview:leftTagImageView];
    
    //海报下方黑色遮罩
    activityMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(activityBackGoundImageView.frame) - 20.0f, CGRectGetWidth(activityBackGoundImageView.frame), 20)];
    activityMaskView.backgroundColor = [UIColor colorWithRed:0x2E / 255.0f green:0x2E / 255.0f blue:0x2E / 255.0f alpha:.6f];
    [activityBackGoundImageView addSubview:activityMaskView];
    
    UILabel *regDateLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(activityMaskView.frame) - 10, CGRectGetHeight(activityMaskView.frame))];
    regDateLable.textColor = kNBR_ProjectColor_StandWhite;
    regDateLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:11.0f];
    regDateLable.text = [NSString stringWithFormat:@"报名时间：%@",_entity.regDate];
    [activityMaskView addSubview:regDateLable];
    
    UILabel *priceLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(activityMaskView.frame) - 45, 0, 45, CGRectGetHeight(activityMaskView.frame))];
    priceLable.textColor = kNBR_ProjectColor_StandWhite;
    priceLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:12.0f];
    priceLable.textAlignment = NSTextAlignmentCenter;
    [activityMaskView addSubview:priceLable];
    
    if (_entity.price.integerValue > 0)
    {
        priceLable.backgroundColor = UIColorFromRGB(0x359DB);
        priceLable.text = [NSString stringWithFormat:@"¥%@",_entity.price];
    }
    else
    {
        priceLable.backgroundColor = UIColorFromRGB(0x25CB05);
        priceLable.text = @"免费";
    }
    [activityMaskView addSubview:priceLable];
    
    if (!_isDetail)
    {
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(activityBackGoundImageView.frame) + 10 - 1, CGRectGetWidth(activityBackGoundImageView.frame), 32.0f)];
        bottomView.layer.borderWidth = 0.5f;
        bottomView.backgroundColor = kNBR_ProjectColor_StandWhite;
        bottomView.layer.borderColor = kNBR_ProjectColor_LightGray.CGColor;
        [self.contentView addSubview:bottomView];
    
    
        //标题
        //titleLogo
        UIImageView *titleLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(bottomView.frame) / 2.0f - 13.0f / 2.0f, 13.0f, 13.0f)];
        titleLogo.image = [UIImage imageNamed:@"huodong"];
        [bottomView addSubview:titleLogo];
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(5 + 5 + 13, 0, CGRectGetWidth(bottomView.frame) - 23, CGRectGetHeight(bottomView.frame))];
        titleLable.textColor = kNBR_ProjectColor_DeepBlack;
        titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f];
        titleLable.text = _entity.titile;
        [bottomView addSubview:titleLable];
        
        //时间
        UIFont *dateCommitLableFont = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:12.0f];
        
        CGSize dataCommitStringSize = [_entity.commitDate sizeWithAttributes:@{
                                                                               NSFontAttributeName : dateCommitLableFont,
                                                                               }];
        
        UILabel *dateCommitLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(bottomView.frame) - dataCommitStringSize.width - 5, 0, dataCommitStringSize.width, CGRectGetHeight(bottomView.frame))];
        dateCommitLable.textColor = kNBR_ProjectColor_DeepBlack;
        dateCommitLable.font = dateCommitLableFont;
        dateCommitLable.textAlignment = NSTextAlignmentRight;
        dateCommitLable.text = _entity.commitDate;
        [bottomView addSubview:dateCommitLable];
        
        UIImageView *dateLogo = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(bottomView.frame) - dataCommitStringSize.width - 5 - 18, CGRectGetHeight(bottomView.frame) / 2.0f - 13.0f / 2.0f, 13.0f, 13.0f)];
        dateLogo.image = [UIImage imageNamed:@"shijian"];
        [bottomView addSubview:dateLogo];
    }
    
    return;
}

- (void) configWithEntity : (ActivityDateEntity*) _entity
{
    [self configWithEntity:_entity isDetail:NO];
}

@end
