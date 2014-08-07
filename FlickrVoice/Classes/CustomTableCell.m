//
//  CustomTableCell.m
//  FlickerVoice
//
//  Created by Varshyl3 on 07/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTableCell.h"
#import <QuartzCore/QuartzCore.h>
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
        UIImageView *bgImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 84)]autorelease];
        bgImageView.image = [UIImage imageNamed:@"bg_image.png"];
        
        [self.contentView addSubview:bgImageView];
        bgImageView.transform = transform;
        
        self.cellImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(4, 6, 72, 72)]autorelease];
        cellImageView.layer.cornerRadius = 5.0;
        cellImageView.layer.borderWidth = 1.0;
        cellImageView.layer.masksToBounds = YES;
        //cellImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.cellImageView.image = [UIImage imageNamed:@"loading.png"];
      //  cellImageView.transform = transform;

        UIImageView *topImage = [[[UIImageView alloc]initWithFrame:CGRectMake(4, 6, 72, 72)]autorelease];
        topImage.image = [UIImage imageNamed:@"bg_image_top.png"];
       // CGAffineTransform transform1 = CGAffineTransformMakeRotation(-1.5707963); 
       // topImage.transform =transform1;
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
