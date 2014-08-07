//
//  UploadActiveViewController.m
//  FlickerVoice
//
//  Created by Varshyl3 on 14/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UploadActiveViewController.h"
#import "iCommon.h"
#import "QueueView.h"
#import "MBProgressHUD.h"
#import "UploadCompletionViewController.h"
#import "SnapAndRunAppDelegate.h"
@interface UploadActiveViewController ()

@end

@implementation UploadActiveViewController
@synthesize queueArray,dataArrayToUpload,delegate,arrayForIndexes;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMBProgressHUD) name:@"updateUI" object:nil];

}
-(void)viewDidDisappear:(BOOL)animated
{
     [super viewDidDisappear:animated];
     [self.delegate updateUIAfterUploadImagesFromArray:self.dataArrayToUpload];
    // NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:dataArrayToUpload,@"DataToUpdateUI", nil];
    if(isUploaded){
        NSDictionary *indexDictionary = [NSDictionary dictionaryWithObjectsAndKeys:arrayForIndexes,@"IndexArray", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"AllImageUploadedNotification" object:self userInfo:indexDictionary];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isSelectAll = NO;
    isUploaded = NO;
    self.dataArrayToUpload = [[NSMutableArray alloc]init];
    self.arrayForIndexes = [[NSMutableArray alloc]init];
    queueViewArray = [[NSMutableArray alloc]init];
    localQueueArray = [[NSMutableArray alloc]init];
    [localQueueArray addObjectsFromArray:self.queueArray];
    startX = 15;
    
    //NSLog(@"queue array %@",queueArray);
    /*for(int i=0;i<[localQueueArray count];i++){
        
        
    //    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkUncheckImage)];
      //   tapGesture.numberOfTapsRequired = 1;
        
        QueueView *queueView = [[QueueView alloc]initWithFrame:CGRectMake(startX, 5, 84, 84)];
        queueView.delegate = self;
        queueView.tag = i;
      //  [queueView addGestureRecognizer:tapGesture];
        
        NSData *imageData = [[localQueueArray objectAtIndex:i]objectForKey:@"Data"];
        queueView.containerView.image = [[UIImage alloc]initWithData:imageData];
        [queueScrollView addSubview:queueView];
        [queueViewArray addObject:queueView];
        startX = startX+84+20;

        
    }*/
    
    
    int viewIndex = 0;
    int numberOfPages = ([localQueueArray count]/9)+1;
    queueScrollView.contentSize = CGSizeMake(queueScrollView.frame.size.width *numberOfPages, queueScrollView.frame.size.height);
    
  //  [queueExpandBtn setImage:[UIImage imageNamed:@"btn_minus.png"] forState:UIControlStateNormal];
   // [viewForPhotoStream setHidden:YES];
   // viewForQueue.frame = CGRectMake(0, 10, 320, 390);
   // [queueScrollView setFrame:CGRectMake(0, 45, 320, 280)];
   // [queuePageCtrl setFrame:CGRectMake(0, 318, 320, 36)];
    
    float startX1 = 15;
    float startY1 = 5;
    
    
    for(int i = 0;i<[localQueueArray count];i++){
        NSLog(@"Prt");
        viewIndex++;
        //QueueView *queView = [queueViewsArray objectAtIndex:i];
        QueueView *qView = [[QueueView alloc]init];
        qView.tag = i;
        qView.delegate = self;
        CGRect frame = CGRectMake(startX1, startY1, 84, 84);
       
        qView.frame = frame;
        NSData *imageData = [[localQueueArray objectAtIndex:i]objectForKey:@"Data"];
        qView.containerView.image = [[UIImage alloc]initWithData:imageData];
        [queueScrollView addSubview:qView];
        
        [queueViewArray addObject:qView];
        
        if(viewIndex % 3 == 0 && viewIndex%9 != 0){
            
            int a = viewIndex-3;
            QueueView *qview = [queueViewArray objectAtIndex:a];
            startX1 = qview.frame.origin.x;
            NSLog(@"Change Y here");
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

    
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 32, 32);
    [leftButton setImage:[UIImage imageNamed:@"btn_menu.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view from its nib.
}
-(void)dealloc
{
    [icommonObj release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
  
    /// Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
   // [barbtn setCustomView:leftButton];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

-(IBAction)showMenu
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)uploadDataOnFlicker
{
    NSString *user = [SnapAndRunAppDelegate sharedDelegate].flickrUserName;
    NSLog(@"User %@",user);
    if(user == NULL){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please Lgin First" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
        NSLog(@"return from here");
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"data array count %d",[self.dataArrayToUpload count]);
    NSLog(@"Start Uploading");
    
    for(int i=0;i<[dataArrayToUpload count];i++){
        icommonObj = [[iCommon alloc]init];
        NSDictionary *dataDict = [[self.dataArrayToUpload objectAtIndex:i]objectForKey:@"DataToUpload"];
        //NSData *data = [[self.dataArrayToUpload objectAtIndex:i]objectForKey:@"Data"];
       // NSDictionary *dictionary = [[self.dataArrayToUpload objectAtIndex:i]objectForKey:@"Params"];
        NSData *data = [dataDict objectForKey:@"Data"];
        NSDictionary *dictionary = [dataDict objectForKey:@"Params"];
        [icommonObj startUpload:data withParams:dictionary];
      
    }

}


/*-(void)setImageOnQueue
{
    
    NSLog(@"Queue array count %d",[localQueueArray count]);
    int count = [localQueueArray count];
    //NSDictionary *dictionary = [[self.queueArray objectAtIndex:count-1]objectForKey:@"Params"];
   // NSLog(@"Data %@",[[self.queueArray objectAtIndex:count-1]objectForKey:@"Data"]);
   // NSLog(@"Detail %@",dictionary);
    
    QueueView *queueView = [[QueueView alloc]initWithFrame:CGRectMake(startX, 5, 84, 84)];
    NSData *imageData = [[self.queueArray objectAtIndex:count-1]objectForKey:@"Data"];
    queueView.containerView.image = [[UIImage alloc]initWithData:imageData];
    [queueScrollView addSubview:queueView];
    startX = startX+84+20;
}
*/

-(void)checkUncheckImage
{
    NSLog(@"Image Tapped");
    if(isSelected){
        NSLog(@"Not Selected");
      //  checkImageView.hidden = YES;
        isSelected = NO;
    }else{
        NSLog(@"Selected");
       // checkImageView.hidden = NO;
        isSelected = YES;
    }
}


-(void)selecteObjectForIndex:(NSUInteger)index
{
    NSLog(@"Selected Index %d",index);
    
}

-(void)addObjectForIndex:(NSUInteger)index
{
    NSLog(@"Add object index %d",index);
    NSLog(@"add to upload");
    NSDictionary *dictionary = [self.queueArray objectAtIndex:index];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:dictionary,@"DataToUpload",[NSNumber numberWithInt:index],@"Index", nil];
    
   // [self.dataArrayToUpload addObject:dictionary];
    
    [self.dataArrayToUpload addObject:data];
    [self.arrayForIndexes addObject:[NSNumber numberWithInt:index]];
    
   // [localQueueArray removeObject:dictionary];
  //  NSLog(@"dataArrayToUpload on add Method %@",dataArrayToUpload);
}
-(void)removeObjectForIndex:(NSUInteger)index
{
    
    if([dataArrayToUpload count]>=index){
         NSDictionary *dictionary = [self.queueArray objectAtIndex:index];
        [self.dataArrayToUpload removeObject:dictionary];
      //  [localQueueArray addObject:dictionary];
    }
   // NSLog(@"dataArrayToUpload on remove Method %@",dataArrayToUpload);
    
}

-(IBAction)selectAllObject
{
    //checkbox_active.png
    if(isSelectAll){
        
        [selectAllBtn setImage:[UIImage imageNamed:@"checkbox_inactive.png"] forState:UIControlStateNormal];
        for (int i =0 ; i < [queueViewArray count]; i++) {
            QueueView *view = [queueViewArray objectAtIndex:i];
            view.isSelected = NO;
            view.checkImageView.hidden = YES;
            
          //  NSDictionary *dict = [localQueueArray objectAtIndex:i];
          //  [localQueueArray insertObject:dict atIndex:i];
        }
        isSelectAll = NO;
    }else{
        
            [selectAllBtn setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal];
            for (int i =0 ; i < [queueViewArray count]; i++) {
                QueueView *view = [queueViewArray objectAtIndex:i];
                view.isSelected = YES;
                view.checkImageView.hidden = NO;
                
               // NSDictionary *dict = [localQueueArray objectAtIndex:i];
               // [localQueueArray removeObject:dict];
            }
        isSelectAll = YES;
    }
}

-(void)hideMBProgressHUD
{
    NSLog(@"hide hideMBProgressHUD method called");
    isUploaded = YES;
  //  NSLog(@"Data array %@",dataArrayToUpload);
    
   // NSLog(@"Local Array count %d",[localQueueArray count]);
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
   // NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:dataArrayToUpload,@"DataToUpdateUI", nil];
        
   // [[NSNotificationCenter defaultCenter]postNotificationName:@"AllImageUploadedNotification" object:self userInfo:dictionary];
    
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"AllImageUploadedNotification" object:self];
  //  [self.delegate updateUIAfterUploadImagesFromArray:self.dataArrayToUpload];
    
    [self dismissModalViewControllerAnimated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
