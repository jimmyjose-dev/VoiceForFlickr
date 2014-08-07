//
//  CustomPageControl.h
//  FlickerVoice
//
//  Created by Varshyl3 on 04/10/12.
//  Copyright (c) 2012 VarshylMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPageControl : UIPageControl
{
    UIImage* activeImage;
    UIImage* inactiveImage;
}
@property(nonatomic, retain) UIImage* activeImage;
@property(nonatomic, retain) UIImage* inactiveImage;
@end
