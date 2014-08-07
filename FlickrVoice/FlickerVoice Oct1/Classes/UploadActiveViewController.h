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
@protocol UploadActiveDelegate;
@interface UploadActiveViewController : UIViewController<QueueViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UINavigationBar *navController;
    IBOutlet UIBarButtonItem *barbtn;
    IBOutlet UIButton *selectAllBtn;
    UIButton *leftButton;
    NSMutableArray *queueArray;
    iCommon *icommonObj;
    float startX;
    IBOutlet UIScrollView *queueScrollView;
    BOOL isSelected;
    NSMutableArray *dataArrayToUpload;
    NSMutableArray *arrayForIndexes;
    NSMutableArray *queueViewArray;
    NSMutableArray *localQueueArray;
    BOOL isSelectAll;
    BOOL isUploaded;
    id<UploadActiveDelegate>delegate;
    
}

@property(nonatomic,retain) NSMutableArray *queueArray;
@property(nonatomic,retain) NSMutableArray *dataArrayToUpload;
@property(nonatomic,retain) NSMutableArray *arrayForIndexes;

@property(nonatomic,weak) id<UploadActiveDelegate>delegate;
-(IBAction)showMenu;
-(IBAction)uploadDataOnFlicker;
-(IBAction)selectAllObject;



@end
@protocol UploadActiveDelegate<NSObject>

@optional
-(void)updateUIAfterUploadImagesFromArray:(NSMutableArray *)array;
@end