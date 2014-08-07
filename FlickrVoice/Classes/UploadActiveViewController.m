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
@synthesize localQueueArray,dataArrayToUpload,arrayForIndexes;
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
    [localQueueArray release];
    [dataArrayToUpload release];
    [arrayForIndexes release];
    [icommonObj release];
    [dict release];
    [queueViewArray release];
    [queueScrollView release];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    popupView = nil;
    navController = nil;
    barbtn = nil;
    leftButton = nil;
    selectAllBtn = nil;
    queueScrollView = nil;
    
    /// Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // [barbtn setCustomView:leftButton];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMBProgressHUD) name:@"updateUI" object:nil];

}
-(void)viewDidDisappear:(BOOL)animated
{
     [super viewDidDisappear:animated];
    NSLog(@"Indexd array %@",arrayForIndexes);
    // [self.delegate updateUIAfterUploadImagesFromArray:self.dataArrayToUpload];
    // NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:dataArrayToUpload,@"DataToUpdateUI", nil];
    if(isUploaded){
        NSDictionary *indexDictionary = [NSDictionary dictionaryWithObjectsAndKeys:arrayForIndexes,@"IndexArray", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"AllImageUploadedNotification" object:self userInfo:indexDictionary];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    objIndex = 0;
    pageCtrl.currentPage = 0;
    dict=[NSMutableDictionary new];
    isSelectAll = NO;
    isUploaded = NO;
    self.dataArrayToUpload = [[NSMutableArray alloc]init];
    self.arrayForIndexes = [[NSMutableArray alloc]init];
    queueViewArray = [[NSMutableArray alloc]init];
   // localQueueArray = [[NSMutableArray alloc]init];
    //[localQueueArray addObjectsFromArray:self.localQueueArray];
    popupView.hidden = YES;
    startX = 15;
    pageCtrl.hidden = YES;
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
    int numberOfPages = ([localQueueArray count]/9);
    pageCtrl.numberOfPages = numberOfPages;
    queueScrollView.contentSize = CGSizeMake(queueScrollView.frame.size.width *numberOfPages, queueScrollView.frame.size.height);
    
  //  CGRect rect = CGRectMake(queueScrollView.frame.size.width *numberOfPages, 0, queueScrollView.frame.size.width, queueScrollView.frame.size.height);
   // [queueScrollView scrollRectToVisible:rect animated:YES];
    
  //  [queueExpandBtn setImage:[UIImage imageNamed:@"btn_minus.png"] forState:UIControlStateNormal];
   // [viewForPhotoStream setHidden:YES];
   // viewForQueue.frame = CGRectMake(0, 10, 320, 390);
   // [queueScrollView setFrame:CGRectMake(0, 45, 320, 280)];
   // [queuePageCtrl setFrame:CGRectMake(0, 318, 320, 36)];
    
    float startX1 = 15;
    float startY1 = 5;
    
    NSLog(@"Local Queue arr count %d",[localQueueArray count]);
    for(int i = 0;i<[localQueueArray count];i++){
       // NSLog(@"Prt");
        viewIndex++;
        //QueueView *queView = [queueViewsArray objectAtIndex:i];
        QueueView *qView = [[QueueView alloc]init];
        qView.tag = i;
        qView.delegate = self;
        CGRect frame = CGRectMake(startX1, startY1, 84, 84);
       
        qView.frame = frame;
       // NSData *imageData = [[localQueueArray objectAtIndex:i]objectForKey:@"Data"];
         UIImage *imageData = [[localQueueArray objectAtIndex:i]objectForKey:@"Data"];
      
        qView.containerView.image = imageData;
        [queueScrollView addSubview:qView];
        
        [queueViewArray addObject:qView];
        
        if(viewIndex % 3 == 0 && viewIndex%9 != 0){
            
            int a = viewIndex-3;
            QueueView *qview = [queueViewArray objectAtIndex:a];
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

    
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 32, 32);
    [leftButton setImage:[UIImage imageNamed:@"btn_menu.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view from its nib.
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
    if([dict count]==0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please Select Photo" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES withMessage:@"Image Uploading..."];
    NSLog(@"data array count %d",[self.dataArrayToUpload count]);
    NSLog(@"Start Uploading");
    
    /*for(int i=0;i<[dataArrayToUpload count];i++){
        icommonObj = [[iCommon alloc]init];
        NSDictionary *dataDict = [[self.dataArrayToUpload objectAtIndex:i]objectForKey:@"DataToUpload"];
        //NSData *data = [[self.dataArrayToUpload objectAtIndex:i]objectForKey:@"Data"];
       // NSDictionary *dictionary = [[self.dataArrayToUpload objectAtIndex:i]objectForKey:@"Params"];
        NSData *data = [dataDict objectForKey:@"Data"];
        NSDictionary *dictionary = [dataDict objectForKey:@"Params"];
        [icommonObj startUpload:data withParams:dictionary];
      
    }*/
    NSLog(@"Dict  count %d",[dict count]);
    NSArray *keys = [dict allKeys];
    for(int i=0;i<[keys count];i++){
        icommonObj = [[iCommon alloc]init];
        NSString *str = [keys objectAtIndex:i];
        
       // NSDictionary *dataDict = [[self.dataArrayToUpload objectAtIndex:i]objectForKey:@"DataToUpload"];
        
        NSDictionary *dataDict = [dict objectForKey:str];
        
        //NSData *data = [[self.dataArrayToUpload objectAtIndex:i]objectForKey:@"Data"];
        // NSDictionary *dictionary = [[self.dataArrayToUpload objectAtIndex:i]objectForKey:@"Params"];
        
        
        //NSData *data = [dataDict objectForKey:@"Data"];
        UIImage *image = [dataDict objectForKey:@"Data"];
        NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.1)];
        
        mutableDataToUpload = [[NSMutableData alloc]initWithData:data];
        char header[] = {'\xde','\xad','\xde','\xad'};
        int ImageSize =[mutableDataToUpload length];
        
        NSUInteger paddingLen = (([mutableDataToUpload length]/8)+1)*8 - [mutableDataToUpload length] + 4;
        // NSLog(@"size %d paddingLength %d",ImageSize,paddingLen);
        
        char padding[paddingLen];
        
        for (NSUInteger i =0; i<paddingLen; ++i) {
            padding[i] = '\x00';
        }
        
        [mutableDataToUpload appendBytes:padding length:paddingLen];
        [mutableDataToUpload appendBytes:header length:4];
        
        NSData *audioData = [dataDict objectForKey:@"AudioData"];
        if(audioData){
            [mutableDataToUpload appendData:audioData];
        }
        NSDictionary *dictionary = [dataDict objectForKey:@"Params"];
        [icommonObj startUpload:mutableDataToUpload withParams:dictionary];
        
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
       // checkImageView.hidden = YES;
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
   // NSLog(@"add to upload");
    if(!isSelected){
        QueueView *qView = [queueViewArray objectAtIndex:index];
        qView.checkImageView.hidden = NO;

        NSDictionary *dictionary = [self.localQueueArray objectAtIndex:index];
        
      //  NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:dictionary,@"DataToUpload",[NSNumber numberWithInt:index],@"Index", nil];
    
        // [self.dataArrayToUpload addObject:dictionary];
    
        //[self.dataArrayToUpload addObject:data];
        
        // [dict setValue:[dataArrayToUpload objectAtIndex:index] forKey:[NSString stringWithFormat:@"%d",index]];
        [dict setValue:dictionary forKey:[NSString stringWithFormat:@"%d",index]];
       // NSLog(@"Dict %@",dict);
        [self.arrayForIndexes addObject:[NSNumber numberWithInt:index]];
    
        // [localQueueArray removeObject:dictionary];
      //  NSLog(@"data arr count on add %d",[dataArrayToUpload count]);
    }
    NSLog(@"indexarray on add method %@",arrayForIndexes);
}
-(void)removeObjectForIndex:(NSUInteger)index
{
    QueueView *qView = [queueViewArray objectAtIndex:index];
    qView.checkImageView.hidden = YES;

    [dict removeObjectForKey:[NSString stringWithFormat:@"%d",index]];
    [self.arrayForIndexes removeObject:[NSNumber numberWithInt:index]];
    NSLog(@"IndexArray on remove method %@",arrayForIndexes);
   // NSLog(@"Dict on remove %@",dict);
    
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
            [dict removeObjectForKey:[NSString stringWithFormat:@"%d",i]];
            [arrayForIndexes removeObject:[NSNumber numberWithInt:i]];
           
          //  [localQueueArray insertObject:dict atIndex:i];
        }
        isSelectAll = NO;
    }else{
        
            [selectAllBtn setImage:[UIImage imageNamed:@"checkbox_active.png"] forState:UIControlStateNormal];
            for (int i =0 ; i < [queueViewArray count]; i++) {
                QueueView *view = [queueViewArray objectAtIndex:i];
                view.isSelected = YES;
                view.checkImageView.hidden = NO;
                
                //NSDictionary *dictionay = [queueArray objectAtIndex:i];
               // [localQueueArray removeObject:dict];
                
                NSDictionary *dictionary= [localQueueArray objectAtIndex:i];
                [dict setValue:dictionary forKey:[NSString stringWithFormat:@"%d",i]];
                [arrayForIndexes addObject:[NSNumber numberWithInt:i]];
            }
        isSelectAll = YES;
    }
    NSLog(@"indexArray %@",arrayForIndexes);
}

-(void)hideMBProgressHUD
{
    NSLog(@"hide hideMBProgressHUD method called");
    isUploaded = YES;
    
  //  NSLog(@"Data array %@",dataArrayToUpload);
    
   // NSLog(@"Local Array count %d",[localQueueArray count]);
    
   // [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [MBProgressHUD hideHUDForView:self.view WithMessage:@"All Images Uploaded" animated:YES];

    // NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:dataArrayToUpload,@"DataToUpdateUI", nil];
        
   // [[NSNotificationCenter defaultCenter]postNotificationName:@"AllImageUploadedNotification" object:self userInfo:dictionary];
    
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"AllImageUploadedNotification" object:self];
  //  [self.delegate updateUIAfterUploadImagesFromArray:self.dataArrayToUpload];
     //[[NSNotificationCenter defaultCenter] postNotificationName:@"updateUI" object:self];
    [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:0.5];
    
}
-(void)dismissViewController
{
    [self dismissModalViewControllerAnimated:YES];

}
-(void)showPreviewForIndex:(NSUInteger)index
{

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)rigthBatBtnTapped
{
    if(popupView.hidden){
        popupView.hidden = NO;
    }else{
        popupView.hidden = YES;
    }
}

-(IBAction)signOutBtnTapped
{
    NSLog(@"Signout on edit detail vc");
    [[SnapAndRunAppDelegate sharedDelegate] setAndStoreFlickrAuthToken:nil secret:nil];
   // [self flickrRequest].sessionInfo = @"kCheckTokenStep";
    //[req callAPIMethodWithGET:@"flickr.test.login" arguments:nil];
    
    [self dismissModalViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"PopToRootViewController" object:self];
}

#pragma Mark - Paging

- (IBAction)changePage:(id)sender
{
    int pNo = pageCtrl.currentPage;
    //NSLog(@"Page NO %d",pNo);
    CGRect frame = queueScrollView.frame;
    frame.origin.x = frame.size.width * pNo;
    frame.origin.y = 0;
    [queueScrollView scrollRectToVisible:frame animated:YES];
    
    
    pageControlUsed = YES;
}

#pragma Mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
   // NSLog(@"Scrollview delegate");
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageCtrl.currentPage = page;
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if(!popupView.hidden){
        popupView.hidden = YES;
    }
}


@end
