//
//  UploadImageAndVoiceViewontroller.m
//  SnapAndRun
//
//  Created by Varshyl iMac on 27/08/12.
//  Copyright (c) 2012 VarshylMobile. All rights reserved.
//
#define OBJECTIVE_FLICKR_API_KEY @"f968369b7b7c00d3f9ce7a3505d3f566"
#define OBJECTIVE_FLICKR_API_SHARED_SECRET @"ce717d4e251387b8"
//NSString *kStoredAuthTokenKeyName = @"FlickrOAuthToken";
#import "UploadImageAndVoiceViewontroller.h"
#import "SnapAndRunAppDelegate.h"
#import "SnapAndRunViewController.h"
#import "SBJson.h"
#import "iCommon.h"
#import "AfterImageUploading.h"
#import "MBProgressHUD.h"
@interface UploadImageAndVoiceViewontroller()
{
    IBOutlet UIImageView *finalImgView;
    
}
-(IBAction)nextBtnTapped;
@end
@implementation UploadImageAndVoiceViewontroller

@synthesize progressView,activityIndicator,mutableData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)dealloc
{
    [audioRecorder release];
    [audioPlayer release];
    [imageArray release];
    [flickrRequest release];
    [mutableData release];
    [super dealloc];
}
-(IBAction) takeImageButtonClicked
{
	UIimgPicker.delegate=self; 
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIimgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentModalViewController:UIimgPicker animated:YES];
		
	}
    
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Camera is not available" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
		[alert show];
        [alert release];
	}
	
}

-(IBAction) photoGalleryButtonClicked
{
    UIimgPicker.delegate=self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
		UIimgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		[self presentModalViewController:UIimgPicker animated:YES];
		
	}
    
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"image is not available" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
		[alert show];
        [alert release];
	}
    
    
}
-(IBAction)setImage{
    
   // for (int k = 0; k<[imageArray count]; k++) {
        
    NSData *imageData= UIImageJPEGRepresentation([imageArray objectAtIndex:0], 0.1);

    NSData *audioData = [NSData dataWithContentsOfFile:[soundFileURL path]];
    //NSLog(@"Audio Data %@",audioData);
  
    char header[] = {'\xde','\xad','\xde','\xad'};
    int ImageSize =[imageData length];
    
    NSUInteger paddingLen = (([imageData length]/8)+1)*8 - [imageData length] + 4;
    NSLog(@"size %d paddingLength %d",ImageSize,paddingLen);
    
    char padding[paddingLen];
    for (NSUInteger i =0; i<paddingLen; ++i) {
        padding[i] = '\x00';
    }
    self.mutableData = [[NSMutableData alloc] initWithData:imageData];
    [mutableData appendBytes:padding length:paddingLen];
    [mutableData appendBytes:header length:4];
    
    [mutableData appendData:audioData];
    
   // NSLog(@"Image and Sound %@",mutableData);
    
  /*  int audioSize = [mutableData length];
    NSLog(@"Audion Size %d",audioSize);
    int paddingLenToAudio = (([mutableData length]/8)+1)*8-[mutableData length]+4;
    char audioPadding [paddingLenToAudio];
    for(int i=0;i<paddingLenToAudio;++i){
        audioPadding[i] = '\x00';
    }
    [mutableData appendBytes:audioPadding length:paddingLenToAudio];
    [mutableData appendBytes:header length:4];*/
    
    //NSLog(@"final data to upload %@",mutableData);
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{	// Get picked image from info dictionary 
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	// Put that image onto the screen in our image view 
	[imageView setImage:image];
    [imageArray addObject:image];
    
    NSLog(@"imageArray %@",imageArray);
	// Take image picker offc the screen -
	// you must call this dismiss method 
	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle
- (OFFlickrAPIRequest *)flickrRequest
{
    if (!flickrRequest) {
        flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[SnapAndRunAppDelegate sharedDelegate].flickrContext];
        flickrRequest.delegate = self;
		flickrRequest.requestTimeoutInterval = 60.0;
    }
    
    return flickrRequest;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self flickrRequest];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    auth_token = [defaults objectForKey:@"FlickrOAuthToken"];
    NSLog(@"Auth token %@",auth_token);
    UIimgPicker =[[UIImagePickerController alloc]init];
    
    imageArray=[NSMutableArray new];
    
    playButton.enabled = NO;
    stopButton.enabled = NO;
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"sound.caf"];
    
    soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    
    NSError *error = nil;
    
    audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [audioRecorder prepareToRecord];
    }

  
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:@"updateUI" object:nil];
}

-(IBAction) recordAudio
{
    if (!audioRecorder.recording)
    {
        playButton.enabled = NO;
        stopButton.enabled = YES;
        [audioRecorder record];
    }
}
-(IBAction)stop
{
    stopButton.enabled = NO;
    playButton.enabled = YES;
    recordButton.enabled = YES;
    
    if (audioRecorder.recording)
    {
        [audioRecorder stop];
    } else if (audioPlayer.playing) {
        [audioPlayer stop];
    }
}
-(IBAction) playAudio
{
    if (!audioRecorder.recording)
    {
        stopButton.enabled = YES;
        recordButton.enabled = NO;
        
        if (audioPlayer)
            [audioPlayer release];
        NSError *error;
        
        audioPlayer = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:audioRecorder.url
                       error:&error];
        
        audioPlayer.delegate = self;
        
        if (error)
            NSLog(@"Error: %@",
                  [error localizedDescription]);
        else
            [audioPlayer play];
    }
}

-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
    recordButton.enabled = YES;
    stopButton.enabled = NO;
}
-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}
-(void)audioRecorderDidFinishRecording:
(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
}
-(void)audioRecorderEncodeErrorDidOccur:
(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}

- (IBAction)uploadImage {
   /* NSString *urlString =[NSString stringWithFormat:@"http://api.flickr.com/services/upload/"];
                          
    NSLog(@"entrred in uplaod");
  
    NSString* escapedUrlString =[urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	 
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:escapedUrlString]];
	[request setHTTPMethod:@"POST"];
	
	NSError *error=nil;
	
	
	NSString *boundary = @"---------------------------14737809831466499882746641448";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	
	
	NSMutableData *body = [NSMutableData data];
	for (int k =0; k<[imageArray count]; k++) {
		
		NSString *imgName=[NSString stringWithFormat:@"%d.jpg",k];
        UIImage *image = [imageArray objectAtIndex:k];
        NSData *imageData = UIImageJPEGRepresentation(image, .1);
        NSLog(@"Image Name %@",imgName);
     
        
       NSString *uploadSig = [NSString stringWithFormat:@"%@api_key%@auth_token%@", OBJECTIVE_FLICKR_API_SHARED_SECRET, OBJECTIVE_FLICKR_API_KEY, auth_token];
                
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Disposition: form-data; name=\"api_key\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", OBJECTIVE_FLICKR_API_KEY] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Disposition: form-data; name=\"auth_token\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];    
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",auth_token] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Disposition: form-data; name=\"api_sig\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",uploadSig] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photo\"; filename=\"%@\"\r\n",imgName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:mutableData];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        }
    
	[request setHTTPBody:body];
	
	NSData      *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
   	NSString	*returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"Response string  %@",returnString);
	*/
    
    
   // SnapAndRunViewController *snapVCObj = [[SnapAndRunViewController alloc]init];
    
    iCommon *icommonObj = [[iCommon alloc]init];
    if(mutableData == nil)
    {
        NSLog(@"Please Select image");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please Select Image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [alert release];
        return;
    }
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:txtTitle.text,@"title",txtTag.text,@"tags",txtDescription.text,@"description",@"1",@"is_public", nil];
    
  //  [icommonObj startUpload:[UIImage imageWithData:mutableData]];
   // [icommonObj startUpload:[UIImage imageWithData:self.mutableData ] withParams:dictionary];
    
    [icommonObj startUpload:mutableData withParams:dictionary];
    
    //[[[SnapAndRunAppDelegate sharedDelegate]activityIndicator] startAnimating];
   // [self.view addSubview:[[SnapAndRunAppDelegate sharedDelegate]progressView]];
    
    [self.activityIndicator startAnimating];
    progressView.center = self.view.center;
    [self.view addSubview:progressView];
    NSLog(@"Upload Image");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)nextBtnTapped
{
    AfterImageUploading *afterImgUploadingVC = [[AfterImageUploading alloc]init];
    [self.navigationController pushViewController:afterImgUploadingVC animated:YES];
}

-(void)updateUI
{
   // if()
   // NSLog(@)
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //[self.activityIndicator removeFromSuperview];
   // [self.progressView removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
