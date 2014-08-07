//
//  QueueExpandedViewController.m
//  FlickerVoice
//
//  Created by Varshyl3 on 13/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QueueExpandedViewController.h"
#import "EditDetailViewController.h"
@interface QueueExpandedViewController (){
   int viewIndex;
}

@end

@implementation QueueExpandedViewController
@synthesize queueArray;
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
    dataToEdit = [[NSMutableDictionary alloc]init];
    viewIndex = 0;
   // NSLog(@"Queue Array %@",queueArray);
    NSLog(@"Queue Array Count %d",[queueArray count]);
    viewForPreview.hidden = YES;
    queueViews = [[NSMutableArray alloc]init];
    float startX = 15;
    float startY = 5;
    queueScrollView.contentSize = CGSizeMake(700, 0);
    // Do any additional setup after loading the view from its nib.
    
  /*  for(int i=0;i<[queueArray count];i++){
            
        QueueView *queueView = [[QueueView alloc]initWithFrame:CGRectMake(startX, startY, 84, 84)];
        queueView.tag = i;
            
        NSData *imageData = [[self.queueArray objectAtIndex:i]objectForKey:@"Data"];
        queueView.containerView.image = [[UIImage alloc]initWithData:imageData];
        [queueScrollView addSubview:queueView];
        startX = startX+84+20;
    }*/
    
    
    for(int i=0;i<[queueArray count];i++){
        
        viewIndex++;
        NSLog(@"ViewIndex %d",viewIndex);
        QueueView *queueView = [[QueueView alloc]initWithFrame:CGRectMake(startX, startY, 84, 84)];
        queueView.delegate = self;
        queueView.tag = i;
        [queueViews addObject:queueView];
        NSData *imageData = [[self.queueArray objectAtIndex:i]objectForKey:@"Data"];
        queueView.containerView.image = [[UIImage alloc]initWithData:imageData];
        [queueScrollView addSubview:queueView];
        if(viewIndex == 3){
            startX = 15;
            startY = startY+84+20;
            continue;
        }
        if(viewIndex == 6){
            startX = startX+84+20;
            startY = 5;
            viewIndex = 0;
            continue;
        }
         startX = startX+84+20;
    }
}

/*-(void)addObjectForIndex:(NSUInteger)index
{
    NSLog(@"Show Preview For Index %d",index);
    NSData *data = [[queueArray objectAtIndex:index]objectForKey:@"Data"];
    imagePreview.image = [UIImage imageWithData:data];
    viewForPreview.hidden = NO;
    dataToEdit = [queueArray objectAtIndex:index];

}*/

/*-(void)removeObjectForIndex:(NSUInteger)index
{
    NSLog(@"Hide Preview For Index %d",index);
    viewForPreview.hidden = YES;
}*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma Mark - IBAction Methods
-(IBAction)backToRootView
{
    NSLog(@"Back to rootview");
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)editBtnTapped
{
    EditDetailViewController *editDetailVC = [[EditDetailViewController alloc]init];
    editDetailVC.detailsToUpdate = dataToEdit;
    [self.navigationController pushViewController:editDetailVC animated:YES];
}
@end
