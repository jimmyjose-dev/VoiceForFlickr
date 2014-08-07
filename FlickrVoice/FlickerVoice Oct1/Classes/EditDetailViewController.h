//
//  EditDetailViewController.h
//  FlickerVoice
//
//  Created by Varshyl3 on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import "ObjectiveFlickr.h"

@interface EditDetailViewController : UIViewController<AVAudioRecorderDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate>
{
    IBOutlet UIImageView *thumbImage;
    NSMutableDictionary *detailsToUpdate;
    NSData *imageData;
    NSMutableData *responseData;
    AVAudioPlayer *player;
    AVAudioRecorder *audioRecorder;
    
    IBOutlet UITextField *txtTitle;
    IBOutlet UITextField *txtTag;
    IBOutlet UITextView *txtDescription;
    IBOutlet UIView *editAudioView;
    IBOutlet UIImageView *imagePreview;
    IBOutlet UIButton *recordButton;
    IBOutlet UIView *editDetailView;
    IBOutlet UIView *signOutView;
    NSString *photoId;
    
    NSMutableData *mutableDataTOUpload;
    
    NSData *seperateImgData;
    NSData *audioData;
    NSURL *soundFileURL;
    int testRecord;
    
    NSString *strTitle;
    NSString *strTags;
    NSString *strDescription;
    int proVal;
    int found;
    
    NSString *str_url_t;
    NSString *str_url_o;
    int editBtnTapp;
    NSMutableData *responseImagedata;
    
    OFFlickrAPIRequest *req;
    OFFlickrAPIContext *flickrContext;
	OFFlickrAPIRequest *flickrRequest;
}
@property(nonatomic,retain) NSMutableDictionary *detailsToUpdate;
@property(nonatomic,retain) NSData *imageData;
@property(nonatomic,retain) NSData *audioData;
@property(nonatomic,retain) NSData *seperateImgData;

@property(nonatomic,retain) NSString *photoId;

@property(nonatomic,retain) NSString *strTitle;
@property(nonatomic,retain) NSString *strTags;
@property(nonatomic,retain) NSString *strDescription;

@property(nonatomic,retain) NSString *str_url_t;
@property(nonatomic,retain) NSString *str_url_o;
@property(nonatomic,retain) NSMutableData *responseImagedata;

-(IBAction)cancel;
-(IBAction)doneBtnTapped;
-(IBAction)editAudioBtnTapped;
-(IBAction)playBtnTapped;
-(IBAction)cancelEditAudioBtnTapped;
-(IBAction)doneAudioBtnTapped;
-(IBAction)showPopover;
-(IBAction)signOutBtnTapped;
@end
