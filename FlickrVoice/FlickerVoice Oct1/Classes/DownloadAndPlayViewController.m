//
//  DownloadAndPlayViewController.m
//  FlickerVoice
//
//  Created by Varshyl3 on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define OBJECTIVE_FLICKR_API_KEY @"f968369b7b7c00d3f9ce7a3505d3f566"

#import "DownloadAndPlayViewController.h"
#import "JSON.h"
#import "iCommon.h"
@interface DownloadAndPlayViewController ()

@end

@implementation DownloadAndPlayViewController
@synthesize imageData,audioData,photoId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Data %@",imageData);
    responsedata = [[NSMutableData data]retain];
    NSLog(@"Photo id %@",photoId);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    auth_token = [defaults objectForKey:@"FlickrOAuthToken"];
    NSString *userId = [defaults objectForKey:@"UserId"];
    NSString *strId =  [userId stringByReplacingOccurrencesOfString:@"%40" withString:@"@"];
    api_sig = [defaults objectForKey:@"Signature"];
   
   // NSLog(@"Complete downloaded Data %@",imageData);
    self.audioData = [[NSData alloc]init];
   // NSLog(@"Image data %@",imageData);
    imgView.image = [UIImage imageWithData:imageData];
    
    char header[] = {'\xde','\xad','\xde','\xad'};
    NSData *headerData = [[NSData alloc]initWithBytes:header length:4];
   // NSLog(@"Header data %@",headerData);
    
    int headerLocation = 0;
    int found = 0;
    for(int i=[imageData length]-4;i>=0;i = i-4){
        if(found == 2){
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
    //NSLog(@"Data to play %@",audioData);
    //NSString *urlParams = [[NSString alloc]initWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=%@&photo_id=%@&format=json&jsoncallback=1&auth_token=%@&api_sig=%@",OBJECTIVE_FLICKR_API_KEY,photoId,auth_token,api_sig];
    
    NSString *urlParams = [[NSString alloc]initWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=%@&photo_id=%@&format=json&nojsoncallback=1",OBJECTIVE_FLICKR_API_KEY,photoId];
    
 
    NSString *escapedUrlString = [urlParams stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"Url String %@",escapedUrlString);
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:escapedUrlString]];
   connectionToDownload = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    flickerRequest = [[OFFlickrAPIRequest alloc]init];
    flickerRequest.delegate = self;
    
}
-(IBAction)playAudio
{
    //NSLog(@"Play Audio %@",audioData);
    NSError *error = nil;
    player = [[AVAudioPlayer alloc]initWithData:audioData error:&error];
    
    if (!error) {
        [player play];
    }
    else {
        NSLog(@"error %@",error);
    }
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
   // NSLog(@"Data %@",data);
    NSString *responseString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"response string %@",responseString);

    if(connection == connectionToDownload){
            
        NSDictionary *jsonDictionary = [responseString JSONValue];
        NSLog(@"Json Dictionary %@",jsonDictionary);
    
        txtTitle.text = [[[jsonDictionary objectForKey:@"photo"]valueForKey:@"title"]valueForKey:@"_content"];
    
        NSArray *tags = [[[[jsonDictionary objectForKey:@"photo"]valueForKey:@"tags"]objectForKey:@"tag"]valueForKey:@"_content"];
        NSString *tagsStr = [tags componentsJoinedByString:@" "];
        txtTag.text = tagsStr;
    
        txtDescription.text = [[[jsonDictionary objectForKey:@"photo"]valueForKey:@"description"]valueForKey:@"_content"];
        }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {		
	[connection release];
   
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection Failed");
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)updateData
{
    
  /*  //NSString *urlParams = [[NSString alloc]initWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.setMeta&api_key=%@&photo_id=%@&title=%@&description=%@&format=json&nojsoncallback=1",OBJECTIVE_FLICKR_API_KEY,photoId,txtTitle.text,txtDescription.text];
    
     NSString *urlParams = [[NSString alloc]initWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.setMeta&api_key=%@&photo_id=%@&title=%@&description=%@&format=json&nojsoncallback=1&auth_token&api_sig",OBJECTIVE_FLICKR_API_KEY,photoId,txtTitle.text,txtDescription.text,auth_token,api_sig];
    
    //urlParams = [urlParams stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *escapedUrlString = [urlParams stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"Url String %@",escapedUrlString);
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:escapedUrlString]];
    connectionToUpdate = [[NSURLConnection alloc]initWithRequest:request delegate:self];*/
    
    iCommon *icommonObj = [[iCommon alloc]init];
    [icommonObj updateData:[NSDictionary dictionaryWithObjectsAndKeys:photoId,@"photo_id",txtTitle.text,@"title",txtDescription.text,@"description",nil]];
    [icommonObj updateTagWithParams:[NSDictionary dictionaryWithObjectsAndKeys:photoId,@"photo_id",txtTag.text,@"tags", nil]];
    
}

@end
