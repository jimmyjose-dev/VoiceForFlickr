//
//  CommonViewController.m
//  FlickerVoice
//
//  Created by Varshyl3 on 14/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommonViewController.h"
#import<QuartzCore/QuartzCore.h>
#import "QueueView.h"
#import "SnapAndRunAppDelegate.h"
@interface CommonViewController ()

@end

@implementation CommonViewController
@synthesize queueArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [popupView setHidden:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    queueViewsArray = [[NSMutableArray alloc]init];
     self.queueArray = [[NSMutableArray alloc]init];
    startX = 15;
    isShowingPopup = NO;
  
    popupView.frame = CGRectMake(191, 58 , 129, 63);
    [self.navigationController.view addSubview:popupView];
    [popupView.layer setZPosition:999];
    popupView.hidden = YES;
    UIButton *popUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [popUpBtn setImage:[UIImage imageNamed:@"btn_user.png"] forState:UIControlStateNormal];
    [popUpBtn setFrame:CGRectMake(0, 0, 35, 32)];
    [popUpBtn addTarget:self action:@selector(showPopOver) forControlEvents:UIControlEventTouchUpInside];
    popUpBtn.adjustsImageWhenHighlighted = NO;
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:popUpBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    
    //popupView.frame = CGRectMake(193, 45, 129, 103);
   // [self.navigationController.view addSubview:popupView];
    
	// Do any additional setup after loading the view.
}
-(void)showPopOver
{
     // popupView.hidden = NO;
    NSLog(@"Show popover");
    
    if(popupView.hidden){
        popupView.hidden = NO;
    }else{
        popupView.hidden = YES;
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (OFFlickrAPIRequest *)flickrRequest
{
	if (!req) {
		req = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
		//req.delegate = self;		
	}
	
	return flickrRequest;
}
-(IBAction)signOutBtnTapped
{
    NSLog(@"SignOut");
    
   // [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FlickrOAuthToken"];
  //  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FlickrOAuthTokenSecret"];
    
   // [SnapAndRunAppDelegate sharedDelegate].flickrUserName = nil;
    
  //  OFFlickrAPIRequest *req = [[OFFlickrAPIRequest alloc]init];
     [[SnapAndRunAppDelegate sharedDelegate] setAndStoreFlickrAuthToken:nil secret:nil];
    [self flickrRequest].sessionInfo = @"kCheckTokenStep";
    [req callAPIMethodWithGET:@"flickr.test.login" arguments:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
   // [[SnapAndRunAppDelegate sharedDelegate].flickrContext.OAuthToken length]

}


-(void)setImageOnQueue
{
    
    NSLog(@"Queue array count %d",[queueArray count]);
    int count = [queueArray count];
    
  //  NSDictionary *dictionary = [[self.queueArray objectAtIndex:count-1]objectForKey:@"Params"];
   // NSLog(@"Data %@",[[self.queueArray objectAtIndex:count-1]objectForKey:@"Data"]);
 //   NSLog(@"Detail %@",dictionary);
    
    QueueView *queueView = [[QueueView alloc]initWithFrame:CGRectMake(startX, 5, 80, 84)];
    queueView.tag = [self.queueArray count]-1;
    queueView.delegate = self;
   // NSData *imageData = [[self.queueArray objectAtIndex:count-1]objectForKey:@"Data"];
    UIImage *imageData = [[self.queueArray objectAtIndex:count-1]objectForKey:@"Data"];
    //queueView.containerView.image = [[UIImage alloc]initWithData:imageData];
    queueView.containerView.image = imageData;
    [queueScrollView addSubview:queueView];
    [queueViewsArray addObject:queueView];
    startX = startX+84+20;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [popupView setHidden:YES];
}

@end
