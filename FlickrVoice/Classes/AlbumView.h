//
//  AlbumView.h
//  FlickerVoice
//
//  Created by Varshyl3 on 14/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumView : UIView
{
    UIImageView *containerView;
    UIImageView *checkImageView;
    BOOL isSelected;
}
@property(nonatomic,retain)UIImageView *containerView;
@end
