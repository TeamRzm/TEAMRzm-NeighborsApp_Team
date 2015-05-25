//
//  NewsTableViewCell.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/5/25.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "EGOImageView.h"

#define NewsTitleFormat @{\
NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:15.0f],\
NSForegroundColorAttributeName : kNBR_ProjectColor_StandBlue,\
}

#define NewsContentFormat @{\
NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:14.0f],\
NSForegroundColorAttributeName : kNBR_ProjectColor_DeepBlack,\
}

#define NesDescriptFormat @{\
NSFontAttributeName : [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME size:13.0f],\
NSForegroundColorAttributeName : kNBR_ProjectColor_DeepGray,\
}


typedef struct {
    CGRect titleFrame;
    CGRect contentFrame;
    CGRect imageFrame;
    CGRect addressFrame;
    CGRect timeFrame;
    
    CGSize sigenImgFrame;
} NewTableViewCellHeightStruct;

@interface NewsTableViewCell()
{
    UILabel *titleLable;
    UILabel *contentLable;
    UIView  *imageView;
    
    NSArray *imageViewSubImgArr;
}

@end

@implementation NewsTableViewCell

- (void) setDateDict : (NSDictionary*) _dict
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _subImageViews = [[NSMutableArray alloc] init];
    
    NewTableViewCellHeightStruct heightStruct = [NewsTableViewCell heighStureWithDict:_dict];
    
    //标题
    titleLable = [[UILabel alloc] initWithFrame:heightStruct.titleFrame];
    titleLable.attributedText = [[NSAttributedString alloc] initWithString:[_dict stringWithKeyPath:@"title"] attributes:NewsTitleFormat];
    titleLable.numberOfLines = 0;
    [self.contentView addSubview:titleLable];
    
    //内容
    contentLable = [[UILabel alloc] initWithFrame:heightStruct.contentFrame];
    contentLable.attributedText = [[NSAttributedString alloc] initWithString:[_dict stringWithKeyPath:@"info"] attributes:NewsContentFormat];
    contentLable.numberOfLines = 0;
    [self.contentView addSubview:contentLable];
    
    //图片
    imageView = [[UIView alloc] initWithFrame:heightStruct.imageFrame];
    imageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:imageView];
    
    
    NSInteger widthCount;
    CGSize singleImgSize = CGSizeZero;
    imageViewSubImgArr = [_dict arrayWithKeyPath:@"files"];
    switch (imageViewSubImgArr.count)
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
    
    NSInteger yIndex = imageViewSubImgArr.count > 9 ? 9 : imageViewSubImgArr.count;
    yIndex = yIndex % widthCount == 0 ? yIndex / widthCount : yIndex / widthCount + 1;
    
    for (int i = 0; i < imageViewSubImgArr.count; i++)
    {
        EGOImageView *subImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@""]];
        
        subImageView.frame = CGRectMake(i % widthCount,
                                        i / widthCount,
                                        singleImgSize.width,
                                        singleImgSize.height);
        
        subImageView.imageURL = [NSURL URLWithString:[_dict stringWithKeyPath:@"url"]];
        subImageView.tag = i;
        subImageView.userInteractionEnabled = YES;

        UITapGestureRecognizer *tapGesutre = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureWithObject:)];
        [subImageView addGestureRecognizer:tapGesutre];

        [_subImageViews addObject:subImageView];
        [imageView addSubview:subImageView];
    }
    
    return ;
}

- (void) tapGestureWithObject : (UITapGestureRecognizer*) gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(newTabelViewCell:tapSubImageViews:)])
    {
        [self.delegate newTabelViewCell:self tapSubImageViews:(UIImageView*)gesture.view];
    }
}

+ (NewTableViewCellHeightStruct) heighStureWithDict : (NSDictionary *) _dict
{
    NewTableViewCellHeightStruct heightStruce;
    
    CGRect tempTitleFrame = [[_dict stringWithKeyPath:@"title"] boundingRectWithSize:CGSizeMake(kNBR_SCREEN_W - 20, 1000)
                                                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                          attributes:NewsTitleFormat
                                                                             context:nil];
    
    CGRect tempContentFrame = [[_dict stringWithKeyPath:@"info"] boundingRectWithSize:CGSizeMake(kNBR_SCREEN_W - 20, 1000)
                                                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                           attributes:NewsContentFormat context:nil];
    
    heightStruce.titleFrame = CGRectMake(10,
                                         5,
                                         CGRectGetWidth(tempTitleFrame),
                                         CGRectGetHeight(tempTitleFrame)
                                         );
    
    heightStruce.contentFrame = CGRectMake(10,
                                           5 + CGRectGetHeight(tempTitleFrame) + 5,
                                           CGRectGetWidth(tempContentFrame),
                                           CGRectGetHeight(tempContentFrame)
                                           );
    
    //图片
    NSInteger widthCount;
    CGSize singleImgSize = CGSizeZero;
    NSArray *contentImgUrls = _dict[@"files"];
    
    switch (contentImgUrls.count)
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
    
    NSInteger yIndex = contentImgUrls.count > 9 ? 9 : contentImgUrls.count;
    yIndex = yIndex % widthCount == 0 ? yIndex / widthCount : yIndex / widthCount + 1;
    
    heightStruce.imageFrame = CGRectMake(10,
                                         heightStruce.contentFrame.origin.y + heightStruce.contentFrame.size.height + 5,
                                         kNBR_SCREEN_W - 20,
                                         yIndex * singleImgSize.height);
    
    heightStruce.sigenImgFrame = singleImgSize;
    
    return heightStruce;
}

+ (CGFloat) heightWithDict : (NSDictionary*) _dict
{
    NewTableViewCellHeightStruct heightStruct = [NewsTableViewCell heighStureWithDict:_dict];
    
    return heightStruct.imageFrame.origin.y + heightStruct.imageFrame.size.height + 5;
}

@end
