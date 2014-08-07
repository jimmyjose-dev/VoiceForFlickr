//
//  EditDetailViewController.m
//  FlickerVoice
//
//  Created by Varshyl3 on 18/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define ALPHA                   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890._&@*(),'/#$?!%:+- "
#import "EditDetailViewController.h"
#import "JSON.h"
#import "iCommon.h"
#import "MBProgressHUD.h"
#import "SnapAndRunAppDelegate.h"
#define OBJECTIVE_FLICKR_API_KEY @"f968369b7b7c00d3f9ce7a3505d3f566"

@interface EditDetailViewController ()

@end

@implementation EditDetailViewController
@synthesize detailsToUpdate;
@synthesize imageData,photoId,audioData,seperateImgData;
@synthesize strTitle,strTags,strDescription;
@synthesize str_url_t,str_url_o,responseImagedata;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    [imageData release];
    [responseData release];
    [responseImagedata release];
    
    [detailsToUpdate release];
    [photoId release];
    [audioData release];
    [seperateImgData release];
    [imagePreview release];
    [strTitle release];
    [strTags release];
    [strDescription release];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    thumbImage = nil;
    txtTitle = nil;
    txtTag = nil;
    txtDescription = nil;
    editAudioView = nil;
    imagePreview = nil;
    recordButton = nil;
    editDetailView = nil;
    imagePreview = nil;
    signOutView = nil;
    editAudioView = nil;
    editDetailView = nil;
    lblVisiblity = nil;
    tapToRecordBtn = nil;
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    signOutView.hidden = YES;
    if(isEditingData == 1){
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUI" object:self];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadViewWithEditedData" object:nil];
    }
}

- (OFFlickrAPIRequest *)flickrRequest
{
	if (!req) {
		req = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
		//req.delegate = self;		
	}
	
	return flickrRequest;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //NSLog(@"Data is %@",imageData);
 /*   int location1 = 0;
    char header[] = {'\xde','\xad','\xde','\xad'};
    NSData *headerData = [[NSData alloc]initWithBytes:header length:4];
    int foundHeader = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    proVal = [defaults integerForKey:@"isProVal"];
  //  NSLog(@"Pro value on editvc %d",proVal);
    
    if(proVal == 1){
        for(int i = 0;i<[imageData length];i=i+4)
        {
            NSRange range = NSMakeRange(i,4);
            NSData *d1 = [imageData subdataWithRange:range];
            // NSLog(@"Split Data %@",d1);
        
            if([d1 isEqualToData:headerData])
            {
                NSRange range = {(i),[d1 length]};
                location1 = range.location-location1;
                NSLog(@"range of d1 %d,%d",range.location,range.length);
                foundHeader = 1;
                break;
            }
        }
        if(foundHeader == 1){
        
            self.seperateImgData = [imageData subdataWithRange:NSMakeRange(0, location1)]; 

        }else{
            self.seperateImgData = imageData;
        }
    
        // NSLog(@"Image Data on viewDidAppear %@",seperateImgData);
        // NSLog(@"Header data %@",headerData);
    
        int headerLocation = 0;
        found = 0;
        for(int i=[imageData length]-4;i>=0;i = i-4){
            if(found == 1){
                break;
            }
            NSRange range = NSMakeRange(i,4);
            NSData *d2 = [imageData subdataWithRange:range];
            //   NSLog(@"Required Data %@",d2);
            if([d2 isEqualToData:headerData]){
            
                NSRange range = {(i),[d2 length]};
                headerLocation = range.location;
                found++;
            
            }
        }
        self.audioData = [imageData subdataWithRange:NSMakeRange(headerLocation+4, ([imageData length]-headerLocation-4))];
    }
    //NSLog(@"Audio Data %@",audioData);
  
  */
}
-(void)viewWillAppear:(BOOL)animated
{
   // NSLog(@"View Will Appear called %@",imageData);
    [super viewWillAppear:animated];
     isEditingData = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:@"updateUI" object:nil];
   

}

/*-(void)valueChanged:(id)switchSlider :(BOOL)switchValue
{
    // NSLog(@"switch value %d",switchValue);
    if(switchValue){
        checkVisibility = 0;
    }else{
        checkVisibility = 1;
    }
     NSLog(@"Visible mode %d",checkVisibility);
}*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    testRecord = 0;
    editBtnTapp = 0;
    NSLog(@"Photo Id %@",photoId);
    self.title = @"";
    lblVisiblity.hidden = YES;
   
    
   /* customSwitch = [[CustomSwitch alloc]initWithFrame:CGRectMake(105, 261, 94, 33) onLabelText:@"On" offLabelText:@"Off"];    
    // [customSwitch setClipsToBounds:YES];
    //NSLog(@"Switch value %d",customSwitch.on);
    customSwitch.delegate = self;
    [editDetailView addSubview:customSwitch];*/
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    proVal = [defaults integerForKey:@"isProVal"];
    
   // signOutView.frame = CGRectMake(190, 58 , 129, 63);
    //[self.navigationController.view addSubview:signOutView];
    signOutView.hidden = YES;
    responseData = [[NSMutableData alloc]init];

    editAudioView.hidden = YES;
    
   // thumbImage.image = [UIImage imageWithData:imageData];
    
    thumbImage.image = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str_url_t]]];
                                                                                  
    //Audio Recoder Code
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"updatedSound.caf"];
    
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
    
    NSString *urlParams = [[NSString alloc]initWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=%@&photo_id=%@&format=json&nojsoncallback=1",OBJECTIVE_FLICKR_API_KEY,photoId];
    
    
    NSString *escapedUrlString = [urlParams stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
   // NSLog(@"Url String %@",escapedUrlString);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:escapedUrlString]];
   // NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [request release];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}
-(IBAction)cancel
{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if(editBtnTapp == 0){
        [responseData setLength:0];
    }else if(editBtnTapp == 1){
        [responseImagedata setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    // NSLog(@"Data %@",data);
    if(editBtnTapp == 0){
        [responseData appendData:data];
    }else if(editBtnTapp == 1){
        [responseImagedata appendData:data];
    }
       
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {		
	[connection release];
    if(editBtnTapp == 0){
        
        NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        //  NSLog(@"response string %@",responseString);
    
        
        NSDictionary *jsonDictionary = [responseString JSONValue];
        NSLog(@"Json Dictionary %@",jsonDictionary);
        
        self.strTitle = [[[jsonDictionary objectForKey:@"photo"]valueForKey:@"title"]valueForKey:@"_content"];
        //  txtTitle.text = [[[jsonDictionary objectForKey:@"photo"]valueForKey:@"title"]valueForKey:@"_content"];
        
        if([strTitle isEqualToString:@"FlickerVoice"]){
            txtTitle.text = @"";
        }else{
            txtTitle.text = self.strTitle;

        }
    
        NSArray *tags = [[[[jsonDictionary objectForKey:@"photo"]valueForKey:@"tags"]objectForKey:@"tag"]valueForKey:@"_content"];
        NSString *tagsStr = [tags componentsJoinedByString:@" "];
        self.strTags = tagsStr;
        txtTag.text = self.strTags;
        
        self.strDescription = [[[jsonDictionary objectForKey:@"photo"]valueForKey:@"description"]valueForKey:@"_content"];
        visibility = [[[[jsonDictionary objectForKey:@"photo"]valueForKey:@"visibility"]valueForKey:@"ispublic"]intValue];
       // NSLog(@"Visibility %@",visibility);
        
        if(visibility==0){
            customSwitch.on = YES; 
        }else{
            customSwitch.on = NO;
        }
        
        if([self.strDescription isEqualToString:@""] || [self.strDescription isEqualToString:@"Description"]){
            txtDescription.text = @"Description";
            txtDescription.textColor = [UIColor lightGrayColor];
        }else{
            txtDescription.text = self.strDescription;
            txtDescription.textColor = [UIColor blackColor];
        }
        
    }else if(editBtnTapp == 1){
        
       // NSLog(@"Final response image data %@",responseImagedata);
        char header[] = {'\xde','\xad','\xde','\xad'};
        NSData *headerData = [[NSData alloc]initWithBytes:header length:4];
        int foundHeader = 0;
        int location1 = 0;
        for(int i = 0;i<[responseImagedata length];i=i+4)
        {
            NSRange range = NSMakeRange(i,4);
            NSData *d1 = [responseImagedata subdataWithRange:range];
            // NSLog(@"Split Data %@",d1);
            
            if([d1 isEqualToData:headerData])
            {
                NSRange range = {(i),[d1 length]};
                location1 = range.location-location1;
                NSLog(@"range of d1 %d,%d",range.location,range.length);
                foundHeader = 1;
                break;
            }
        }
        if(foundHeader == 1){
            
            self.seperateImgData = [responseImagedata subdataWithRange:NSMakeRange(0, location1)]; 
        //    NSLog(@"Sepeare image data %@",self.seperateImgData);
            
        }
        
        imagePreview.image = [UIImage imageWithData:self.seperateImgData];
        
        
        int headerLocation = 0;
        // int found = 0;
        for(int i=[responseImagedata length]-4;i>=0;i = i-4){
            if(found == 1){
                break;
            }
            NSRange range = NSMakeRange(i,4);
            NSData *d2 = [responseImagedata subdataWithRange:range];
            if([d2 isEqualToData:headerData]){
                
                NSRange range = {(i),[d2 length]};
                headerLocation = range.location;
                found++;
                
            }
        }
        self.audioData = [responseImagedata subdataWithRange:NSMakeRange(headerLocation+4, ([responseImagedata length]-headerLocation-4))];
      //  NSLog(@"Audio data %@",self.audioData);
         
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection Failed");
}


-(IBAction)editAudioBtnTapped       //TO edit audio data
{
   // NSLog(@"Image Data %@",imgData);
    
    if(proVal == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"You are not a pro account user" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    editBtnTapp = 1;
    self.responseImagedata = [[NSMutableData alloc]init];

  //  NSData *data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:str_url_o]];
   // NSLog(@"data %@",data);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //imagePreview.image = [[UIImage alloc]initWithData:data];
    
    editAudioView.hidden = NO;
    [[NSURLConnection alloc]initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str_url_o ]] delegate:self];
    
                                                      
   /* if(proVal == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"You are not a pro account user" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }*/
    
}
-(IBAction)playBtnTapped
{
    NSLog(@"Test Record Value %d",testRecord);
    if(testRecord == 0){
            NSError *error = nil;
    
            player = [[AVAudioPlayer alloc]initWithData:audioData error:&error];
        
            if (!error) {
                [player play];
            }
            else {
                    NSLog(@"error in if section :----%@",error);
            }
    }else if(testRecord ==1){
        NSLog(@"Play recorded audio");

        if (!audioRecorder.recording)
        {
            if (player)
                [player release];
            NSError *error;
            
            player = [[AVAudioPlayer alloc]
                           initWithContentsOfURL:audioRecorder.url
                           error:&error];
            
            player.delegate = self;
            
            if (error)
                NSLog(@"Error in else section : %@",
                      [error localizedDescription]);
            else
                [player play];
        }
    }
        
}

-(void)showAlertWithMessage:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
    return;
}

-(IBAction)doneBtnTapped
{
    iCommon *icommonObj = [[iCommon alloc]init];
    if(testRecord == 1){
        isEditingData = 1;
        [icommonObj replaceData:mutableDataTOUpload withParams:[NSDictionary dictionaryWithObjectsAndKeys:photoId,@"photo_id", nil]]; 
        testRecord = 0;
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES withMessage:@"Data Updating..."];
    }
    if(([txtTitle.text length]>0 &&(![self.strTitle isEqualToString:txtTitle.text]))||([txtDescription.text length]>0 && (![self.strDescription isEqualToString:txtDescription.text])) ){
         isEditingData = 1;
        [icommonObj updateData:[NSDictionary dictionaryWithObjectsAndKeys:photoId,@"photo_id",txtTitle.text,@"title",txtDescription.text,@"description",nil]];
       
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES withMessage:@"Data Updating..."];
    }
    if([txtTag.text length]>0 && (![self.strTags isEqualToString:txtTag.text])){
        isEditingData = 1;
        [icommonObj updateTagWithParams:[NSDictionary dictionaryWithObjectsAndKeys:photoId,@"photo_id",txtTag.text,@"tags", nil]];
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES withMessage:@"Data Updating..."];
    }
   // NSLog(@"Editing %d",isEditingData);
    
    /*if(isEditingData==1){
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES withMessage:@"Data Updating..."];

    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Edit Data First!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
       // [self dismissModalViewControllerAnimated:YES];
    }*/
    
    /*if(visibility!=checkVisibility){
        [icommonObj updateVisibility:[NSDictionary dictionaryWithObjectsAndKeys:photoId,@"photo_id",@"1",@"hidden", nil]];   //[NSString stringWithFormat:@"%d",checkVisibility]
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES withMessage:@"Data Updating..."];
    }*/
}

-(IBAction)cancelEditAudioBtnTapped
{
    editAudioView.hidden = YES;
}
-(IBAction)doneAudioBtnTapped
{
    editAudioView.hidden = YES;
}

-(IBAction)recordButtonTapped
{
    NSLog(@"Recoreding Start");
    
    if (!audioRecorder.recording){
        [recordButton setImage:[UIImage imageNamed:@"btn_stop.png"] forState:UIControlStateNormal];
        [tapToRecordBtn setImage:[UIImage imageNamed:@"bg_recorder_active.png"] forState:UIControlStateNormal];
        [audioRecorder record];
    }else if(audioRecorder.recording){
        [recordButton setImage:[UIImage imageNamed:@"btn_record.png"] forState:UIControlStateNormal];
        [tapToRecordBtn setImage:[UIImage imageNamed:@"bg_recorder_inactive.png"] forState:UIControlStateNormal];
        [audioRecorder stop];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Do you sure to add this audio" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        alert.tag = 202;
        [alert show];
        [alert release];
    }
    
}

-(void)appendAudioToImage
{
    NSLog(@"Append Audio");
    mutableDataTOUpload = [[NSMutableData alloc]initWithData:self.seperateImgData];
    NSData *audio = [NSData dataWithContentsOfFile:[soundFileURL path]];
    
    char header[] = {'\xde','\xad','\xde','\xad'};
    int ImageSize =[mutableDataTOUpload length];
    
    NSUInteger paddingLen = (([mutableDataTOUpload length]/8)+1)*8 - [mutableDataTOUpload length] + 4;
    NSLog(@"size %d paddingLength %d",ImageSize,paddingLen);
    
    char padding[paddingLen];
    for (NSUInteger i =0; i<paddingLen; ++i) {
        padding[i] = '\x00';
    }
    
    [mutableDataTOUpload appendBytes:padding length:paddingLen];
    [mutableDataTOUpload appendBytes:header length:4];
    [mutableDataTOUpload appendData:audio];
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
           
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    CGRect rect = [editDetailView frame];
    rect.origin.y -= 116; 
    editDetailView.frame = rect;
    [UIView commitAnimations];
    
    if([txtDescription.text length]==0||[txtDescription.text isEqualToString:@"Description"]){
        txtDescription.text = @"";
    }
    txtDescription.textColor = [UIColor blackColor];
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{        
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    CGRect rect = [editDetailView frame];
    rect.origin.y += 116; 
  //  NSLog(@"Frame2 %f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
        
    editDetailView.frame = rect;
    [UIView commitAnimations];
    
    if([txtDescription.text length]==0){
        txtDescription.text = @"Description";
        txtDescription.textColor = [UIColor lightGrayColor];
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  //  NSLog(@"Touch began");
    [super touchesBegan:touches withEvent:event];
    signOutView.hidden = YES;
    [txtTitle resignFirstResponder];
    [txtTag resignFirstResponder];
    [txtDescription resignFirstResponder];
       
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if(buttonIndex == 0){
        NSLog(@"Audio Added");
        testRecord = 1;

        [self appendAudioToImage];
    }
}

-(void)updateUI
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)showPopover
{
    NSLog(@"Show popover");
    if(signOutView.hidden){
        signOutView.hidden = NO;
    }else{
        signOutView.hidden = YES;
    }
}

-(IBAction)signOutBtnTapped
{
    NSLog(@"Signout on edit detail vc");
    [[SnapAndRunAppDelegate sharedDelegate] setAndStoreFlickrAuthToken:nil secret:nil];
    [self flickrRequest].sessionInfo = @"kCheckTokenStep";
    [req callAPIMethodWithGET:@"flickr.test.login" arguments:nil];

    [self dismissModalViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PopToRootViewController" object:self];
}


#pragma Mark - UITextfield Delegate method to only accept the alphanumeric char
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    unichar c;
    
    if ([string length]>0)
    {
        c = [string characterAtIndex:0];
    }
    else
    {
        
        return YES;
    }
    if([textField.text length]==0){
        if ([[NSCharacterSet letterCharacterSet] characterIsMember:c] ||[[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c])
        {
            return YES;
        }
    }else if([textField.text length]>0){
        
        if([[NSCharacterSet characterSetWithCharactersInString:ALPHA]characterIsMember:c])
        {
            return YES;
        }
    }
    return NO;
    
}

@end
