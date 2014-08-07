//
//  QueueExpandedViewController.h
//  FlickerVoice
//
//  Created by Varshyl3 on 13/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueueView.h"

@interface QueueExpandedViewController : UIViewController<QueueViewDelegate>
{
    IBOutlet UIScrollView *queueScrollView;
    IBOutlet UIImageView *imagePreview;
    IBOutlet UIView *viewForPreview;
    IBOutlet UIButton *edtitButton;
    NSMutableArray *queueArray;
    NSMutableArray *queueViews;
    NSMutableDictionary *dataToEdit;
}
@property(nonatomic,retain)NSMutableArray *queueArray;
-(IBAction)backToRootView;
-(IBAction)editBtnTapped;
@end
