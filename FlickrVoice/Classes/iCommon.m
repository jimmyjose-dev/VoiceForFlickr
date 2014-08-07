//
//  iCommon.m
//  FlickerVoice
//
//  Created by Varshyl3 on 06/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iCommon.h"
#import "SnapAndRunAppDelegate.h"
#import "MBProgressHUD.h"
@implementation iCommon
@synthesize flickrRequest,delegate;

#pragma mark OFFlickrAPIRequest delegate methods


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
                
    }
    return self;
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret
{
    // these two lines are important
    NSLog(@"Token %@",inRequestToken);
    [SnapAndRunAppDelegate sharedDelegate].flickrContext.OAuthToken = inRequestToken;
    [SnapAndRunAppDelegate sharedDelegate].flickrContext.OAuthTokenSecret = inSecret;
    
    NSURL *authURL = [[SnapAndRunAppDelegate sharedDelegate].flickrContext userAuthorizationURLWithRequestToken:inRequestToken requestedPermission:OFFlickrWritePermission];
    [[UIApplication sharedApplication] openURL:authURL];    
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"Prt");
    // NSLog(@"Call Method to Update UI");
        NSLog(@"Response Data %s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inResponseDictionary);
    if(inRequest.sessionInfo = @"GetUserInfoSession")
    {
        int a = [[[inResponseDictionary objectForKey:@"person"]valueForKey:@"ispro"]intValue];
        [delegate getAccountInfo:a];
         //[[NSNotificationCenter defaultCenter] postNotificationName:@"updateUI" object:self];
    }
    
    
	if (inRequest.sessionInfo == @"kUploadImageStep") {
        
       // NSString *photoID = [[inResponseDictionary valueForKeyPath:@"photoid"] textContent];
        flickrRequest.sessionInfo = @"kSetImagePropertiesStep";
         		        
	}
    
    /*if (inRequest.sessionInfo == @"kSetImagePropertiesStep") {
		        
        self.flickrRequest.sessionInfo = @"kSetImageTagsStep";
        NSLog(@"Update properties");
      
    }else if (inRequest.sessionInfo == @"kSetImageTagsStep") {
    
        self.flickrRequest.sessionInfo = @"kReplaceData";
        NSLog(@"Update Tags");
        
        
    }else if(inRequest.sessionInfo == @"kReplaceData"){
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        NSLog(@"Replace data");
    }*/
    
    if (inRequest.sessionInfo == @"kReplaceData") {
        
        self.flickrRequest.sessionInfo = @"kSetImageTagsStep";
        NSLog(@"Update properties");
        
    }else if (inRequest.sessionInfo == @"kSetImageTagsStep") {
        
        self.flickrRequest.sessionInfo = @"kSetImagePropertiesStep";
        NSLog(@"Update Tags");
        
        
    }else if(inRequest.sessionInfo == @"kSetImagePropertiesStep"){
        [UIApplication sharedApplication].idleTimerDisabled = NO;
       
        }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUI" object:self];

}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inError);
	if (inRequest.sessionInfo == @"kUploadImageStep") {
		//[self updateUserInterface:nil];
		//snapPictureDescriptionLabel.text = @"Failed";		
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
		//snapPictureDescriptionLabel.text = @"Waiting for Flickr...";
	}
	else {
		//snapPictureDescriptionLabel.text = [NSString stringWithFormat:@"%u/%u (KB)", inSentBytes / 1024, inTotalBytes / 1024];
	}
}


- (OFFlickrAPIRequest *)flickrRequest
{
    if (!flickrRequest) {
        flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[SnapAndRunAppDelegate sharedDelegate].flickrContext];
        flickrRequest.delegate = self;
		flickrRequest.requestTimeoutInterval = 60.0;
    }
    
    return flickrRequest;
}

-(id)init
{
	self = [super init];
    if (self != nil) {
        
        [self flickrRequest];
    }
    return self;
}

//- (void)startUpload:(UIImage *)image withParams:(NSDictionary*)params;
- (void)startUpload:(NSData *)imageData withParams:(NSDictionary*)params
{
    NSLog(@"params %@",params);
    self.flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[SnapAndRunAppDelegate sharedDelegate].flickrContext];
    self.flickrRequest.delegate = self;
    self.flickrRequest.requestTimeoutInterval = 60.0;
    self.flickrRequest.sessionInfo = @"kFetchRequestTokenStep";
    
    [self.flickrRequest uploadImageStream:[NSInputStream inputStreamWithData:imageData] suggestedFilename:@"FlickerVoice" MIMEType:@"image/jpeg" arguments:params];
	[UIApplication sharedApplication].idleTimerDisabled = NO;
	
}


-(void)replaceData:(NSData*)imgData withParams:(NSDictionary*)params                  //To Update Image Data
{
    NSLog(@"Replace Data");
    //[MBProgressHUD showHUDAddedTo:self animated:YES];
    self.flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[SnapAndRunAppDelegate sharedDelegate].flickrContext];
    self.flickrRequest.delegate = self;
    self.flickrRequest.requestTimeoutInterval = 120.0;
     self.flickrRequest.sessionInfo = @"kReplaceData";
    [self.flickrRequest replaceImageStream:[NSInputStream inputStreamWithData:imgData] suggestedFilename:@"FlickerVoice" MIMEType:@"image/jpeg" arguments:params];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    

}

- (void)updateData:(NSDictionary*)params                         //To Update Title and Descriptions
{
    NSLog(@"Update metas");
    //[MBProgressHUD showHUDAddedTo:self animated:YES];

    self.flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[SnapAndRunAppDelegate sharedDelegate].flickrContext];
    self.flickrRequest.delegate = self;
    self.flickrRequest.requestTimeoutInterval = 60.0;
    
     self.flickrRequest.sessionInfo = @"kSetImagePropertiesStep";
    [self.flickrRequest callAPIMethodWithPOST:@"flickr.photos.setMeta" arguments:params];
    
   // [UIApplication sharedApplication].idleTimerDisabled = NO;
}


-(void)updateTagWithParams:(NSDictionary*)params            //To Update Tags
{
    NSLog(@"Update tag");
    //[MBProgressHUD showHUDAddedTo:self animated:YES];

    self.flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[SnapAndRunAppDelegate sharedDelegate].flickrContext];
    self.flickrRequest.delegate = self;
    self.flickrRequest.requestTimeoutInterval = 60.0;
    
    self.flickrRequest.sessionInfo = @"kSetImageTagsStep";
    [self.flickrRequest callAPIMethodWithPOST:@"flickr.photos.setTags" arguments:params];
    
    //[UIApplication sharedApplication].idleTimerDisabled = YES;
}

-(void)updateVisibility:(NSDictionary*)params
{
    self.flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[SnapAndRunAppDelegate sharedDelegate].flickrContext];
    self.flickrRequest.delegate = self;
    self.flickrRequest.requestTimeoutInterval = 60.0;
    
    self.flickrRequest.sessionInfo = @"kSetVisibility";
    [self.flickrRequest callAPIMethodWithPOST:@"flickr.photos.setSafetyLevel" arguments:params];
}

-(void)getUserInfoForId:(NSString*)userId
{
    self.flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[SnapAndRunAppDelegate sharedDelegate].flickrContext];
    self.flickrRequest.delegate = self;
    self.flickrRequest.requestTimeoutInterval = 60.0;
    
    self.flickrRequest.sessionInfo = @"GetUserInfoSession";
    [self.flickrRequest callAPIMethodWithPOST:@"flickr.people.getInfo" arguments:[NSDictionary dictionaryWithObjectsAndKeys:userId,@"user_id", nil]]; 
    
}

@end
