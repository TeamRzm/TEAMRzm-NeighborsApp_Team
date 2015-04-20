//
//  SubCommentTableViewCell.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/20.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "SubCommentTableViewCell.h"

@implementation SubCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setDataEntity : (CommentEntity*) _entit
{
    //头像
    EGOImageView *avterImgView = [[EGOImageView alloc] initWithPlaceholderImage: [UIImage imageNamed:_entit.avterIconURL]];
    avterImgView.frame = CGRectMake(10.0f, 56 / 2.0f - 43 / 2.0f, 43, 43);
    avterImgView.layer.cornerRadius = avterImgView.frame.size.width / 2.0f;
    avterImgView.layer.masksToBounds = YES;
    [self.contentView addSubview:avterImgView];
    
    //标题
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(68.0f,
                                                                    11,
                                                                    kNBR_SCREEN_W - 68.0f - 10,
                                                                    15)];
    titleLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:13.0f];
    titleLable.textColor = kNBR_ProjectColor_StandBlue;
    titleLable.text = _entit.userName;
    
    //内容
    //format attribute string dict
    NSMutableParagraphStyle *contentViewStyle = [[NSMutableParagraphStyle alloc] init];
    contentViewStyle.lineHeightMultiple = 1;
    contentViewStyle.lineSpacing = 4.0f;
    contentViewStyle.paragraphSpacing = 3.0f;
    
    UIFont *contentFont = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13];
    
    NSDictionary *formatDict = @{
                                 NSFontAttributeName               : contentFont,
                                 NSParagraphStyleAttributeName     : contentViewStyle,
                                 NSForegroundColorAttributeName    : kNBR_ProjectColor_DeepBlack,
                                 };
    
    CGRect contentStringSize = [_entit.content boundingRectWithSize:CGSizeMake(kNBR_SCREEN_W - 68.0f - 10, 1000)
                                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                         attributes:formatDict
                                                            context:nil];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:_entit.content];
    
    [attString addAttributes:formatDict range:NSMakeRange(0, _entit.content.length)];
    
    
    UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(68.0f,
                                                                      33,
                                                                      contentStringSize.size.width,
                                                                      contentStringSize.size.height)];
    contentLable.font = contentFont;
    contentLable.textColor = UIColorFromRGB(0x999999);
    contentLable.numberOfLines = 0;
    contentLable.attributedText = attString;
    
    //接收时间
    UILabel *revieTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(kNBR_SCREEN_W - 70 - 10, 12, 70, 15)];
    revieTimeLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:12.0f];
    revieTimeLable.textAlignment = NSTextAlignmentRight;
    revieTimeLable.backgroundColor = [UIColor clearColor];
    revieTimeLable.textColor = UIColorFromRGB(0x999999);
    revieTimeLable.text = _entit.commitDate;
    
    [self.contentView addSubview:titleLable];
    [self.contentView addSubview:contentLable];
    [self.contentView addSubview:revieTimeLable];
}

+ (CGFloat) HeightWithEntity : (CommentEntity*) _entit
{
    //头像
    EGOImageView *avterImgView = [[EGOImageView alloc] initWithPlaceholderImage: [UIImage imageNamed:_entit.avterIconURL]];
    avterImgView.frame = CGRectMake(10.0f, 56 / 2.0f - 43 / 2.0f, 43, 43);

    //内容
    //format attribute string dict
    NSMutableParagraphStyle *contentViewStyle = [[NSMutableParagraphStyle alloc] init];
    contentViewStyle.lineHeightMultiple = 1;
    contentViewStyle.lineSpacing = 4.0f;
    contentViewStyle.paragraphSpacing = 3.0f;
    
    UIFont *contentFont = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13];
    
    NSDictionary *formatDict = @{
                                 NSFontAttributeName               : contentFont,
                                 NSParagraphStyleAttributeName     : contentViewStyle,
                                 NSForegroundColorAttributeName    : kNBR_ProjectColor_DeepBlack,
                                 };
    
    CGRect contentStringSize = [_entit.content boundingRectWithSize:CGSizeMake(kNBR_SCREEN_W - 68.0f - 10, 1000)
                                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                         attributes:formatDict
                                                            context:nil];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:_entit.content];
    
    [attString addAttributes:formatDict range:NSMakeRange(0, _entit.content.length)];
    
    
    UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(68.0f,
                                                                      33,
                                                                      contentStringSize.size.width,
                                                                      contentStringSize.size.height)];
    
    CGFloat restuleHeight = contentLable.frame.origin.y + contentLable.frame.size.height;
    
    if ((restuleHeight + 10) < 56.0f)
    {
        return 56.0f;
    }
    else
    {
        return restuleHeight + 10;
    }
}

@end
