//
//  UploadImageAndVoiceViewontroller.h
//  SnapAndRun
//
//  Created by Varshyl iMac on 27/08/12.
//  Copyright (c) 2012 VarshylMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ObjectiveFlickr.h"

@interface UploadImageAndVoiceViewontroller : UIViewController<UIImagePickerControllerDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate,OFFlickrAPIRequestDelegate,UITextFieldDelegate>

{
    UIImagePickerController *UIimgPicker;
    IBOutlet UIImageView *imageView;
    
    NSMutableArray *imageArray;
  //    UIImageView *image;
    
    IBOutlet UIScrollView *scroll;
    
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
    UIButton *playButton;
    UIButton *recordButton;
    UIButton *stopButton;
    NSURL *soundFileURL;
    NSMutableData * mutableData;

    NSString *auth_token;
    OFFlickrAPIRequest *flickrRequest;
    
    IBOutlet UITextField *txtTitle;
    IBOutlet UITextField *txtTag;
    IBOutlet UITextField *txtDescription;
    
}
@property(nonatomic,retain)IBOutlet UIView *progressView;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain) NSMutableData * mutableData;
@end
