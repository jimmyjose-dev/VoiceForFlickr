//
//  AfterImageUploading.m
//  SnapAndRun
//
//  Created by VarshylMobile on 03/09/12.
//
//

#import "AfterImageUploading.h"
#define OBJECTIVE_FLICKR_API_KEY @"f968369b7b7c00d3f9ce7a3505d3f566"
#define OBJECTIVE_FLICKR_API_SHARED_SECRET @"ce717d4e251387b8"
#import "JSON.h"
#import "SnapAndRunAppDelegate.h"
#import "CustomTableCell.h"
#import "DownloadAndPlayViewController.h"
@interface AfterImageUploading ()
{
    IBOutlet UITableView *flickerImagesTable;
   
    NSMutableArray *imageDataArray;
    
}
@end

@implementation AfterImageUploading
@synthesize responseData;
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
    imageDict =[NSMutableDictionary new];
    imagesArray = [NSMutableArray new];
    flickerImagesTable.rowHeight = 80;
    self.responseData = [[NSMutableData data]retain];
    imageDataArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *auth_token = [defaults objectForKey:@"FlickrOAuthToken"];
    userId = [defaults objectForKey:@"UserId"];
    NSString *strId =  [userId stringByReplacingOccurrencesOfString:@"%40" withString:@"@"];
   // NSLog(@"User Id %@",strId);
    //NSLog(@"Auth token %@",auth_token);
   // NSLog(@"Signature %@",[defaults objectForKey:@"Signature"]); 
    NSString *uid = @"77623651@N08";
    NSLog(@"UId %@",uid);
    
   // http://api.flickr.com/services/rest/?method=flickr.people.getPhotos&api_key=6f2f7a8fe8a1cb8745ba938de6f490a5&user_id=86472090%40N06&format=json&nojsoncallback=1&auth_token=72157631494889424-c7a03c0abb90e0a4&api_sig=fb65ae7ec3ccafa24f66b63870e5c18c
    
    
   // NSString *searchUrlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&user_id=%@&per_page=15&extras=original_format,o_dims,views,url_o&format=json&nojsoncallback=1", OBJECTIVE_FLICKR_API_KEY,strId];
    
      NSString *searchUrlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&user_id=%@&per_page=10&extras=original_format,o_dims,views,url_o&format=json&nojsoncallback=1", OBJECTIVE_FLICKR_API_KEY,strId];
    
    //  NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.people.getPhotos%@",parUrl];
    
    NSString* escapedUrlString = [searchUrlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
	[request setURL:[NSURL URLWithString:escapedUrlString]];
    
    [[NSURLConnection alloc]initWithRequest:request delegate:self];

    
    
 
}
-(void)getData
{
   /* NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];  
    // wait for 3 seconds before starting the thread, you don't have to do that. This is just an example how to stop the NSThread for some time  
    [NSThread sleepForTimeInterval:3];  
    [self performSelectorOnMainThread:@selector(CallWebService) withObject:nil waitUntilDone:NO];  
    [pool release];  */
    
  
    
    
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


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
    
    NSLog(@"Response String on Did Complete with response %@",inResponseDictionary);
	if (inRequest.sessionInfo == @"kUploadImageStep") {
		//snapPictureDescriptionLabel.text = @"Setting properties...";
        
        
        NSLog(@"Response From Flicker%@", inResponseDictionary);
        
        flickrRequest.sessionInfo = @"kSetImagePropertiesStep";
        [flickrRequest callAPIMethodWithPOST:@"flickr.people.getPhotos" arguments:[NSDictionary dictionaryWithObjectsAndKeys:userId,@"owner",nil]];        		        
	}
    else if (inRequest.sessionInfo == @"kSetImagePropertiesStep") {
	        
		[UIApplication sharedApplication].idleTimerDisabled = NO;		
        
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inError);
	if (inRequest.sessionInfo == @"kUploadImageStep") {
		
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
    
    dictionary = [responseString JSONValue];
    NSLog(@"Rsponse String %@",dictionary);
    pageNo = [[[dictionary valueForKey:@"photos"]valueForKey:@"page"]intValue];
    totalPages = [[[dictionary valueForKey:@"photos"]valueForKey:@"pages"]intValue];
    NSLog(@"Page No %d And Total no of pages %d",pageNo,totalPages);
    [imagesArray addObjectsFromArray:[[dictionary valueForKey:@"photos"] valueForKey:@"photo"]];
   
    [flickerImagesTable reloadData];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection Failed");
  

}


#pragma Mark - TableView Delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Image Array count %d",[imagesArray count]);
    return [imagesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    CustomTableCell *cell = (CustomTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[CustomTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
   
   // cell.textLabel.text = @"a";
    cell.cellImageView.image = [UIImage imageNamed:@"mmImg.jpg"];
    NSMutableDictionary *imageDataDict = [[NSMutableDictionary alloc]init];
    [imageDataDict setObject:cell.cellImageView forKey:@"imageView"];
    
    
    
    [imageDataDict setObject:[[imagesArray objectAtIndex:indexPath.row] valueForKey:@"url_o"] forKey:@"ImageId"];
    
    
    if (indexPath.row==[imagesArray count]-1) {
        
        
       /* if (pageNo<=totalPages) {
            pageNo = pageNo+1;
    
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            userId = [defaults objectForKey:@"UserId"];
            NSString *strId =  [userId stringByReplacingOccurrencesOfString:@"%40" withString:@"@"];
         
            NSString *searchUrlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&page=%d&user_id=%@&per_page=10&extras=original_format,o_dims,views,url_o&format=json&nojsoncallback=1", OBJECTIVE_FLICKR_API_KEY,pageNo,strId];
            
            
            NSString* escapedUrlString = [searchUrlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            
            NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
            
            [request setURL:[NSURL URLWithString:escapedUrlString]];
            
            [[NSURLConnection alloc]initWithRequest:request delegate:self];

            
        }
        else {
        }
        */
        
    }
    
    //[imageDataDict setObject:@"UIImageView" forKey:@"Type"];
    
    [NSThread detachNewThreadSelector:@selector(fetchImageForCatlogs:) toTarget:self withObject:imageDataDict];
    //cell.lblDetail.text = @"VOIP IMAGE";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadAndPlayViewController *downloadAndPlayVC = [[DownloadAndPlayViewController alloc]init];
    downloadAndPlayVC.imageData = [imageDataArray objectAtIndex:indexPath.row];
    downloadAndPlayVC.photoId = [[imagesArray objectAtIndex:indexPath.row]valueForKey:@"id"];
    [self.navigationController pushViewController:downloadAndPlayVC animated:YES];
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
                
                
              //  [(UIActivityIndicatorView *)[obj objectForKey:@"RemovedView"] removeFromSuperview];
                [(UIImageView *)[obj objectForKey:@"imageView"] setImage:[UIImage imageWithData:[imageDict valueForKey:[obj valueForKey:@"ImageId"]]]];
                return;
            }
            
            NSData *mydata = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            
                      
            if (mydata) {
                              
              //  [(UIActivityIndicatorView *)[obj objectForKey:@"RemovedView"] removeFromSuperview];
                
                [(UIImageView *)[obj objectForKey:@"imageView"] setImage:[UIImage imageWithData:mydata]];//forState:UIControlStateNormal];
                [imageDataArray addObject:mydata];
                
                [imageDict setObject:mydata forKey:[obj valueForKey:@"ImageId"]];
                
            }
            
            [pool drain];
        }
    }
}
@end
