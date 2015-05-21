//
//  ComplaintsCell.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/21.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "ComplaintsCell.h"
#import "EGOImageView.h"

@interface ComplaintsCellHeightObject : NSObject
@property (nonatomic, assign) CGRect titleLableFrame;
@property (nonatomic, assign) CGRect stateLableFrame;
@property (nonatomic, assign) CGRect contentLableFrame;
@property (nonatomic, assign) CGRect bottomDescLableFrame;
@property (nonatomic, assign) CGRect imageFrames;
@end

@implementation ComplaintsCellHeightObject @end

@interface ComplaintsCell()
{
    UILabel     *titleLable;
    UILabel     *stateLable;
    UILabel     *contentLable;
    UILabel     *bottomDescLable;
    
    CGRect      *titleLableFrame;
    
    NSMutableArray *subImageViews;
}

@end

@implementation ComplaintsCell


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        subImageViews = [[NSMutableArray alloc] init];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setDataDict : (NSDictionary *) dict cellMode : (COMPLAINT_CELL_MODE) _mode
{
    ComplaintsCellHeightObject *h = [ComplaintsCell getHeightObjectWithDict:dict];
    
    //标题
    NSDictionary *titleFormat = @{
                                  NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f],
                                  NSForegroundColorAttributeName : kNBR_ProjectColor_StandBlue,
                                  };
    
    titleLable = [[UILabel alloc] initWithFrame:h.titleLableFrame];
    
    NSString *titleString;
    
    switch (_mode)
    {
        default:
        case COMPLAINT_CELL_MODE_COMPLAINT:
        {
            titleString = [NSString stringWithFormat:@"投诉号:%@", dict[@"complaintId"]];
        }
            break;
            
        case COMPLAINT_CELL_MODE_REPAIR:
        {
            titleString = [NSString stringWithFormat:@"报修号:%@", dict[@"complaintId"]];
        }
            break;
    }
    
    titleLable.attributedText = [[NSAttributedString alloc] initWithString:titleString attributes:titleFormat];
    [titleLable addBreakLineWithStyle:VIEW_BREAKLINE_STYLE_SOLID
                                   postion:CGPointMake(0, CGRectGetHeight(h.titleLableFrame) - 1)
                                     width:CGRectGetWidth(h.titleLableFrame)];
    titleLable.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLable];
    
    //状态
    NSDictionary *stateFormat = @{
                                  NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f],
                                  NSForegroundColorAttributeName : kNBR_ProjectColor_DeepBlack,
                                  };
    stateLable = [[UILabel alloc] initWithFrame:h.stateLableFrame];
    stateLable.textAlignment = NSTextAlignmentRight;
    NSString *stateString = @"";
    
    switch ([dict numberWithKeyPath:@"state"])
    {
        case 0: stateString = @"未处理"; break ;
        case 1: stateString = @"处理中"; break ;
        case 2: stateString = @"拒绝处理"; break ;
        case 3: stateString = @"投诉已经关闭"; break ;
        case 4: stateString = @"处理成功"; break ;
        
            break;
            
        default:
            break;
    }
    
    stateLable.attributedText = [[NSAttributedString alloc] initWithString:stateString attributes:stateFormat];
    [self.contentView addSubview:titleLable];
    [self.contentView addSubview:stateLable];
    
    //内容
    NSDictionary *contentFormat = @{
                                    NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f],
                                    NSForegroundColorAttributeName : kNBR_ProjectColor_DeepBlack,
                                    };
    contentLable = [[UILabel alloc] initWithFrame:h.contentLableFrame];
    contentLable.attributedText = [[NSAttributedString alloc] initWithString:dict[@"content"] attributes:contentFormat];
    contentLable.numberOfLines = 0;
    [self addSubview:contentLable];
    
    //图片
    NSArray *contentImgURLList = [dict arrayWithKeyPath:@"files"];
    NSMutableArray *contentImageViews = [[NSMutableArray alloc] init];
    
    NSInteger widthCount;
    CGSize singleImgSize = CGSizeZero;
    
    switch (contentImgURLList.count)
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
    
    for (int i = 0; i < contentImgURLList.count; i++)
    {
        if (i >= 9)
        {
            return ;
        }
        
        EGOImageView *subImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""]];
        subImageView.imageURL = [NSURL URLWithString:contentImgURLList[i][@"url"]];
        subImageView.contentMode = UIViewContentModeScaleAspectFill;
        subImageView.layer.masksToBounds = YES;
        
        subImageView.frame = CGRectMake( contentLable.frame.origin.x + (i % widthCount) * singleImgSize.width,
                                        contentLable.frame.origin.y + contentLable.frame.size.height + (i / widthCount) * singleImgSize.height + 10,
                                        singleImgSize.width - 2, singleImgSize.height - 2);
        
        subImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSubImageView:)];
        [subImageView addGestureRecognizer:tapGesture];
        
        
        [contentImageViews addObject:subImageView];
        [self.contentView addSubview:subImageView];
        [subImageViews addObject:subImageView];
    }
    
    //描述信息
    bottomDescLable = [[UILabel alloc] initWithFrame:h.bottomDescLableFrame];
    bottomDescLable.attributedText = [[NSAttributedString alloc] initWithString:[dict stringWithKeyPath:@"lastPost"] attributes:contentFormat];
    [bottomDescLable addBreakLineWithStyle:VIEW_BREAKLINE_STYLE_SOLID postion:CGPointMake(0, 0) width:CGRectGetWidth(h.bottomDescLableFrame)];

    [self.contentView addSubview:bottomDescLable];
}

- (void) tapSubImageView : (UIGestureRecognizer*) _gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(complaintsCell:tapSubImageViews:allSubImageViews:)])
    {
        [self.delegate complaintsCell:self
                     tapSubImageViews:(UIImageView*)_gesture.view
                     allSubImageViews:subImageViews];
    }
}

+ (ComplaintsCellHeightObject*) getHeightObjectWithDict : (NSDictionary*) dict
{
    ComplaintsCellHeightObject *resultObject = [[ComplaintsCellHeightObject alloc] init];
    
    NSDictionary *contentFormat = @{
                                    NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f],
                                    NSForegroundColorAttributeName : kNBR_ProjectColor_DeepBlack,
                                    };
    
    CGRect contentSize = [[dict stringWithKeyPath:@"content"] boundingRectWithSize:CGSizeMake(kNBR_SCREEN_W - 20, 2048)
                                                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                        attributes:contentFormat
                                                                           context:nil];
    
    resultObject.titleLableFrame = CGRectMake(10, 0, kNBR_SCREEN_W - 20, 30.0f);
    resultObject.stateLableFrame = CGRectMake(10, 0, kNBR_SCREEN_W - 20, 30.0f);
    resultObject.contentLableFrame = CGRectMake(10, 35, kNBR_SCREEN_W - 20, contentSize.size.height);
    
    NSArray *contentImageViews = [dict arrayWithKeyPath:@"files"];
    
    NSInteger widthCount = 0;
    NSInteger heightCount = 0;
    CGSize singleImgSize = CGSizeZero;
    
    switch (contentImageViews.count)
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
    
    heightCount = (contentImageViews.count % widthCount) == 0 ? (contentImageViews.count / widthCount) : (contentImageViews.count / widthCount + 1);
    
    resultObject.imageFrames = CGRectMake(10,
                                          resultObject.contentLableFrame.origin.y + resultObject.contentLableFrame.size.height + 5,
                                          kNBR_SCREEN_W,
                                          heightCount * singleImgSize.height);
    
    resultObject.bottomDescLableFrame = CGRectMake(10,
                                                   resultObject.imageFrames.origin.y + resultObject.imageFrames.size.height + 10,
                                                   kNBR_SCREEN_W - 20,
                                                   35.0f);
    
    return resultObject;

}

+ (CGFloat) heightForDataDict : (NSDictionary *) dict
{
    ComplaintsCellHeightObject *h = [ComplaintsCell getHeightObjectWithDict:dict];
    
    return h.bottomDescLableFrame.origin.y + h.bottomDescLableFrame.size.height;
}

@end
