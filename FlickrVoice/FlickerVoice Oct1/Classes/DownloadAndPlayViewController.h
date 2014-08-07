//
//  DownloadAndPlayViewController.h
//  FlickerVoice
//
//  Created by Varshyl3 on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import "ObjectiveFlickr.h"
@interface DownloadAndPlayViewController : UIViewController<OFFlickrAPIRequestDelegate>
{
    IBOutlet UIImageView *imgView;
    NSData *imageData;
    NSData *audioData;
    AVAudioPlayer *player;
    NSString *photoId;
    NSMutableData *responsedata;
    
    IBOutlet UITextField *txtTitle;
    IBOutlet UITextField *txtTag;
    IBOutlet UITextField *txtDescription;
    
    NSURLConnection *connectionToDownload;
    NSURLConnection *connectionToUpdate;
    NSString *auth_token;
    NSString *api_sig;
    
    OFFlickrAPIRequest *flickerRequest;
}
@property(nonatomic,retain)     NSData   *imageData;
@property(nonatomic,retain)     NSData   *audioData;
@property(nonatomic,retain)     NSString *photoId;

-(IBAction)playAudio;
-(IBAction)updateData;
@end
