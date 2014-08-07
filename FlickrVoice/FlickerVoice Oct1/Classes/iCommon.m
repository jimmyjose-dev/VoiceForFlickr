//
//  iCommon.m
//  FlickerVoice
//
//  Created by Varshyl3 on 06/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iCommon.h"
#import "SnapAndRunAppDelegate.h"

@implementation iCommon
@synthesize flickrRequest,delegate;
#pragma mark OFFlickrAPIRequest delegate methods

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
    // NSLog(@"Call Method to Update UI");
        NSLog(@"Response Data %s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inResponseDictionary);
    if(inRequest.sessionInfo = @"GetUserInfoSession")
    {
       // NSLog(@"Prt and dictionary %@",inResponseDictionary);
       // NSLog(@"is pro %d",[[[inResponseDictionary objectForKey:@"person"]valueForKey:@"ispro"]intValue]);
        int a = [[[inResponseDictionary objectForKey:@"person"]valueForKey:@"ispro"]intValue];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:a forKey:@"isProVal"];
        [defaults synchronize];
        [delegate getAccountInfo:a];
    }
    
	if (inRequest.sessionInfo == @"kUploadImageStep") {
		//snapPictureDescriptionLabel.text = @"Setting properties...";
        
        
       // NSLog(@"Response From Flicker%@", inResponseDictionary);
        NSString *photoID = [[inResponseDictionary valueForKeyPath:@"photoid"] textContent];
        
        flickrRequest.sessionInfo = @"kSetImagePropertiesStep";
        [flickrRequest callAPIMethodWithPOST:@"flickr.photos.setMeta" arguments:[NSDictionary dictionaryWithObjectsAndKeys:photoID, @"photo_id", @"FlickerVoice", @"title", @"Uploaded from my iPhone/iPod Touch", @"description", nil]];        		        
	}
    else if (inRequest.sessionInfo == @"kSetImagePropertiesStep") {
		        
		//[UIApplication sharedApplication].idleTimerDisabled = NO;	
          self.flickrRequest.sessionInfo = @"kSetImageTagsStep";
      
    }else if (inRequest.sessionInfo == @"kSetImageTagsStep") {
    
        
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
    self.flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[SnapAndRunAppDelegate sharedDelegate].flickrContext];
    self.flickrRequest.delegate = self;
    self.flickrRequest.requestTimeoutInterval = 60.0;
    self.flickrRequest.sessionInfo = @"kFetchRequestTokenStep";
    
    [self.flickrRequest uploadImageStream:[NSInputStream inputStreamWithData:imageData] suggestedFilename:@"FlickerVoice" MIMEType:@"image/jpeg" arguments:params];
	[UIApplication sharedApplication].idleTimerDisabled = NO;
	
}


-(void)replaceData:(NSData*)imgData withParams:(NSDictionary*)params
{
    NSLog(@"Replace Data");
    self.flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[SnapAndRunAppDelegate sharedDelegate].flickrContext];
    self.flickrRequest.delegate = self;
    self.flickrRequest.requestTimeoutInterval = 60.0;
    [self.flickrRequest replaceImageStream:[NSInputStream inputStreamWithData:imgData] suggestedFilename:@"FlickerVoice" MIMEType:@"image/jpeg" arguments:params];
    [UIApplication sharedApplication].idleTimerDisabled = NO;

}

- (void)updateData:(NSDictionary*)params
{
    NSLog(@"Update metas");
    
    self.flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[SnapAndRunAppDelegate sharedDelegate].flickrContext];
    self.flickrRequest.delegate = self;
    self.flickrRequest.requestTimeoutInterval = 60.0;
    
     self.flickrRequest.sessionInfo = @"kSetImagePropertiesStep";
    [self.flickrRequest callAPIMethodWithPOST:@"flickr.photos.setMeta" arguments:params];
    
   // [UIApplication sharedApplication].idleTimerDisabled = NO;
}


-(void)updateTagWithParams:(NSDictionary*)params
{
    NSLog(@"Update tag");
    self.flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[SnapAndRunAppDelegate sharedDelegate].flickrContext];
    self.flickrRequest.delegate = self;
    self.flickrRequest.requestTimeoutInterval = 60.0;
    
    self.flickrRequest.sessionInfo = @"kSetImageTagsStep";
    [self.flickrRequest callAPIMethodWithPOST:@"flickr.photos.setTags" arguments:params];
    
    //[UIApplication sharedApplication].idleTimerDisabled = YES;
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
