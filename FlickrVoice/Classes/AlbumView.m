//
//  AlbumView.m
//  FlickerVoice
//
//  Created by Varshyl3 on 14/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlbumView.h"

@implementation AlbumView
@synthesize containerView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 95, 85)];
        bgImageView.image = [UIImage imageNamed:@"bg_album.png"];
        [self addSubview:bgImageView];
        self.containerView = [[UIImageView alloc]initWithFrame:CGRectMake(17, 4, 69, 74)];
        self.containerView.image = [UIImage imageNamed:@"album_cover_container.png"];
        [self addSubview:self.containerView];
        UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(17,4, 69, 74)];
        topImage.image = [UIImage imageNamed:@"bg_album_cover_top.png"];
        [self addSubview:topImage];
        checkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, 25, 33, 27)];
        checkImageView.image = [UIImage imageNamed:@"check.png"];
        [self addSubview:checkImageView];
        checkImageView.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkUncheckAlbum)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)checkUncheckAlbum
{
    NSLog(@"Image Tapped");
    if(isSelected){
        NSLog(@"Not Selected");
        checkImageView.hidden = YES;
        isSelected = NO;
    }else{
        NSLog(@"Selected");
        checkImageView.hidden = NO;
        isSelected = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
