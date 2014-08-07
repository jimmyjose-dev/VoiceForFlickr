//
//  CustomPageControl.m
//  FlickerVoice
//
//  Created by Varshyl3 on 04/10/12.
//  Copyright (c) 2012 VarshylMobile. All rights reserved.
//

#import "CustomPageControl.h"

@implementation CustomPageControl
@synthesize activeImage;
@synthesize inactiveImage;
/*- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
*/
-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    activeImage = [UIImage imageNamed:@"scroller_active.png"];
    inactiveImage = [UIImage imageNamed:@"scroller_inactive.png"];
    return self;
}

-(void)updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage)
            dot.image = activeImage;
        else
            dot.image = inactiveImage;
    }
}

-(void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}


@end
