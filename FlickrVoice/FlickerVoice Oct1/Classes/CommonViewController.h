//
//  CommonViewController.h
//  FlickerVoice
//
//  Created by Varshyl3 on 14/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectiveFlickr.h"
#import "QueueView.h"
@interface CommonViewController : UIViewController<QueueViewDelegate>
{
    //IBOutlet UIScrollView *queueScrollView;
    //IBOutlet UIScrollView *albumScrollView;
    IBOutlet UIView     *popupView;
    IBOutlet UIButton   *signOutBtn;
  //  IBOutlet UIView *popOverView;

    BOOL isShowingPopup;
    OFFlickrAPIRequest *req;
    OFFlickrAPIContext *flickrContext;
	OFFlickrAPIRequest *flickrRequest;
    NSMutableArray *queueArray;
    float startX;
    IBOutlet UIScrollView *queueScrollView;
    NSMutableArray *queueViewsArray;
}
@property(nonatomic,retain) NSMutableArray *queueArray;
-(void)addQueueOnView;
-(void)addAlbumOnView;
-(void)showPopOver;
-(IBAction)signOutBtnTapped;
-(void)setImageOnQueue;
@end
