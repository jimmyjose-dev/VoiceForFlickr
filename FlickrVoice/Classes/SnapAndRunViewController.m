//
// SnapAndRunViewController.m
//
// Copyright (c) 2009 Lukhnos D. Liu (http://lukhnos.org)
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import "HomeViewController.h"
#import "SnapAndRunViewController.h"
#import "SnapAndRunAppDelegate.h"
#import "UploadImageAndVoiceViewontroller.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomSwitch.h"
NSString *kFetchRequestTokenStep = @"kFetchRequestTokenStep";
NSString *kGetUserInfoStep = @"kGetUserInfoStep";
NSString *kSetImagePropertiesStep = @"kSetImagePropertiesStep";
NSString *kUploadImageStep = @"kUploadImageStep";

@interface SnapAndRunViewController (PrivateMethods)
{
  
}
- (void)updateUserInterface:(NSNotification *)notification;
@end


@implementation SnapAndRunViewController
- (void)viewDidUnload
{
    self.flickrRequest = nil;
    self.imagePicker = nil;
    
    self.authorizeButton = nil;
    self.authorizeDescriptionLabel = nil;
    self.snapPictureButton = nil;
    self.snapPictureDescriptionLabel = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [self viewDidUnload];
    [super dealloc];
}
-(void)valueChanged:(id)switchSlider :(BOOL)switchValue
{
    NSLog(@"switch value %d",switchValue);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    uploadPicBtn.hidden = YES;
    NSLog(@"View Didload called");
  /*  CustomSwitch *customSwitch = [[CustomSwitch alloc]initWithFrame:CGRectMake(100, 100, 94, 33) onLabelText:@"On" offLabelText:@"Off"];
   // [customSwitch setClipsToBounds:YES];
    NSLog(@"Switch value %d",customSwitch.on);
    customSwitch.delegate = self;
    customSwitch.backgroundColor = [UIColor greenColor];
    [self.view addSubview:customSwitch];*/
    
    
    imgView.layer.shadowColor = [[UIColor blackColor] CGColor];
    imgView.layer.shadowOffset = CGSizeMake(10.0f, 1);
    imgView.layer.shadowOpacity = 10.0f;
    imgView.layer.shadowRadius = 10.0f;
    imgView.clipsToBounds = NO;
    
      
   // imgView.image = [UIImage imageNamed:@""
  
 /*   UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(10, 250, 280,26)];
    [slider setMinimumTrackImage:[UIImage imageNamed:@"bg_steps_strip2.png"] forState:UIControlStateNormal];
    [slider setMaximumTrackImage:[UIImage imageNamed:@"bg_steps_strip2.png"] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage imageNamed:@"knob_active.png"] forState:UIControlStateNormal];
    [self.view addSubview:slider];*/
    
    self.title = @"";
	
	if ([[SnapAndRunAppDelegate sharedDelegate].flickrContext.OAuthToken length]) {
		authorizeButton.enabled = NO;
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInterface:) name:SnapAndRunShouldUpdateAuthInfoNotification object:nil];
}

-(void)showAlertWithMessage
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please Login Here" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self updateUserInterface:nil];
    
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInterface:) name:SnapAndRunShouldUpdateAuthInfoNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait|| interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateUserInterface:(NSNotification *)notification
{
	if ([[SnapAndRunAppDelegate sharedDelegate].flickrContext.OAuthToken length]) {		
		//[authorizeButton setTitle:@"Reauthorize" forState:UIControlStateNormal];
		//[authorizeButton setTitle:@"Reauthorize" forState:UIControlStateHighlighted];
		//[authorizeButton setTitle:@"Reauthorize" forState:UIControlStateDisabled];
		[authorizeButton setImage:[UIImage imageNamed:@"btn_reauthorize.png"] forState:UIControlStateNormal];
		
		if ([[SnapAndRunAppDelegate sharedDelegate].flickrUserName length]) {
			authorizeDescriptionLabel.text = [NSString stringWithFormat:@"You are %@", [SnapAndRunAppDelegate sharedDelegate].flickrUserName];
            [homeBtn setEnabled:YES];
          //  HomeViewController *homeVC = [[HomeViewController alloc]init];
           // [self.navigationController pushViewController:homeVC animated:YES];
		}
		else {
			authorizeDescriptionLabel.text = @"You've logged in";
		}
		
		snapPictureButton.enabled = YES;
	}
	else {
		//[authorizeButton setTitle:@"Authorize" forState:UIControlStateNormal];
		//[authorizeButton setTitle:@"Authorize" forState:UIControlStateHighlighted];
		//[authorizeButton setTitle:@"Authorize" forState:UIControlStateDisabled];
        [authorizeButton setImage:[UIImage imageNamed:@"btn_authorize.png"] forState:UIControlStateNormal];
		
		authorizeDescriptionLabel.text = @"Login to Flickr";	
        [homeBtn setEnabled:NO];
		snapPictureButton.enabled = NO;
	}
	
	if ([self.flickrRequest isRunning]) {
		[snapPictureButton setTitle:@"Cancel" forState:UIControlStateNormal];
		[snapPictureButton setTitle:@"Cancel" forState:UIControlStateHighlighted];
		[snapPictureButton setTitle:@"Cancel" forState:UIControlStateDisabled];
		authorizeButton.enabled = NO;
	}
	else {
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			[snapPictureButton setTitle:@"Snap" forState:UIControlStateNormal];
			[snapPictureButton setTitle:@"Snap" forState:UIControlStateHighlighted];
			[snapPictureButton setTitle:@"Snap" forState:UIControlStateDisabled];
			snapPictureDescriptionLabel.text = @"Use camera";
		}
		else {
			[snapPictureButton setTitle:@"Pick Picture" forState:UIControlStateNormal];
			[snapPictureButton setTitle:@"Pick Picture" forState:UIControlStateHighlighted];
			[snapPictureButton setTitle:@"Pick Picture" forState:UIControlStateDisabled];						
			snapPictureDescriptionLabel.text = @"Pick from library";
		}
		
		authorizeButton.enabled = YES;
	}
}

#pragma mark Actions

- (IBAction)snapPictureAction
{
	if ([self.flickrRequest isRunning]) {
		[self.flickrRequest cancel];
		[self updateUserInterface:nil];		
		return;
	}
	
    [self presentModalViewController:self.imagePicker animated:YES];
}

-(IBAction)uploadImageAndVoice
{
    
    UploadImageAndVoiceViewontroller *upload=[[UploadImageAndVoiceViewontroller alloc]init];
    
    [self.navigationController pushViewController:upload animated:YES];
    
}


- (IBAction)authorizeAction
{
    // if there's already OAuthToken, we want to reauthorize
    if ([[SnapAndRunAppDelegate sharedDelegate].flickrContext.OAuthToken length]) {
        [[SnapAndRunAppDelegate sharedDelegate] setAndStoreFlickrAuthToken:nil secret:nil];
    }
    
	authorizeButton.enabled = NO;
	authorizeDescriptionLabel.text = @"Authenticating...";    

    self.flickrRequest.sessionInfo = kFetchRequestTokenStep;
    [self.flickrRequest fetchOAuthRequestTokenWithCallbackURL:[NSURL URLWithString:SRCallbackURLBaseString]];
}

#pragma mark OFFlickrAPIRequest delegate methods

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret
{
    // these two lines are important
    [SnapAndRunAppDelegate sharedDelegate].flickrContext.OAuthToken = inRequestToken;
    [SnapAndRunAppDelegate sharedDelegate].flickrContext.OAuthTokenSecret = inSecret;

    NSURL *authURL = [[SnapAndRunAppDelegate sharedDelegate].flickrContext userAuthorizationURLWithRequestToken:inRequestToken requestedPermission:OFFlickrWritePermission];
    [[UIApplication sharedApplication] openURL:authURL];    
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inResponseDictionary);

    if(inRequest.sessionInfo = @"GetUserInfoSession"){
        int a = [[[inResponseDictionary objectForKey:@"person"]valueForKey:@"ispro"]intValue];
        [[NSUserDefaults standardUserDefaults]setInteger:a forKey:@"isProValue"];
    }
	if (inRequest.sessionInfo == kUploadImageStep) {
		snapPictureDescriptionLabel.text = @"Setting properties...";

        
        NSLog(@"Response From Flicker%@", inResponseDictionary);
        NSString *photoID = [[inResponseDictionary valueForKeyPath:@"photoid"] textContent];

        flickrRequest.sessionInfo = kSetImagePropertiesStep;
        [flickrRequest callAPIMethodWithPOST:@"flickr.photos.setMeta" arguments:[NSDictionary dictionaryWithObjectsAndKeys:photoID, @"photo_id", @"FlickerVoice", @"title", @"Uploaded from my iPhone/iPod Touch", @"description", nil]];        		        
	}
    else if (inRequest.sessionInfo == kSetImagePropertiesStep) {
		[self updateUserInterface:nil];		
		snapPictureDescriptionLabel.text = @"Done";
        
		[UIApplication sharedApplication].idleTimerDisabled = NO;		
        
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inError);
	if (inRequest.sessionInfo == kUploadImageStep) {
		[self updateUserInterface:nil];
		snapPictureDescriptionLabel.text = @"Failed";		
		[UIApplication sharedApplication].idleTimerDisabled = NO;

		[[[[UIAlertView alloc] initWithTitle:@"API Failed" message:[inError description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease] show];

	}
	else {
		[[[[UIAlertView alloc] initWithTitle:@"API Failed" message:[inError description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease] show];
	}
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest imageUploadSentBytes:(NSUInteger)inSentBytes totalBytes:(NSUInteger)inTotalBytes
{
	if (inSentBytes == inTotalBytes) {
		snapPictureDescriptionLabel.text = @"Waiting for Flickr...";
	}
	else {
		snapPictureDescriptionLabel.text = [NSString stringWithFormat:@"%u/%u (KB)", inSentBytes / 1024, inTotalBytes / 1024];
	}
}


#pragma mark UIImagePickerController delegate methods
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)_startUpload:(UIImage *)image
{
    NSData *JPEGData = UIImageJPEGRepresentation(image, 1.0);
    
	snapPictureButton.enabled = NO;
	snapPictureDescriptionLabel.text = @"Uploading";
	
    self.flickrRequest.sessionInfo = kUploadImageStep;
    [self.flickrRequest uploadImageStream:[NSInputStream inputStreamWithData:JPEGData] suggestedFilename:@"FlickerVoice" MIMEType:@"image/jpeg" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"is_public", nil]];
	
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	[self updateUserInterface:nil];
}

#ifndef __IPHONE_3_0
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//  NSDictionary *editingInfo = info;
#else
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
#endif

    [self dismissModalViewControllerAnimated:YES];
	
	snapPictureDescriptionLabel.text = @"Preparing...";
	
	// we schedule this call in run loop because we want to dismiss the modal view first
	[self performSelector:@selector(_startUpload:) withObject:image afterDelay:0.0];
}

#pragma mark Accesors

- (OFFlickrAPIRequest *)flickrRequest
{
    if (!flickrRequest) {
        flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[SnapAndRunAppDelegate sharedDelegate].flickrContext];
        flickrRequest.delegate = self;
		flickrRequest.requestTimeoutInterval = 60.0;
    }
    
    return flickrRequest;
}
    
-(void)getUserInfoForId:(NSString*)userId
{
        self.flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[SnapAndRunAppDelegate sharedDelegate].flickrContext];
        self.flickrRequest.delegate = self;
        self.flickrRequest.requestTimeoutInterval = 60.0;
        
        self.flickrRequest.sessionInfo = @"GetUserInfoSession";
        [self.flickrRequest callAPIMethodWithPOST:@"flickr.people.getInfo" arguments:[NSDictionary dictionaryWithObjectsAndKeys:userId,@"user_id", nil]]; 
        
}
    
-(IBAction)homeButtonTapped
{
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    [self.navigationController pushViewController:homeVC animated:YES];
}
- (UIImagePickerController *)imagePicker
{
    if (!imagePicker) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
		
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		}
    }
    return imagePicker;
}

   

#ifndef __IPHONE_3_0
- (void)setView:(UIView *)view
{
	if (view == nil) {
		[self viewDidUnload];
	}
	
	[super setView:view];
}
#endif

@synthesize flickrRequest;
@synthesize imagePicker;

@synthesize authorizeButton;
@synthesize authorizeDescriptionLabel;
@synthesize snapPictureButton;
@synthesize snapPictureDescriptionLabel;
@end
