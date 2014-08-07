//
//  HomeViewController.m
//  FlickerVoice
//
//  Created by Varshyl3 on 12/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#define OBJECTIVE_FLICKR_API_KEY @"f968369b7b7c00d3f9ce7a3505d3f566"
#import "HomeViewController.h"
#import "iCommon.h"
#import "QueueView.h"
#import "AlbumView.h"
#import "UploadActiveViewController.h"
#import "QueueExpandedViewController.h"
#import "SnapAndRunAppDelegate.h"
#import "MBProgressHUD.h"
#import "JSON.h"
#import "CustomTableCell.h"
#import "EditDetailViewController.h"
#import "SwitchSlider.h"
@interface HomeViewController ()
{
    NSString *visibleMode;
    IBOutlet UIView *progressView;
    IBOutlet UIActivityIndicatorView *indicatorView;
    float startX;
    int sliderValue;
    BOOL pageControlUsed;
    
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIView *viewForQueue;
    IBOutlet UIView *viewForPhotoStream;
    
    IBOutlet UIView *viewForPreview;
    IBOutlet UIImageView *previewImage;
    IBOutlet UIImageView *thumbImage;
    
    IBOutlet UIButton *queueExpandBtn;
    IBOutlet UIButton *streamExpandBtn;
    IBOutlet UIPageControl *queuePageCtrl;
    
    IBOutlet UIScrollView *previewScrollView;
    IBOutlet UITextField *txtEditTitle;
    IBOutlet UITextField *txtEditTag;
    IBOutlet UITextView *txtEditDesc;
    
    IBOutlet UIView *editEmbedView;
    
    BOOL isQueueExpanded;
    int isAudioAvailable;
    int viewIndex;
    int numberOfPages;
    int k;
    
    BOOL displayKeyboard;
    
    NSString *currentView;
    
    NSMutableDictionary *detaiOfData;
    NSMutableDictionary *imgInfoDict;
    
    //UISlider *slider;
}
@end
static NSUInteger kNumberOfPages = 1;
@implementation HomeViewController
@synthesize slider,dummyArray;
//@synthesize imageArray,imageDataArray,imageDict,imagePickerController,responseData;

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
    snapView = nil;                             //.h outlets
    snapImageViwe = nil;
    recordButton = nil;
    playButton = nil;
    detailView = nil;
    txtTitle = nil;
    txtTag = nil;
    txtViewDescription = nil;
    scorollview = nil;
    accessoryView = nil;
    popOverView = nil;
    addDetailSubview = nil;
    editBtn = nil;
    viewForEditDetail = nil;
    editDetailSubView = nil;
    editAudioBtn = nil;
    editRecordingBtn = nil;
    editSoundView = nil;
    editImageView = nil;
    table = nil;
    snpaViewSuperView = nil;
    viewForGridView = nil;
    lblQueue = nil;
    lblPhotoStream = nil;
    lblAudio = nil;
    lblDetail = nil;
    lblAddQueue = nil;
    lblUpload = nil;
    lblGrigPhStream = nil;
    
    pageControl = nil;                          //.m outlets
    viewForQueue = nil;
    viewForPhotoStream = nil;
    viewForPreview = nil;
    previewImage = nil;
    thumbImage = nil;
    queueExpandBtn = nil;
    streamExpandBtn = nil;
    queuePageCtrl = nil;
    previewScrollView = nil;
    txtEditTitle = nil;
    txtEditTag = nil;
    txtEditDesc = nil;
    editEmbedView = nil;
    imagePickerController = nil;
    [imagePickerController release];
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    snapView = nil;                             //.h outlets
    snapImageViwe = nil;
    recordButton = nil;
    playButton = nil;
    detailView = nil;
    txtTitle = nil;
    txtTag = nil;
    txtViewDescription = nil;
    scorollview = nil;
    accessoryView = nil;
    popOverView = nil;
    addDetailSubview = nil;
    editBtn = nil;
    viewForEditDetail = nil;
    editDetailSubView = nil;
    editAudioBtn = nil;
    editRecordingBtn = nil;
    editSoundView = nil;
    editImageView = nil;
    table = nil;
    snpaViewSuperView = nil;
    viewForGridView = nil;
    lblQueue = nil;
    lblPhotoStream = nil;
    lblAudio = nil;
    lblDetail = nil;
    lblAddQueue = nil;
    lblUpload = nil;
    lblGrigPhStream = nil;
    
    pageControl = nil;                          //.m outlets
    viewForQueue = nil;
    viewForPhotoStream = nil;
    viewForPreview = nil;
    previewImage = nil;
    thumbImage = nil;
    queueExpandBtn = nil;
    streamExpandBtn = nil;
    queuePageCtrl = nil;
    previewScrollView = nil;
    txtEditTitle = nil;
    txtEditTag = nil;
    txtEditDesc = nil;
    editEmbedView = nil;
    imagePickerController = nil;
    

    
    
}
-(void)backTORootView
{
  //  NSLog(@"Hide all views on homeView");
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    snpaViewSuperView.hidden = YES;
    snapView.hidden = YES;
    detailView.hidden = YES;
    
   // viewForEditDetail.hidden = YES;
    //viewForPreview.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //NSLog(@"view will appear");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUIAfterImageUploaded:) name:@"AllImageUploadedNotification" object:nil];

   /* NSLog(@"View Will Appear");
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"];
    NSString *strId =  [userId stringByReplacingOccurrencesOfString:@"%40" withString:@"@"];
    NSLog(@"User Id %@",strId);
    
    NSString *searchUrlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&user_id=%@&per_page=15&extras=original_format,o_dims,views,url_o&format=json&nojsoncallback=1", OBJECTIVE_FLICKR_API_KEY,strId];
    
    NSString* escapedUrlString = [searchUrlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
	[request setURL:[NSURL URLWithString:escapedUrlString]];
    
    [[NSURLConnection alloc]initWithRequest:request delegate:self];
        
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];*/             //TODO uncomment it
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:@"updateUI" object:nil];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUIAfterImageUploaded) name:@"AllImageUploadedNotification" object:nil];
    
    /*if([queueArray count]>0 && (snapView.hidden))
    {
        viewForGridView.hidden = YES;
    }*/

	displayKeyboard = NO;
}

-(void) viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)updateUI
{
    //NSLog(@"update ui by nsnotification center");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [snpaViewSuperView setHidden:YES];
    [detailView setHidden:YES];
    [snapView setHidden:YES];
}
-(void)viewDidDisappear:(BOOL)animated 
{
    [super viewDidDisappear:animated];
   // NSLog(@"ViewDidDisapear on HomeViewController");
    
  /*  [imageArray release];
    [imageDataArray release];
    [imageDict release];
    [imagePickerController release];
    [responseData release];
    [audioPlayer release];
    [audioRecorder release];
    [queueViewsArray release];
    [dummyArray release];*/
    
}
-(void)dealloc
{
    NSLog(@"Dealloc on HomeViewController");
    [imageArray release];
    [imageDataArray release];
    [imageDict release];
    [imagePickerController release];
    [responseData release];
    [audioPlayer release];
    [audioRecorder release];
    [queueViewsArray release];
    [dummyArray release];
    [gridView release];
    [customSwitch release];
    [customSwitchOnEditView release];
    [slider release];
    [mutableData release];
    [detaiOfData release];
    [super dealloc];
    
}
-(void)setLabelsFont
{
    UIFont *font = [UIFont fontWithName:@"Gotham-Medium_0" size:10.0];
    lblQueue.font = font;
    lblAudio.font = font;
    lblAddQueue.font = font;
    lblDetail.font = font;
    lblUpload.font = font;
    lblPhotoStream.font = font;
    lblGrigPhStream.font = font;
}

-(void)valueChanged:(id)switchSlider :(BOOL)switchValue
{
   // NSLog(@"switch value %d",switchValue);
    if(switchValue){
        visibleMode = @"0" ;
    }else{
        visibleMode = @"1";
    }
   // NSLog(@"Visible mode %@",visibleMode);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imgInfoDict = [[NSMutableDictionary alloc]init];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"];
    NSString *strId =  [userId stringByReplacingOccurrencesOfString:@"%40" withString:@"@"];
    iCommon *icommonObj = [[iCommon alloc]init];
    [icommonObj getUserInfoForId:strId];
    icommonObj.delegate = self;
    
    
    viewForGridView.frame = CGRectMake(0, 0, 320, 300);
    [self.view addSubview:viewForGridView];
    gridView = [[AQGridView alloc]init];
    gridView.frame = CGRectMake(10, 55, 300, 290);
    gridView.scrollEnabled = YES;
    gridView.delegate = self;
    gridView.dataSource = self;
    [viewForGridView addSubview:gridView];
    //viewForGridView.hidden = YES;
    
    
    customSwitch = [[CustomSwitch alloc]initWithFrame:CGRectMake(105, 240, 94, 33) onLabelText:@"On" offLabelText:@"Off"];    //Add Custom Switch on DetailView
    // [customSwitch setClipsToBounds:YES];
    //NSLog(@"Switch value %d",customSwitch.on);
    customSwitch.delegate = self;
    [detailView addSubview:customSwitch];
    
    customSwitchOnEditView = [[CustomSwitch alloc]initWithFrame:CGRectMake(105, 266, 94, 33) onLabelText:@"On" offLabelText:@"Off"];    //Add Custom Switch on DetailView
   // NSLog(@"Switch value %d",customSwitchOnEditView.on);
    customSwitchOnEditView.delegate = self;
    [editEmbedView addSubview:customSwitchOnEditView];
   // NSLog(@"frame %@",NSStringFromCGRect(customSwitchOnEditView.frame));
    
    
  
    [self setLabelsFont];
    
    isAudioAvailable = 0;
    table.rowHeight = 100;
    table.frame = CGRectMake(110, -50, 100, 300);
     CGAffineTransform transform = CGAffineTransformMakeRotation(-1.5707963);  
    table.transform = transform;
    
    [editDetailSubView setClipsToBounds:YES];
    responseData = [NSMutableData new];
    isQueueExpanded = NO;
   // [txtViewDescription setInputAccessoryView:toolBar];
    viewIndex = 0;
    k = 0;
    currentView = @"AddDetail";
    pageControl.numberOfPages = kNumberOfPages;
    
   // queueScrollView.contentSize = CGSizeMake(albumScrollView.frame.size.width *kNumberOfPages, albumScrollView.frame.size.height);
    
   // albumScrollView.contentSize = CGSizeMake(albumScrollView.frame.size.width *kNumberOfPages, albumScrollView.frame.size.height);
    pageControl.currentPage = 0;
    
   /* float startXAlbum = 7;
    for(int i=0;i<15;i++){
        AlbumView *albumView = [[AlbumView alloc]initWithFrame:CGRectMake(startXAlbum, 5, 95, 85)];
        albumView.containerView.image = [UIImage imageNamed:@"mmImg.jpg"];
        [albumScrollView addSubview:albumView];
        startXAlbum = startXAlbum+95+10;
    }
    albumScrollView.contentSize = CGSizeMake(startXAlbum, 0);*/
   // albumScrollView.contentSize = CGSizeMake(500, 0);
   
    startX = 15;
    isOn = YES;
    
   // queueScrollView.contentSize = CGSizeMake(500,0);
    
    imageDict = [NSMutableDictionary new];
    imageDataArray = [[NSMutableArray alloc]init];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 35, 32)];
    [backBtn addTarget:self action:@selector(backTORootView) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"btn_home.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[[UIBarButtonItem alloc]initWithCustomView:backBtn]autorelease];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(15, 320, 280,26)];
    self.slider.backgroundColor = [UIColor clearColor];
    [slider setMinimumTrackImage:[UIImage imageNamed:@"bg_steps_strip2.png"] forState:UIControlStateNormal];
    [slider setMaximumTrackImage:[UIImage imageNamed:@"bg_steps_strip2.png"] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage imageNamed:@"knob_active1.png"] forState:UIControlStateNormal];
    
    slider.minimumValue = 0.0;
    slider.maximumValue = 3.0;
    slider.continuous = YES;
    [slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventTouchUpInside];
    [snapView addSubview:slider];

    
    
    self.dummyArray = [[NSMutableArray alloc]init];
    
    //[self setStripViewInitial];
    self.title = @"";
    
    // Do any additional setup after loading the view from its nib.
    
    imagePickerController =[[UIImagePickerController alloc]init];
    imageArray = [[NSMutableArray alloc]init];
    snpaViewSuperView.hidden = YES;
    snapView.hidden = YES;
    
    //Audio Recoder Code
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

    detailView.frame = CGRectMake(0, 48, 320, 412);
    [self.view addSubview:detailView];
    detailView.hidden = YES;
    [scorollview setContentSize:CGSizeMake(0, 400)];
    [txtTag setInputAccessoryView:accessoryView];
    
    txtViewDescription.text = @"Description";
    txtViewDescription.textColor = [UIColor lightGrayColor];
    
    txtEditDesc.text = @"Description";
    txtEditDesc.textColor = [UIColor lightGrayColor];
    
  //  albumTable.backgroundColor = [UIColor clearColor];

    [popOverView setHidden:YES];
    
  //  NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"];
   // NSString *strId =  [userId stringByReplacingOccurrencesOfString:@"%40" withString:@"@"];
   // NSLog(@"User Id %@",strId);
    imagesArray = [[NSMutableArray alloc]init];

    /*
    NSLog(@"isProValue %d",isProValue);
    NSString *searchUrlString;
    if(isProValue == 1){                    //Request for pro account user
        
        searchUrlString = [[NSString alloc ]initWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&user_id=%@&per_page=15&extras=original_format,o_dims,views,url_o&format=json&nojsoncallback=1", OBJECTIVE_FLICKR_API_KEY,strId];
        
    }else if(isProValue == 0){           //Request for non pro account user
        
        searchUrlString = [[NSString alloc]initWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&user_id=%@&per_page=15&extras=views,url_m&format=json&nojsoncallback=1", OBJECTIVE_FLICKR_API_KEY,strId];
    }
    
    NSString* escapedUrlString = [searchUrlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
	[request setURL:[NSURL URLWithString:escapedUrlString]];
    
    [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];   */

    //Fetch Image From Flicker
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

   
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait|| interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


#pragma Mark - IBAction methods

-(IBAction)cameraButtonTapped
{
    imagePickerController.delegate=self; 
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentModalViewController:imagePickerController animated:YES];
		
	}else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Camera is not available" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
		[alert show];
        [alert release];
	}
	
    
}

-(IBAction)gallaryButtonTapped
{
   
    imagePickerController.delegate=self; 

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        
		imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentModalViewController:imagePickerController animated:YES];
       
	}else {
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"image is not available" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
		[alert show];
        [alert release];
	}

}

-(IBAction)uploadActiveButtonTapped
{
    UploadActiveViewController *uploadActiveVC = [[UploadActiveViewController alloc]init];
    uploadActiveVC.queueArray = self.queueArray;
    [self.navigationController presentModalViewController:uploadActiveVC animated:YES];
    [uploadActiveVC release];
}

#pragma Mark - UIImagePickerController delegate method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{	
    viewForGridView.hidden = YES;
   // txtAlbum.text = @"";
    txtTitle.text = @"";
    txtTag.text = @"";
    txtViewDescription.text = @"Description";
    detaiOfData = [[NSMutableDictionary alloc]init];
    isAudioAvailable = 0;
    mutableData = [[NSMutableData alloc]init];
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	// Put that image onto the screen in our image view 
    
    [self dismissModalViewControllerAnimated:YES];
	[snapImageViwe setImage:image];
    
    [imageArray addObject:image];
    NSData *imageData= UIImageJPEGRepresentation(image, 0.1);
    //[detaiOfData setObject:imageData forKey:@"Image"];
   // mutableData = [[NSMutableData alloc] initWithData:imageData];
    [mutableData appendData:imageData];
    
    char header[] = {'\xde','\xad','\xde','\xad'};
    int ImageSize =[mutableData length];
    
    NSUInteger paddingLen = (([mutableData length]/8)+1)*8 - [mutableData length] + 4;
   // NSLog(@"size %d paddingLength %d",ImageSize,paddingLen);
    
    char padding[paddingLen];
    for (NSUInteger i =0; i<paddingLen; ++i) {
        padding[i] = '\x00';
    }
    [mutableData appendBytes:padding length:paddingLen];
    [mutableData appendBytes:header length:4];
    
    
    slider.value = 0.0;
    snpaViewSuperView.hidden = NO;
    snapView.hidden = NO;
    currentView = @"AddDetail";
    [table reloadData];
	

}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController.navigationItem setTitle:@""];
}

-(IBAction)recordButtonTapped
{
    if(isProValue == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"You are not a pro user of Flicker" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
   // NSLog(@"Recoreding Start");
  
    if (!audioRecorder.recording){
        [recordButton setImage:[UIImage imageNamed:@"btn_stop.png"] forState:UIControlStateNormal];
        [audioRecorder record];
    }else if(audioRecorder.recording){
        [recordButton setImage:[UIImage imageNamed:@"btn_record.png"] forState:UIControlStateNormal];
        [audioRecorder stop];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Do you sure to add this audio" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        alert.tag = 202;
        [alert show];
        [alert release];
    }
   
}
-(IBAction)playButtonTapped
{
   // NSLog(@"Play Audio");
    if (!audioRecorder.recording)
    {
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

#pragma Mark - AudioPlayer Delegate Method
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
   // recordButton.enabled = YES;
   // playButton.enabled = NO;
}
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    
}
-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}


/*-(void)setStripViewInitial
{
    [addAudioBtn setImage:nil forState:UIControlStateNormal];
    [addDetailBtn setImage:nil forState:UIControlStateNormal];
    [addToQueueBtn setImage:nil forState:UIControlStateNormal];
    [uploadBtn setImage:nil forState:UIControlStateNormal];
}
*/
-(void)addAudioBtnTapped    //Append Image and audio data
{
    //[self setStripViewInitial];
   // [addAudioBtn setImage:[UIImage imageNamed:@"knob_active.png"] forState:UIControlStateNormal];
    
    //NSData *imageData= UIImageJPEGRepresentation([imageArray objectAtIndex:0], 0.1);
    
    NSData *audioData = [NSData dataWithContentsOfFile:[soundFileURL path]];
   /* 
    char header[] = {'\xde','\xad','\xde','\xad'};
    int ImageSize =[mutableData length];
    
    NSUInteger paddingLen = (([mutableData length]/8)+1)*8 - [mutableData length] + 4;
    NSLog(@"size %d paddingLength %d",ImageSize,paddingLen);
    
    char padding[paddingLen];
    for (NSUInteger i =0; i<paddingLen; ++i) {
        padding[i] = '\x00';
    }
    [mutableData appendBytes:padding length:paddingLen];
    [mutableData appendBytes:header length:4];*/
    
    [mutableData appendData:audioData];
    isAudioAvailable = 1;
    
   // NSLog(@"Complete Data %@",mutableData);
}

-(void)addDetailBtnTapped
{
    //[self setStripViewInitial];
    currentView = @"AddDetail";
    snpaViewSuperView.hidden = YES;
    snapView.hidden = YES;
    popOverView.hidden = YES;
    visibleMode = @"1";
   // [addDetailBtn setImage:[UIImage imageNamed:@"knob_active.png"] forState:UIControlStateNormal];
    snpaViewSuperView.hidden = NO;
    [detailView setHidden:NO];
    customSwitch.on = NO;
   // txtAlbum.enabled = NO;
    
  //  txtAlbum.text = @"";
    txtTitle.text = @"";
    txtTag.text = @"";
    txtViewDescription.text = @"Description";
}
-(void)addToQueueBtnTapped
{
   // [self setStripViewInitial];
   // [addToQueueBtn setImage:[UIImage imageNamed:@"knob_active.png"] forState:UIControlStateNormal];
    //NSLog(@"Add to Queue");
}
-(void)uploadBtnTapped
{
   // NSLog(@"Upload btn Tapped");
    NSString *user = [SnapAndRunAppDelegate sharedDelegate].flickrUserName;
   // NSLog(@"User %@",user);
    if(user == NULL){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please Lgin First" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setTag:101];
        [alert show];
        [alert release];
        return;
       // NSLog(@"return from here");
    }
    NSString *sig = [[NSUserDefaults standardUserDefaults]objectForKey:@"Signature"];
   // NSLog(@"Signature %@",sig);
  //  [self setStripViewInitial];
  //  [uploadBtn setImage:[UIImage imageNamed:@"knob_active.png"] forState:UIControlStateNormal];
    
    iCommon *icommonObj = [[iCommon alloc]init];
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:txtTitle.text,@"title",txtTag.text,@"tags",txtViewDescription.text,@"description",visibleMode,@"is_public", nil];
    [icommonObj startUpload:mutableData withParams:dictionary];
    [dictionary release];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[icommonObj release];
}

#pragma Mark - Method For DetailView

/*-(IBAction)addAlbumBtnTapped
{
    txtAlbum.enabled = YES;
    [txtAlbum becomeFirstResponder];
}
 */
-(IBAction)doneButtonTapped
{
   // NSLog(@"Mutable Data on done btn %@",mutableData);
    detailView.hidden = YES;
    snpaViewSuperView.hidden = YES;
    snapView.hidden = YES;
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:txtTitle.text,@"title",txtTag.text,@"tags",txtViewDescription.text,@"description",visibleMode,@"is_public", nil];
    //NSLog(@"Data on done Button Tapped %@",dictionary);
   // NSDictionary *detailDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:mutableData,@"Data",dictionary,@"Params",[NSNumber numberWithInt:isAudioAvailable],@"CheckForAudio", nil];
    
    [detaiOfData setValue:[NSNumber numberWithInt:isAudioAvailable] forKey:@"CheckForAudio"];
    
   // NSData *imageData = [[queueArray objectAtIndex:[sender tag]] objectForKey:@"Data"];
    char header[] = {'\xde','\xad','\xde','\xad'};
    NSData *headerData = [[NSData alloc]initWithBytes:header length:4];
    if(isAudioAvailable == 1){
        int location1 = 0;
       
    
        for(int i = 0;i<[mutableData length];i=i+4)
        {
            NSRange range = NSMakeRange(i,4);
            NSData *d1 = [mutableData subdataWithRange:range];
           // NSLog(@"Split Data %@",d1);
        
            if([d1 isEqualToData:headerData])
            {
                NSRange range = {(i),[d1 length]};
                location1 = range.location-location1;
                //NSLog(@"range of d1 %d,%d",range.location,range.length);
                break;
            }
        }
    
        // NSLog(@"location 1 %d",location1);
        // NSData *imgdata = [mutableData subdataWithRange:NSMakeRange(0, ([mutableData length]-location1-8))];  
        NSData *imgdata = [mutableData subdataWithRange:NSMakeRange(0, location1)]; 
       // NSLog(@"Set Image Data %@",imgdata);
        [detaiOfData setObject:imgdata forKey:@"ImageData"];
        
    }else{
        // [mutableData appendData:headerData];
         [detaiOfData setObject:mutableData forKey:@"ImageData"];
    }
    
    [detaiOfData setObject:mutableData forKey:@"Data"];
    [detaiOfData setObject:dictionary forKey:@"Params"];
    
    
    [self.queueArray addObject:detaiOfData];
  //  NSLog(@"Count of Queue Elements %d",[self.queueArray count]);
    numberOfPages = ([queueViewsArray count]/3)+1;
    queueScrollView.contentSize = CGSizeMake(queueScrollView.frame.size.width *numberOfPages, queueScrollView.frame.size.height);

    [txtViewDescription resignFirstResponder];
    [txtTitle resignFirstResponder];
    [txtTag resignFirstResponder];
   // [txtAlbum resignFirstResponder];
    [self setImageOnQueue];
    [self reloadScrollView];
}
-(IBAction)uploadButtonTapped
{
    
}

-(IBAction)showAlbumBtntapped
{
    if(popOverView.hidden){
         popOverView.hidden = NO;
    }else{
        popOverView.hidden = YES;
    }
}

-(IBAction)switchAction
{
    if(isOn){
       // NSLog(@"Off");
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
       // switchImage.frame = CGRectMake(163, 230, 36, 35);
        [UIView commitAnimations];
        visibleMode = @"0";
        isOn = NO;
    }else{
       // NSLog(@"On");
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
       // switchImage.frame = CGRectMake(105, 230, 36, 35);
        [UIView commitAnimations];
        visibleMode = @"1";
        isOn = YES;
    }
}

-(IBAction)detailUploadBtnTapped
{
    NSLog(@"Start Uploading by Detail View");
    iCommon *icommonObj = [[iCommon alloc]init];
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:txtTitle.text,@"title",txtTag.text,@"tags",txtViewDescription.text,@"description",visibleMode,@"is_public", nil];
    [icommonObj startUpload:mutableData withParams:dictionary];
    
  //  [indicatorView startAnimating];
  //  progressView.center = self.view.center;
   // [self.view addSubview:progressView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


-(IBAction)queueExpanded
{
    //NSLog(@"No of views %d",[queueViewsArray count]);
    if(isQueueExpanded){
         numberOfPages = ([queueViewsArray count]/3)+1;
        queueScrollView.contentSize = CGSizeMake(queueScrollView.frame.size.width *numberOfPages, queueScrollView.frame.size.height);

        [queueExpandBtn setImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
        [viewForPhotoStream setHidden:NO];
        viewForQueue.frame = CGRectMake(0, 10, 320, 198);
        [queueScrollView setFrame:CGRectMake(0, 45, 320, 104)];
        [queuePageCtrl setFrame:CGRectMake(0, 160, 320, 36)];
        
        float startX1 = 15;
        for(int i=0;i<[queueViewsArray count];i++){
            QueueView *qView = [queueViewsArray objectAtIndex:i];
            qView.frame = CGRectMake(startX1, 5, 84, 84);
            startX1 = startX1+84+20;
        }

        isQueueExpanded = NO;
    }else{
        viewIndex = 0;
        numberOfPages = ([queueViewsArray count]/9)+1;
        queueScrollView.contentSize = CGSizeMake(queueScrollView.frame.size.width *numberOfPages, queueScrollView.frame.size.height);

        [queueExpandBtn setImage:[UIImage imageNamed:@"btn_minus.png"] forState:UIControlStateNormal];
        [viewForPhotoStream setHidden:YES];
        viewForQueue.frame = CGRectMake(0, 10, 320, 390);
        [queueScrollView setFrame:CGRectMake(0, 45, 320, 280)];
        [queuePageCtrl setFrame:CGRectMake(0, 318, 320, 36)];
        
        float startX1 = 15;
        float startY1 = 5;
        
        
        for(int i = 0;i<[queueViewsArray count];i++){
            viewIndex++;
            QueueView *queView = [queueViewsArray objectAtIndex:i];
            queView.frame = CGRectMake(startX1, startY1, 84, 84);
            
            if(viewIndex % 3 == 0 && viewIndex%9 != 0){
                
                int a = viewIndex-3;
                QueueView *qview = [queueViewsArray objectAtIndex:a];
                startX1 = qview.frame.origin.x;
                //NSLog(@"Change Y here");
                startY1 = startY1+84+5;
                continue;
            }
            if(viewIndex % 9 == 0){
                
                startX1 = startX1+84+20;
                startY1 = 5;
                continue;
            }
            
            startX1 = startX1+84+20;
            
        }
             
       /* for (int i =0; i<[queueViewsArray count]; i++) {
             QueueView *queView = [queueViewsArray objectAtIndex:i];
            queView.frame = CGRectMake(startX1, startY1, 84, 84);
            startY1=startY1+84+10;
            if (!((i+1)%3)) {
                startY1=5;
                startX1=startX1+84+20;
            }
            
        }*/
        
        isQueueExpanded = YES;
    }
    
   // albumScrollView.hidden = YES;
   // [queueScrollView setFrame:CGRectMake(0, 64, 320, 275)];
   
    /*QueueExpandedViewController *queueExpandedVC = [[QueueExpandedViewController alloc]init];
    queueExpandedVC.queueArray = self.queueArray;
    [self.navigationController pushViewController:queueExpandedVC animated:YES];*/
}

-(IBAction)hideGridViewBtnTapped
{
    viewForGridView.hidden = YES;
    viewForQueue.hidden = NO;
    viewForPhotoStream.hidden = NO;
    [table reloadData];
}
#pragma Mark - TextField Delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField {
   // Field = textField;
	return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
        
}

#pragma Mark - TextView Delegate Method
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
   // NSLog(@"Text view editing start");
    if([currentView isEqualToString:@"AddDetail"])
    {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        CGRect rect = [addDetailSubview frame];
        rect.origin.y -= 90; 
        
       // NSLog(@"Frame1 %f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
        
        addDetailSubview.frame = rect;
        [UIView commitAnimations];
        
    }else if([currentView isEqualToString:@"EditDetail"]){
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        CGRect rect = [editEmbedView frame];
        rect.origin.y -= 116; 
        
        //NSLog(@"Frame1 %f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
        
        editEmbedView.frame = rect;
        [UIView commitAnimations];
    }
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if([currentView isEqualToString:@"AddDetail"])
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        CGRect rect = [addDetailSubview frame];
        rect.origin.y += 90; 
        //NSLog(@"Frame2 %f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);

        addDetailSubview.frame = rect;
        [UIView commitAnimations];
    }
    if([currentView isEqualToString:@"EditDetail"]){
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        CGRect rect = [editEmbedView frame];
        rect.origin.y += 116; 
        //NSLog(@"Frame2 %f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
        
        editEmbedView.frame = rect;
        [UIView commitAnimations];
    }
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Description";
        [textView resignFirstResponder];
    }

}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Description";
        [textView resignFirstResponder];
    }

}

/*#pragma Mark - TableView Delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dummyArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [dummyArray objectAtIndex:indexPath.row];
    UIImageView *separatorLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height, cell.frame.size.width, 1)];
    separatorLine.image = [UIImage imageNamed:@"separator_dropdown.png"];
    [cell.contentView addSubview:separatorLine];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    txtAlbum.text = [dummyArray objectAtIndex:indexPath.row];
    popOverView.hidden = YES;
}
*/
#pragma Mark - Seach Bar Delegate Method
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    [searchBar becomeFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchBar.text];
    NSArray *searchedArray = [dummyArray filteredArrayUsingPredicate:predicate];
    self.dummyArray = (NSMutableArray*)searchedArray;
    
   // [albumTable reloadData];
    //NSLog(@"Dummy array %@",searchedArray);
}


/*-(void)setImageOnQueue
{
    NSLog(@"Queue array count %d",[queueArray count]);
    int count = [queueArray count];
    NSDictionary *dictionary = [[self.queueArray objectAtIndex:count-1]objectForKey:@"Params"];
    NSLog(@"Data %@",[[self.queueArray objectAtIndex:count-1]objectForKey:@"Data"]);
    NSLog(@"Detail %@",dictionary);
    QueueView *queueView = [[QueueView alloc]initWithFrame:CGRectMake(startX, 5, 84, 84)];
    NSData *imageData = [[self.queueArray objectAtIndex:count-1]objectForKey:@"Data"];
    queueView.containerView.image = [[UIImage alloc]initWithData:imageData];
    [queueScrollView addSubview:queueView];
    startX = startX+84+20;
  
}*/

-(void)editAudio
{
    editedData = [NSMutableData new];
    [editedData appendData:selectedImageData];
    NSData *audioData = [NSData dataWithContentsOfFile:[soundFileURL path]];
    
    char header[] = {'\xde','\xad','\xde','\xad'};
    int ImageSize =[editedData length];
    
    NSUInteger paddingLen = (([editedData length]/8)+1)*8 - [editedData length] + 4;
    //NSLog(@"size %d paddingLength %d",ImageSize,paddingLen);
    
    char padding[paddingLen];
    for (NSUInteger i =0; i<paddingLen; ++i) {
        padding[i] = '\x00';
    }
    [editedData appendBytes:padding length:paddingLen];
    [editedData appendBytes:header length:4];
    
    [editedData appendData:audioData];
    isAudioAvailable = 1;
   // mutableData = editedData;
 //   NSLog(@"Data After edit %@",mutableData);
    
}
#pragma Mark - AlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101){
        if(buttonIndex == 0){
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    //if(alertView.tag = 202){
       // NSLog(@"alert tag %d",[alertView tag]);
        if(buttonIndex == 0){
            //NSLog(@"Audio Added");
            if([currentView isEqualToString:@"AddDetail"]){
                [self addAudioBtnTapped];
            }else if([currentView isEqualToString:@"EditDetail"]){
                [self editAudio];
            }
        }
    
    
   // }
    
    /*if(alertView.tag = 201){
        NSLog(@"alert tag %d",[alertView tag]);
        if(buttonIndex == 0){
            [self editAudio];
        }
    }*/
}


#pragma Mark Change the Slider Value

-(void)sliderValueChanged
{
    int a = round([slider value]);
    float value = (float)floor(a);
   // NSLog(@"value %.02f",value);
   // NSLog(@"a %d and floor a %f",a,floorf(a));
    if(a>slider.value ||a<slider.value){
         slider.value = value;
        if(a==1){
            [self addDetailBtnTapped];
        }
        if(a == 2){
            [self doneButtonTapped];
        }
        if(a==3){
            [self uploadBtnTapped];
        }
    }
}



#pragma Mark - Paging

- (IBAction)changePage:(id)sender
{
    int pNo = queuePageCtrl.currentPage;
    //NSLog(@"Page NO %d",pNo);
    CGRect frame = queueScrollView.frame;
    frame.origin.x = frame.size.width * pNo;
    frame.origin.y = 0;
    [queueScrollView scrollRectToVisible:frame animated:YES];
   // [albumScrollView scrollRectToVisible:frame animated:YES];
    
    pageControlUsed = YES;
}

#pragma Mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}


-(void)showPreviewForIndex:(NSUInteger)index
{
    //NSLog(@"Show Preview for Index %d",index);
  
    [self.view addSubview:viewForPreview];

    CGFloat currentX = 0.0f;

    for(int i=0;i<[queueArray count];i++){
        
        UIImageView *previewImageView = [[UIImageView alloc]initWithFrame:CGRectMake(currentX, 0, 320, 460)];
        NSData *imageData = [[queueArray objectAtIndex:i]objectForKey:@"Data"];
        previewImageView.image = [UIImage imageWithData:imageData];
      //  previewImageView.contentMode = UIViewContentModeScaleAspectFit;
        UIButton *editDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [editDetailBtn setFrame:CGRectMake(currentX+270, 30, 39, 40)];
        [editDetailBtn setImage:[UIImage imageNamed:@"btn_edit.png"] forState:UIControlStateNormal];
        [editDetailBtn setTag:i];
        [editDetailBtn addTarget:self action:@selector(editDescBtnTapped:) forControlEvents:UIControlEventTouchUpInside]; 
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setFrame:CGRectMake(currentX+270, 75, 39, 40)];
        [deleteBtn setImage:[UIImage imageNamed:@"btn_delete.png"] forState:UIControlStateNormal];
        [deleteBtn setTag:i];
        [deleteBtn addTarget:self action:@selector(deleteBtnTapped:) forControlEvents:UIControlEventTouchUpInside]; 
        
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [playBtn setFrame:CGRectMake(currentX+120, 180, 78, 67)];
        [playBtn setImage:[UIImage imageNamed:@"btn_audio.png"] forState:UIControlStateNormal];
        [playBtn setTag:i];
        
      
        [playBtn addTarget:self action:@selector(playBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        //[previewImageView addSubview:editDetailBtn];
        currentX += previewImageView.frame.size.width;
        [previewScrollView addSubview:previewImageView];
        [previewScrollView addSubview:editDetailBtn];
        [previewScrollView addSubview:deleteBtn];
        [previewScrollView addSubview:playBtn];
    }
    previewScrollView.contentSize = CGSizeMake(currentX, 460);
    CGRect rect = CGRectMake(320*index, 0, 320, 460);
    [previewScrollView scrollRectToVisible:rect animated:YES];
    
}

-(void)playBtnTapped:(id)sender
{
    NSData *imageData = [[queueArray objectAtIndex:[sender tag]] objectForKey:@"Data"];
    char header[] = {'\xde','\xad','\xde','\xad'};
    NSData *headerData = [[NSData alloc]initWithBytes:header length:4];
    
    int headerLocation = 0;
    int found = 0;
    for(int i=[imageData length]-4;i>=0;i = i-4){
        if(found == 1){
            break;
        }
        NSRange range = NSMakeRange(i,4);
        NSData *d2 = [imageData subdataWithRange:range];
        if([d2 isEqualToData:headerData]){
            
            NSRange range = {(i),[d2 length]};
            headerLocation = range.location;
            found++;
            
        }
    }
    NSData *audioData = [imageData subdataWithRange:NSMakeRange(headerLocation+4, ([imageData length]-headerLocation-4))];
    
    
    NSError *error = nil;
    audioPlayer = [[AVAudioPlayer alloc]initWithData:audioData error:&error];
    
    if (!error) {
        [audioPlayer play];
    }
    else {
        NSLog(@"error %@",error);
    }

    
}


-(void)dummyMethod
{
    NSLog(@"Dummy Method Called");
}


-(void)editDescBtnTapped:(id)sender
{
    NSLog(@"Edit Detail method called");
    currentView = @"EditDetail";
    editIndex = [sender tag];
   // NSLog(@"Sender Tag %d",[sender tag]);
   // NSData *imageData1    =  [[queueArray objectAtIndex:[sender tag]]objectForKey:@"Image"];
   // NSLog(@"Image data %@",imageData1);
    
    NSData *imageData    =  [[queueArray objectAtIndex:[sender tag]]objectForKey:@"Data"];
   // NSLog(@"Image Data %@",imageData);
    NSDictionary *params =  [[queueArray objectAtIndex:[sender tag]]objectForKey:@"Params"];
    
    int check = [[[queueArray objectAtIndex:[sender tag]]objectForKey:@"CheckForAudio"]intValue];
    
    if(check == 0){
        
        [editAudioBtn setTitle:@"Add Voice Message" forState:UIControlStateNormal];
        
    }else if(check == 1){
        
        [editAudioBtn setTitle:@"Edit Voice Message" forState:UIControlStateNormal];
    }
    editAudioBtn.tag = [sender tag];
    thumbImage.image = [UIImage imageWithData:imageData];
  //  thumbImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:viewForEditDetail];
    txtEditTitle.text   =   [params valueForKey:@"title"];
    txtEditTag.text     =   [params valueForKey:@"tags"];
    
    if([[params valueForKey:@"description"]isEqualToString:@"Description"]){
        txtEditDesc.textColor = [UIColor lightGrayColor];
    }else{
        txtEditDesc.textColor = [UIColor blackColor];
    }
    
    txtEditDesc.text    =   [params valueForKey:@"description"];
    //NSLog(@"is public %@",[params valueForKey:@"is_public"]);
    if([[params valueForKey:@"is_public"] isEqualToString:@"0"]){
        customSwitchOnEditView.on = YES;
    }
    editSoundView.hidden = YES;
}

-(void)deleteBtnTapped:(id)sender
{
    //NSLog(@"sender Tag %d",[sender tag]);
    [queueArray removeObjectAtIndex:[sender tag]];
   // [queueViewsArray removeObjectAtIndex:[sender tag]];
    QueueView *qView = [queueViewsArray objectAtIndex:[sender tag]];
    [qView removeFromSuperview];
    [queueViewsArray removeObjectAtIndex:[sender tag]];
  //  [self setImageOnQueue];
    [viewForPreview removeFromSuperview];
    [self reloadScrollView];
}

-(void)reloadScrollView
{
    //float startX1 = 15;
    numberOfPages = ([queueViewsArray count]/3)+1;
    queueScrollView.contentSize = CGSizeMake(queueScrollView.frame.size.width *numberOfPages, queueScrollView.frame.size.height);
    startX = 15;
    for(int i=0;i<[queueViewsArray count];i++){
        QueueView *qView = [queueViewsArray objectAtIndex:i];
        [qView setFrame:CGRectMake(startX, 5, 84, 84)];
        startX = startX+84+20;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"Touch began");
    [super touchesBegan:touches withEvent:event];
    [txtViewDescription resignFirstResponder];
    [txtTitle resignFirstResponder];
    [txtTag resignFirstResponder];
    [txtEditTag resignFirstResponder];
    [txtEditTitle resignFirstResponder];
    [txtEditDesc resignFirstResponder];
   
}

-(IBAction)editDoneBtnTapped
{
   // NSLog(@"Mutable Data on edit done button %@",mutableData);
    int location1 = 0;
    char header[] = {'\xde','\xad','\xde','\xad'};
    NSData *headerData = [[NSData alloc]initWithBytes:header length:4];
    
    for(int i = 0;i<[mutableData length];i=i+4)
    {
        NSRange range = NSMakeRange(i,4);
        NSData *d1 = [mutableData subdataWithRange:range];
      //  NSLog(@"Split Data %@",d1);
        
        if([d1 isEqualToData:headerData])
        {
            NSRange range = {(i),[d1 length]};
            location1 = range.location-location1;
            //NSLog(@"range of d1 %d,%d",range.location,range.length);
            break;
        }
    }
    
    // NSLog(@"location 1 %d",location1);
    // NSData *imgdata = [mutableData subdataWithRange:NSMakeRange(0, ([mutableData length]-location1-8))];  
    NSData *imgdata = [mutableData subdataWithRange:NSMakeRange(0, location1)];  
    [detaiOfData setObject:imgdata forKey:@"ImageData"];

   // NSData *imageData = [[queueArray objectAtIndex:editIndex]objectForKey:@"Data"];
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:txtEditTitle.text,@"title",txtEditTag.text,@"tags",txtEditDesc.text,@"description",visibleMode,@"is_public", nil];
    NSDictionary *detailDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:mutableData,@"Data",imgdata,@"ImageData",dictionary,@"Params", [NSNumber numberWithInt:isAudioAvailable],@"CheckForAudio",nil];
    [queueArray replaceObjectAtIndex:editIndex withObject:detailDictionary];
    [viewForEditDetail removeFromSuperview];
    [viewForPreview removeFromSuperview];
}

-(IBAction)editCancelBtnTapped
{
    [viewForEditDetail removeFromSuperview];
    [viewForPreview removeFromSuperview];
}



#pragma Mark - Edit Audio Actions Methods
-(IBAction)editAudioBtnTapped:(id)sender
{
    customSwitchOnEditView.hidden = YES;
    NSData *imgData    =  [[queueArray objectAtIndex:[sender tag]]objectForKey:@"ImageData"];
    selectedImageData = imgData;
    editImageView.image = [UIImage imageWithData:selectedImageData];
    [editSoundView setHidden:NO];
}
-(IBAction)editAudioDoneBtnTapped
{
    customSwitchOnEditView.hidden = NO;
    mutableData = editedData;
  //  NSLog(@"Edited data %@",mutableData);
    [editSoundView setHidden:YES];
}
-(IBAction)editAudioCancelBtnTapped
{
    customSwitchOnEditView.hidden = NO;
    [editSoundView setHidden:YES];
}

-(IBAction)editAudioRecordBtnTapped
{
    NSLog(@"Recoreding on Edit audio View Start");
    
    if(isProValue == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"You are not a pro user of Flicker" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }

    if (!audioRecorder.recording){
        [editRecordingBtn setImage:[UIImage imageNamed:@"btn_stop.png"] forState:UIControlStateNormal];
        [audioRecorder record];
    }else if(audioRecorder.recording){
        [editRecordingBtn setImage:[UIImage imageNamed:@"btn_record.png"] forState:UIControlStateNormal];
        [audioRecorder stop];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Do you sure to add this audio" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        alert.tag = 201;
        [alert show];
        [alert release];
    }

}

//Delegate methods of QueueView
-(void)addObjectForIndex:(NSUInteger)index
{
    
}
-(void)removeObjectForIndex:(NSUInteger)index{
    
}

#pragma Mark - NSURLConnection Delegate method
#pragma Mark - NSURLConnection delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    // NSLog(@"Data %@",data);
    [responseData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {		
	[connection release];
    NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
   // NSLog(@"Response %@",[responseString JSONValue]);
    NSDictionary  *dictionary = [responseString JSONValue];
    NSLog(@"Dictionary %@",dictionary);
    pageNo = [[[dictionary valueForKey:@"photos"]valueForKey:@"page"]intValue];
    totalPages = [[[dictionary valueForKey:@"photos"]valueForKey:@"pages"]intValue];
 //   NSLog(@"Rsponse String %@",dictionary);
    
    
    [imagesArray addObjectsFromArray:[[dictionary valueForKey:@"photos"] valueForKey:@"photo"]];
    //if(qu)
   // [gridView reloadData];
    
    if([queueArray count]>0){
       // NSLog(@"If");
        viewForGridView.hidden = YES;
        [table reloadData];
    }else{
       // NSLog(@"Else");
        viewForGridView.hidden = NO;
        [gridView reloadData];
    }
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma Mark - TableView Delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [imagesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"Index %d",indexPath.row);
    static NSString *cellIdentifier = @"CellIdentifier";
    CustomTableCell *cell = (CustomTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = (CustomTableCell*)[[CustomTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    CGAffineTransform transform = CGAffineTransformMakeRotation(+1.5707963);  
    cell.cellImageView.transform = transform;

    // cell.textLabel.text = @"a";
    //cell.cellImageView.image = [UIImage imageNamed:@"mmImg.jpg"];
    
    NSMutableDictionary *imageDataDict = [[NSMutableDictionary alloc]init];
    [imageDataDict setObject:cell.cellImageView forKey:@"imageView"];
    
    
   /* if(isProValue == 1){
        [imageDataDict setObject:[[imagesArray objectAtIndex:indexPath.row] valueForKey:@"url_o"] forKey:@"ImageId"];
    }else if(isProValue == 0){
        [imageDataDict setObject:[[imagesArray objectAtIndex:indexPath.row] valueForKey:@"url_m"] forKey:@"ImageId"];
    }*/
    
    [imageDataDict setObject:[[imagesArray objectAtIndex:indexPath.row] valueForKey:@"url_t"] forKey:@"ImageId"];

    
    //[MBProgressHUD showHUDAddedTo:cell animated:YES];
    
   /* if (indexPath.row==[imagesArray count]-1) {
        
        
        if (pageNo<=totalPages) {
            pageNo = pageNo+1;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *userId = [defaults objectForKey:@"UserId"];
            NSString *strId =  [userId stringByReplacingOccurrencesOfString:@"%40" withString:@"@"];
            
            NSString *searchUrlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&page=%d&user_id=%@&per_page=10&extras=original_format,o_dims,views,url_o&format=json&nojsoncallback=1", OBJECTIVE_FLICKR_API_KEY,pageNo,strId];
            
            
            NSString* escapedUrlString = [searchUrlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            
            NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
            
            [request setURL:[NSURL URLWithString:escapedUrlString]];
            
            [[NSURLConnection alloc]initWithRequest:request delegate:self];
            
            
        }
        else {
        }
        
        
    }
    */
    //[imageDataDict setObject:@"UIImageView" forKey:@"Type"];
    
    [NSThread detachNewThreadSelector:@selector(fetchImageForCatlogs:) toTarget:self withObject:imageDataDict];
    //cell.lblDetail.text = @"VOIP IMAGE";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
   // DownloadAndPlayViewController *downloadAndPlayVC = [[DownloadAndPlayViewController alloc]init];
  //  downloadAndPlayVC.imageData = [imageDataArray objectAtIndex:indexPath.row];
   // downloadAndPlayVC.photoId = [[imagesArray objectAtIndex:indexPath.row]valueForKey:@"id"];
    //[self.navigationController pushViewController:downloadAndPlayVC animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *viewSelected = [[[UIView alloc] init] autorelease];
    viewSelected.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = viewSelected;
    
    EditDetailViewController *editDetailVC = [[EditDetailViewController alloc]init];
   /*
    editDetailVC.imageData = [imageDataArray objectAtIndex:indexPath.row];
    editDetailVC.photoId = [[imagesArray objectAtIndex:indexPath.row]valueForKey:@"id"];*/
    
    editDetailVC.photoId = [[imagesArray objectAtIndex:indexPath.row]valueForKey:@"id"];
    editDetailVC.str_url_t = [[imagesArray objectAtIndex:indexPath.row]valueForKey:@"url_t"];
    editDetailVC.str_url_o = [[imagesArray objectAtIndex:indexPath.row]valueForKey:@"url_o"];

    
    [self.navigationController presentModalViewController:editDetailVC animated:YES];
    [editDetailVC release];
}

-(void)fetchImageForCatlogs:(NSMutableDictionary *)obj 
{
    
	//DLog(@"Here Object  %@",obj);
	@synchronized(self){
		
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
		
        
        NSString *urlString=[obj valueForKey:@"ImageId"]; 
        
        if(![urlString isEqual:[NSNull null]])
        {
            
            if ([imageDict valueForKey:[obj valueForKey:@"ImageId"]]) {
                
                
                  [(UIActivityIndicatorView *)[obj objectForKey:@"RemovedView"] removeFromSuperview];
                [(UIImageView *)[obj objectForKey:@"imageView"] setImage:[UIImage imageWithData:[imageDict valueForKey:[obj valueForKey:@"ImageId"]]]];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                return;
            }
            
            NSData *mydata = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            
            
            if (mydata) {
                
                //  [(UIActivityIndicatorView *)[obj objectForKey:@"RemovedView"] removeFromSuperview];
                
                [(UIImageView *)[obj objectForKey:@"imageView"] setImage:[UIImage imageWithData:mydata]];//forState:UIControlStateNormal];
                [imageDataArray addObject:mydata];
                
                [imageDict setObject:mydata forKey:[obj valueForKey:@"ImageId"]];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }

            [pool drain];
        }
        
    }
}


-(void)updateUIAfterImageUploaded:(NSNotification*)notification
{
    
    NSDictionary *dict = [notification userInfo];
    NSArray *arrayToUpdateUI = [dict objectForKey:@"IndexArray"];
   // NSLog(@"Array to update UI %@",arrayToUpdateUI);
    NSArray *arr = [arrayToUpdateUI sortedArrayUsingSelector:@selector(compare:)];
    //NSLog(@"arr %@",arr);
    
    for(int i=0;i<[arr count];i++){
        int a = [[arr objectAtIndex:[arr count]-1-i]intValue];
        //NSLog(@"remove object at index %d",a);
        
        [queueArray removeObjectAtIndex:a];
                
        QueueView *qView = [queueViewsArray objectAtIndex:a];
                
        [qView removeFromSuperview];
        
        [queueViewsArray removeObjectAtIndex:a];

        [self reloadScrollView];
        
    }
    
    /*for(int i =0;i<[arrayToUpdateUI count];i++){
        NSDictionary *dataDict = [[arrayToUpdateUI objectAtIndex:i]objectForKey:@"DataToUpload"];
        if([queueArray containsObject:dataDict]){
            NSLog(@"Found and remove from here");
           // int index = [arrayToUpdateUI indexOfObject:dataDict];
          //  NSLog(@"Remove object at index %d",index);
          //  [queueArray removeObject:dataDict];
            
            int a = [[[arrayToUpdateUI objectAtIndex:i]valueForKey:@"Index"]intValue];
            NSLog(@"index to remove data %d",a);
            
            [queueArray removeObjectAtIndex:a];
            
           // [queueArray removeObject:dataDict];
            
            QueueView *qView = [queueViewsArray objectAtIndex:a];
            
           // QueueView *qview = (QueueView*)[queueScrollView viewWithTag:a];
            
            [qView removeFromSuperview];
            [queueViewsArray removeObjectAtIndex:a];
            //[queueViewsArray removeObject:qview];
            //  [self setImageOnQueue];
            [self reloadScrollView];
        }
    }
    */
   // NSLog(@"Update UI after all images uploaded");
    
}

-(void)updateUIAfterUploadImagesFromArray:(NSMutableArray *)array
{
    //NSLog(@"Array %@",array);
   // NSLog(@"Update UI method called");
}

-(void)getAccountInfo:(NSUInteger)isPro
{
   // NSLog(@"get account info 'isPro' %d",isPro);
    isProValue = isPro;
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"];
     NSString *strId =  [userId stringByReplacingOccurrencesOfString:@"%40" withString:@"@"];
   // NSLog(@"User Id %@",strId);
    imagesArray = [[NSMutableArray alloc]init];
    
    
     //NSLog(@"isProValue %d",isProValue);
     NSString *searchUrlString;
     if(isProValue == 1){                    //Request for pro account user
     
     searchUrlString = [[NSString alloc ]initWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&user_id=%@&per_page=15&extras=original_format,o_dims,views,url_o,url_m,url_t&format=json&nojsoncallback=1", OBJECTIVE_FLICKR_API_KEY,strId];
     
     }else if(isProValue == 0){           //Request for non pro account user
     
     searchUrlString = [[NSString alloc]initWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&user_id=%@&per_page=15&extras=views,url_m&format=json&nojsoncallback=1", OBJECTIVE_FLICKR_API_KEY,strId];
     }
     
     NSString* escapedUrlString = [searchUrlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
     
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
     
     [request setURL:[NSURL URLWithString:escapedUrlString]];
     
     [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
     [request release];
    
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - GridView Delegate
- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView {
    
    return [imagesArray count];
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index {
        
    static NSString * FilledCellIdentifier = @"FilledCellIdentifier";
    AQGridViewCell * cell = nil;
    ImageGridViewCell * filledCell = (ImageGridViewCell *)[aGridView dequeueReusableCellWithIdentifier: FilledCellIdentifier];
    
    if ( filledCell == nil ){
        
        CGRect cellFrame = CGRectMake(00.0, 0, 84, 84);
       
        
        filledCell = [[ImageGridViewCell alloc] initWithFrame: cellFrame
                                              reuseIdentifier: FilledCellIdentifier];
        
        filledCell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
        
    }
    filledCell.backgroundColor = [UIColor clearColor];
    
   ;
    
    NSMutableDictionary *imageDataDict = [[NSMutableDictionary alloc]init];
    [imageDataDict setObject:filledCell forKey:@"imageView"];
    
    [imageDataDict setObject:[[imagesArray objectAtIndex:index] valueForKey:@"url_t"] forKey:@"ImageId"];

    
    /*if(isProValue == 1){
        [imageDataDict setObject:[[imagesArray objectAtIndex:index] valueForKey:@"url_o"] forKey:@"ImageId"];
    }else if(isProValue == 0){
        [imageDataDict setObject:[[imagesArray objectAtIndex:index] valueForKey:@"url_m"] forKey:@"ImageId"];
    }*/

    
    cell = filledCell;
    
    [NSThread detachNewThreadSelector:@selector(fetchImageForCatlogs:) toTarget:self withObject:imageDataDict];
    
    return ( filledCell );
    
}

- (void) gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{
    //NSLog(@"Selected Index %d",index);
    
   // NSData *imgData = [[imageDataArray objectAtIndex:index] valueForKey:@"id"];
   // if ([imgInfoDict valueForKey:@"id"]) {
        
       // [dictionary removeObjectForKey:userId];
   // }
   // else {
      //  [imgInfoDict setObject:[NSNumber numberWithBool:TRUE] forKey:imgData];
   // }
    EditDetailViewController *editDetailVC = [[EditDetailViewController alloc]init];
    
  //  editDetailVC.imageData = [imageDataArray objectAtIndex:index];
    
    editDetailVC.photoId = [[imagesArray objectAtIndex:index]valueForKey:@"id"];
    editDetailVC.str_url_t = [[imagesArray objectAtIndex:index]valueForKey:@"url_t"];
    editDetailVC.str_url_o = [[imagesArray objectAtIndex:index]valueForKey:@"url_o"];
    
    [self.navigationController presentModalViewController:editDetailVC animated:YES];
    [editDetailVC release];
}

-(void)gridView:(AQGridView *)gridView didTouchDownForItemAtIndex:(NSUInteger)index
{
    
}

-(IBAction)expanStreamBtnTapped
{
    viewForQueue.hidden = YES;
    viewForPhotoStream.hidden = YES;
    viewForGridView.hidden = NO;
}
- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView{
    
    //return ( CGSizeMake(160, 160) );
    
   
        return ( CGSizeMake(100, 100) );

}



@end
