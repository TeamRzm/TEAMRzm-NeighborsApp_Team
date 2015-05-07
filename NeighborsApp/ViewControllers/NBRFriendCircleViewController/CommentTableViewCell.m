//
//  CommentTableViewCell.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/16.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "CommentTableViewCell.h"

@interface CommentTableViewCell()
{
    FriendCircleContentEntity *entity;
    
    NSMutableArray  *subImageViews;
}

@end

@implementation CommentTableViewCell

@synthesize avterImageView;
@synthesize nikeNameLable;
@synthesize contentLable;
@synthesize addressLable;
@synthesize commitDateLable;
@synthesize loogCountLable;
@synthesize pointApprovesLable;
@synthesize contentCountLable;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}

- (void)awakeFromNib {

}

- (void) configView
{
    subImageViews = [[NSMutableArray alloc] init];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    //头像
    avterImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""]];
    avterImageView.imageURL = [NSURL URLWithString:entity.avterURL];
    avterImageView.frame = CGRectMake(10, 5, 43.0f, 43.0f);
    avterImageView.layer.cornerRadius = CGRectGetWidth(avterImageView.frame) / 2.0f;
    avterImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:avterImageView];
    
    //昵称
    nikeNameLable = [[UILabel alloc] initWithFrame:CGRectMake(63,
                                                              5,
                                                              kNBR_SCREEN_W - (43 + 10 * 3),
                                                              25.0f)];
    nikeNameLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:15.0f];
    nikeNameLable.textColor = kNBR_ProjectColor_StandBlue;
    nikeNameLable.text = entity.nickName;
    nikeNameLable.autoresizingMask = NO;
    
    self.autoresizesSubviews = NO;
    
    [self.contentView addSubview:nikeNameLable];
    
    //内容
    NSMutableParagraphStyle *contentViewStyle = [[NSMutableParagraphStyle alloc] init];
    contentViewStyle.lineHeightMultiple = 1;
    contentViewStyle.lineSpacing = 4.0f;
    contentViewStyle.paragraphSpacing = 3.0f;
    
    //format attribute string dict
    UIFont *contentFont = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f];
    
    NSDictionary *formatDict = @{
                                 NSFontAttributeName               : contentFont,
                                 NSParagraphStyleAttributeName     : contentViewStyle,
                                 NSForegroundColorAttributeName    : kNBR_ProjectColor_DeepBlack,
                                 };
    
    CGRect contentStringSize = [entity.content boundingRectWithSize:CGSizeMake(kNBR_SCREEN_W - (43 + 10 * 3), 1000)
                                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                         attributes:formatDict
                                                            context:nil];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:entity.content];
    
    [attString addAttributes:formatDict range:NSMakeRange(0, entity.content.length)];

    contentLable = [[UILabel alloc] initWithFrame:CGRectMake(nikeNameLable.frame.origin.x, nikeNameLable.frame.origin.y + CGRectGetHeight(nikeNameLable.frame), contentStringSize.size.width, contentStringSize.size.height)];
    contentLable.numberOfLines = 0;
    contentLable.attributedText = attString;
    [self.contentView addSubview:contentLable];
    
    //图片
    NSMutableArray *contentImageViews = [[NSMutableArray alloc] init];
    
    NSInteger widthCount;
    CGSize singleImgSize = CGSizeZero;
    
    switch (entity.contentImgURLList.count)
    {
            break;
            
        case 1:
        {
            widthCount = 1;
            singleImgSize = CGSizeMake((kNBR_SCREEN_W - (43 + 10 * 3) - 10) / 1.0f,
                                       (kNBR_SCREEN_W - (43 + 10 * 3) - 10) / 1.0f);
        }
            break;
            
        case 2:
        case 4:
        {
            widthCount = 2;
            singleImgSize = CGSizeMake((kNBR_SCREEN_W - (43 + 10 * 3) - 10) / 2.0f,
                                       (kNBR_SCREEN_W - (43 + 10 * 3) - 10) / 2.0f);
        }
            break;
            
        case 0:
        case 3:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        default:
        {
            widthCount = 3;
            singleImgSize = CGSizeMake((kNBR_SCREEN_W - (43 + 10 * 3) - 10) / 3.0f,
                                       (kNBR_SCREEN_W - (43 + 10 * 3) - 10) / 3.0f);
        }
            break;
    }
    
    for (int i = 0; i < entity.contentImgURLList.count; i++)
    {
        if (i >= 9)
        {
            return ;
        }
        
        EGOImageView *subImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""]];
        subImageView.imageURL = [NSURL URLWithString:entity.contentImgURLList[i]];
        
        subImageView.frame = CGRectMake( nikeNameLable.frame.origin.x + (i % widthCount) * singleImgSize.width,
                                         contentLable.frame.origin.y + contentLable.frame.size.height + (i / widthCount) * singleImgSize.height + 10,
                                         singleImgSize.width - 2, singleImgSize.height - 2);
        
        subImageView.layer.borderColor = kNBR_ProjectColor_LightGray.CGColor;
        subImageView.layer.borderWidth = 0.5f;
        subImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSubImageView:)];
        [subImageView addGestureRecognizer:tapGesture];
        
        
        [contentImageViews addObject:subImageView];
        [self.contentView addSubview:subImageView];
        [subImageViews addObject:subImageView];
    }
    
    //小区定位尖脚logo
    NSInteger yIndex = entity.contentImgURLList.count > 9 ? 9 :entity.contentImgURLList.count;
    
    yIndex = yIndex % widthCount == 0 ? yIndex / widthCount : yIndex / widthCount + 1;
    
    UIImageView *addressLogo = [[UIImageView alloc] initWithFrame:CGRectMake(contentLable.frame.origin.x,
                                                                             contentLable.frame.origin.y + contentLable.frame.size.height + (yIndex) * singleImgSize.height + (yIndex == 0 ? 0 : 10) + 5.5,
                                                                             8.5,
                                                                             11)];
    addressLogo.image = [UIImage imageNamed:@"xiaoQuAddressIcon"];
    [self.contentView addSubview:addressLogo];
    
    //地点
    UIFont *addressContentFont = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:12.0f];
    CGSize addressStringSize = [entity.address sizeWithAttributes:@{NSFontAttributeName : addressContentFont}];
    
    addressLable = [[UILabel alloc] initWithFrame:CGRectMake(contentLable.frame.origin.x + 11,
                                                             contentLable.frame.origin.y + contentLable.frame.size.height + (yIndex) * singleImgSize.height + (yIndex == 0 ? 0 : 10) + 5,
                                                             addressStringSize.width,
                                                             addressStringSize.height)];
    addressLable.text = entity.address;
    addressLable.font = addressContentFont;
    addressLable.textColor = kNBR_ProjectColor_StandBlue;
    [self.contentView addSubview:addressLable];
    
    //时间

    UIFont *commitDateFont = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:11.0f];
    CGSize commitDateStringSize = [entity.commitDate sizeWithAttributes:@{NSFontAttributeName : addressContentFont}];
    
    commitDateLable = [[UILabel alloc] initWithFrame:CGRectMake(addressLable.frame.origin.x + addressStringSize.width + 10,
                                                                addressLable.frame.origin.y + (CGRectGetHeight(addressLable.frame) / 2.0f) - commitDateStringSize.height / 2.0f,
                                                                commitDateStringSize.width,
                                                                commitDateStringSize.height)];
    commitDateLable.text = entity.commitDate;
    commitDateLable.font = commitDateFont;
    commitDateLable.textColor = kNBR_ProjectColor_DeepGray;
    [self.contentView addSubview:commitDateLable];
    
    //查看次数，点赞数量，回复数量
    UIView *bottonView = [[UIView alloc] initWithFrame:CGRectMake(addressLogo.frame.origin.x,
                                                                  commitDateLable.frame.origin.y + commitDateLable.frame.size.height + 5,
                                                                  kNBR_SCREEN_W - (43 + 10 * 3),
                                                                  16)];
//    bottonView.backgroundColor = kNBR_ProjectColor_LightGray;
    [self.contentView addSubview:bottonView];
    
    //查看次数
    UIImageView *lookCountImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 16.0f / 2.0f - 9.0f / 2.0f, 10, 9)];
    lookCountImgView.image = [UIImage imageNamed:@"liulan"];
    
    //点赞次数
    UIImageView *zanCountImgView = [[UIImageView alloc] initWithFrame:CGRectMake(155, 16.0f / 2.0f - 9.0f / 2.0f, 10, 9)];
    zanCountImgView.image = [UIImage imageNamed:@"zan02"];
    
    //留言次数
    UIImageView *commentCountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 16.0f / 2.0f - 9.0f / 2.0f + 1, 10, 9)];
    commentCountImageView.image = [UIImage imageNamed:@"liuyan"];
    
    [bottonView addSubview:lookCountImgView];
//    [bottonView addSubview:zanCountImgView];
    [bottonView addSubview:commentCountImageView];
    
    
    //lable
    UILabel *lookCountLable = [[UILabel alloc] initWithFrame:CGRectMake(13, 1, 160, 16)];
    lookCountLable.textColor = kNBR_ProjectColor_DeepGray;
    lookCountLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:10];
    lookCountLable.text = entity.lookCount;
    
    UILabel *zanCountLable = [[UILabel alloc] initWithFrame:CGRectMake(168, 1, 40, 16)];
    zanCountLable.textColor = kNBR_ProjectColor_DeepGray;
    zanCountLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:9.0f];
    zanCountLable.text = entity.pointApproves;
    
    UILabel *commentCountLable = [[UILabel alloc] initWithFrame:CGRectMake(213, 1, 40, 16)];
    commentCountLable.textColor = kNBR_ProjectColor_DeepGray;
    commentCountLable.text = entity.commentCount;
    commentCountLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:9.0f];
    
    [bottonView addSubview:lookCountLable];
    [bottonView addSubview:zanCountLable];
    [bottonView addSubview:commentCountLable];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setDateEntity : (FriendCircleContentEntity*) _dateEntity
{
    entity = _dateEntity;
    
    [self configView];
}

+ (CGFloat) heightWithEntity : (FriendCircleContentEntity*) _dateEntity
{
    FriendCircleContentEntity *entity = _dateEntity;
    //头像
    EGOImageView *avterImageView = [[EGOImageView alloc] init];
    avterImageView.frame = CGRectMake(10, 5, 43.0f, 43.0f);
    
    //昵称
    UILabel *nikeNameLable = [[UILabel alloc] initWithFrame:CGRectMake(63,
                                                              5,
                                                              kNBR_SCREEN_W - (43 + 10 * 3),
                                                              25.0f)];
    
    //内容
    NSMutableParagraphStyle *contentViewStyle = [[NSMutableParagraphStyle alloc] init];
    contentViewStyle.lineHeightMultiple = 1;
    contentViewStyle.lineSpacing = 4.0f;
    contentViewStyle.paragraphSpacing = 3.0f;
    
    //format attribute string dict
    UIFont *contentFont = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14];
    
    NSDictionary *formatDict = @{
                                 NSFontAttributeName               : contentFont,
                                 NSParagraphStyleAttributeName     : contentViewStyle,
                                 NSForegroundColorAttributeName    : kNBR_ProjectColor_DeepBlack,
                                 };
    
    CGRect contentStringSize = [entity.content boundingRectWithSize:CGSizeMake(kNBR_SCREEN_W - (43 + 10 * 3), 1000)
                                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                         attributes:formatDict
                                                            context:nil];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:entity.content];
    
    [attString addAttributes:formatDict range:NSMakeRange(0, entity.content.length)];
    
    UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(nikeNameLable.frame.origin.x, nikeNameLable.frame.origin.y + CGRectGetHeight(nikeNameLable.frame), contentStringSize.size.width, contentStringSize.size.height)];
    
    //图片
    NSInteger widthCount;
    CGSize singleImgSize = CGSizeZero;
    
    switch (entity.contentImgURLList.count)
    {
        case 1:
        {
            widthCount = 1;
            singleImgSize = CGSizeMake((kNBR_SCREEN_W - (43 + 10 * 3) - 10) / 1.0f,
                                       (kNBR_SCREEN_W - (43 + 10 * 3) - 10) / 1.0f);
        }
            break;
            
        case 2:
        case 4:
        {
            widthCount = 2;
            singleImgSize = CGSizeMake((kNBR_SCREEN_W - (43 + 10 * 3) - 10) / 2.0f,
                                       (kNBR_SCREEN_W - (43 + 10 * 3) - 10) / 2.0f);
        }
            break;
            
        case 0:
        case 3:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        default:
        {
            widthCount = 3;
            singleImgSize = CGSizeMake((kNBR_SCREEN_W - (43 + 10 * 3) - 10) / 3.0f,
                                       (kNBR_SCREEN_W - (43 + 10 * 3) - 10) / 3.0f);
        }
            break;
    }
    
    //小区定位尖脚logo
    NSInteger yIndex = entity.contentImgURLList.count > 9 ? 9 : entity.contentImgURLList.count;
    
    yIndex = yIndex % widthCount == 0 ? yIndex / widthCount : yIndex / widthCount + 1;
    
    UIImageView *addressLogo = [[UIImageView alloc] initWithFrame:CGRectMake(contentLable.frame.origin.x,
                                                                             contentLable.frame.origin.y + contentLable.frame.size.height + (yIndex) * singleImgSize.height + (yIndex == 0 ? 0 : 10) + 5.5,
                                                                             8.5,
                                                                             11)];
    addressLogo.image = [UIImage imageNamed:@"xiaoQuAddressIcon"];
    
    //地点
    UIFont *addressContentFont = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:12.0f];
    CGSize addressStringSize = [entity.address sizeWithAttributes:@{NSFontAttributeName : addressContentFont}];
    
    UILabel *addressLable = [[UILabel alloc] initWithFrame:CGRectMake(contentLable.frame.origin.x + 11,
                                                             contentLable.frame.origin.y + contentLable.frame.size.height + (yIndex) * singleImgSize.height + (yIndex == 0 ? 0 : 10) + 5.5,
                                                             addressStringSize.width,
                                                             addressStringSize.height)];
    
    //时间
    CGSize commitDateStringSize = [entity.address sizeWithAttributes:@{NSFontAttributeName : addressContentFont}];
    UILabel *commitDateLable = [[UILabel alloc] initWithFrame:CGRectMake(addressLable.frame.origin.x + addressStringSize.width + 10,
                                                                addressLable.frame.origin.y + (CGRectGetHeight(addressLable.frame) / 2.0f) - commitDateStringSize.height / 2.0f + 1,
                                                                commitDateStringSize.width,
                                                                commitDateStringSize.height)];
    //查看次数，点赞数量，回复数量
    UIView *bottonView = [[UIView alloc] initWithFrame:CGRectMake(addressLogo.frame.origin.x,
                                                                  commitDateLable.frame.origin.y + commitDateLable.frame.size.height + 5,
                                                                  kNBR_SCREEN_W - (43 + 10 * 3),
                                                                  16)];
    
    return bottonView.frame.origin.y + CGRectGetHeight(bottonView.frame) + 10;

}


- (void) tapSubImageView : (UIGestureRecognizer*) _gesture
{
    if (self.delegate)
    {
        [self.delegate commentTableViewCell:self tapSubImageViews:(UIImageView*)_gesture.view allSubImageViews:subImageViews];
    }
}

@end
