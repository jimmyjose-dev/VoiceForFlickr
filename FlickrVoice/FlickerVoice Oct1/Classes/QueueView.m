//
//  QueueView.m
//  FlickerVoice
//
//  Created by Varshyl3 on 13/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QueueView.h"

@implementation QueueView
@synthesize containerView;
@synthesize selectedQueueArray,checkImageView,isSelected,isShowPreview;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.selectedQueueArray = [[NSMutableArray alloc]init];
        isSelected = NO;
        isShowPreview = NO;
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 84, 84)];
        bgImageView.image = [UIImage imageNamed:@"bg_image.png"];
        [self addSubview:bgImageView];
        self.containerView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 3, 74, 74)];
        self.containerView.image = [UIImage imageNamed:@"image_container.png"];
        [self addSubview:self.containerView];
        UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 3, 74, 74)];
        topImage.image = [UIImage imageNamed:@"bg_image_top.png"];
        [self addSubview:topImage];
        self.checkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, 25, 33, 27)];
        checkImageView.image = [UIImage imageNamed:@"check.png"];
        [self addSubview:checkImageView];
        checkImageView.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkUncheckImage:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
        
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SelectImageForPreview:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapRecognizer];
        
    }
    return self;
}

-(void)checkUncheckImage:(id)sender
{
  /*  if(isShowPreview){
        
        [delegate showPreviewForIndex:[sender view].tag];
        return;
    }*/
    
    NSLog(@"Image Tapped");
    if(isSelected){
        NSLog(@"Not Selected");
        [delegate removeObjectForIndex:[sender view].tag];
        checkImageView.hidden = YES;
        isSelected = NO;
    }else{
        NSLog(@"Selected");
        checkImageView.hidden = NO;
        [delegate addObjectForIndex:[sender view].tag];
        isSelected = YES;
    }
}
-(void)SelectImageForPreview:(id)sender
{
    NSLog(@"Double Tap detected");
    [delegate showPreviewForIndex:[sender view].tag];
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
