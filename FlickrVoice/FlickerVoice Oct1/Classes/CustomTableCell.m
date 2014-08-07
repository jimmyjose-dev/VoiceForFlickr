//
//  CustomTableCell.m
//  FlickerVoice
//
//  Created by Varshyl3 on 07/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTableCell.h"

@implementation CustomTableCell
@synthesize cellImageView,lblDetail;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       // self.cellImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 70, 75)]autorelease];
       // self.lblDetail = [[[UILabel alloc]initWithFrame:CGRectMake(80, 30, 100, 25)]autorelease];
        CGAffineTransform transform = CGAffineTransformMakeRotation(+1.5707963); 
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 84)];
        bgImageView.image = [UIImage imageNamed:@"bg_image.png"];
        bgImageView.transform = transform;
        [self.contentView addSubview:bgImageView];
        
        self.cellImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 74, 74)];
        self.cellImageView.image = [UIImage imageNamed:@"oading.png.png"];
     //   cellImageView.transform = transform;

        UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 74, 74)];
        topImage.image = [UIImage imageNamed:@"bg_image_top.png"];
       // topImage.transform =transform;
        [self.contentView addSubview:topImage];

        
        lblDetail.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:cellImageView];
        self.contentView.backgroundColor = [UIColor clearColor];
       // [self.contentView addSubview:lblDetail];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
