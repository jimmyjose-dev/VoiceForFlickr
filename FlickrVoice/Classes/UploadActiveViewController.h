//
//  UploadActiveViewController.h
//  FlickerVoice
//
//  Created by Varshyl3 on 14/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCommon.h"
//#import "CommonViewController.h"
#import "QueueView.h"
#import "CustomPageControl.h"
@interface UploadActiveViewController : UIViewController<QueueViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
{
    IBOutlet UINavigationBar *navController;
    IBOutlet UIBarButtonItem *barbtn;
    IBOutlet UIButton *selectAllBtn;
    UIButton *leftButton;
    NSMutableArray *localQueueArray;
    iCommon *icommonObj;
    float startX;
    IBOutlet UIScrollView *queueScrollView;
    BOOL isSelected;
    NSMutableArray *dataArrayToUpload;
    NSMutableArray *arrayForIndexes;
    NSMutableArray *queueViewArray;
   // NSMutableArray *localQueueArray;
    BOOL isSelectAll;
    BOOL isUploaded;
    NSMutableDictionary *dict;
    int objIndex;
    
    IBOutlet UIView *popupView;
    IBOutlet CustomPageControl *pageCtrl;
    BOOL pageControlUsed;
    NSMutableData *mutableDataToUpload;
    
}

@property(nonatomic,retain) NSMutableArray *localQueueArray;
@property(nonatomic,retain) NSMutableArray *dataArrayToUpload;
@property(nonatomic,retain) NSMutableArray *arrayForIndexes;

-(IBAction)showMenu;
-(IBAction)uploadDataOnFlicker;
-(IBAction)selectAllObject;
-(IBAction)rigthBatBtnTapped;
-(IBAction)signOutBtnTapped;
- (IBAction)changePage:(id)sender;
@end
