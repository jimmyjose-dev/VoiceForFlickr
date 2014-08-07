//
//  HomeViewController.h
//  FlickerVoice
//
//  Created by Varshyl3 on 12/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
#import "iCommon.h"
#import "CustomSwitch.h"
#import "AQGridView.h"
#import "ImageGridViewCell.h"
@interface HomeViewController : CommonViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UISearchBarDelegate,UIScrollViewDelegate,UIAlertViewDelegate,iCommonDelegate,CustomSwitchDelegate,AQGridViewDelegate,AQGridViewDataSource>
{

    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    
    NSMutableArray *imageArray;
    NSMutableData *mutableData;
    
    UIImagePickerController *imagePickerController;
  
    IBOutlet UIView *snapView;
    IBOutlet UIImageView *snapImageViwe;
    
    IBOutlet UIButton *recordButton;
    IBOutlet UIButton *playButton;
        
    IBOutlet UIView *detailView;
    IBOutlet UITextField *txtTitle;
    IBOutlet UITextField *txtTag;
   // IBOutlet UITextField *txtAlbum;
    IBOutlet UITextView *txtViewDescription;
    
    IBOutlet UIScrollView *scorollview;
    IBOutlet UIImageView *accessoryView;
    
    IBOutlet UIView *popOverView;
   // IBOutlet UITableView *albumTable;
    
    
    IBOutlet UIView *addDetailSubview;
    
    //IBOutlet For Edit Detail
    IBOutlet UIButton *editBtn;
    IBOutlet UIView *viewForEditDetail;
    IBOutlet UIView *editDetailSubView;
    IBOutlet UIButton *editAudioBtn;
    IBOutlet UIButton *editRecordingBtn;
    
    IBOutlet UIView *editSoundView;
    IBOutlet UIImageView *editImageView;
    
    NSMutableData *editedData;
    NSData *selectedImageData;
    
   // IBOutlet UIScrollView *albumScrollView;
    NSMutableArray *dummyArray;
    
    NSURL *soundFileURL;
    BOOL isOn;
    
    CGPoint  offset;
    
    NSUInteger editIndex;
    
    NSMutableData *responseData;
    int pageNo;
    int totalPages;
    
    NSUInteger isProValue;
    
    IBOutlet UITableView *table;
    NSMutableArray *imagesArray;
    NSMutableDictionary *imageDict;
    NSMutableArray *imageDataArray;
    
    IBOutlet UIView *snpaViewSuperView;
    IBOutlet UIView *viewForGridView;
    
    //Label Outlets
    IBOutlet UILabel    *lblQueue;
    IBOutlet UILabel    *lblPhotoStream;
    IBOutlet UILabel    *lblAudio;
    IBOutlet UILabel    *lblDetail;
    IBOutlet UILabel    *lblAddQueue;
    IBOutlet UILabel    *lblUpload;
    IBOutlet UILabel    *lblGrigPhStream;
        
    CustomSwitch *customSwitch;
    CustomSwitch *customSwitchOnEditView;
    AQGridView *gridView;
    UISlider *slider;
    
    BOOL isReload;
    
    
}
@property(nonatomic,retain) NSMutableArray *dummyArray;
@property(nonatomic,retain) NSMutableArray *queueArray;
@property(nonatomic,retain) UISlider *slider;
@property(nonatomic,retain) AQGridView *gridView;

/*@property(nonatomic,retain)NSMutableArray *imageArray;
@property(nonatomic,retain)NSMutableArray *imageDataArray;
@property(nonatomic,retain)NSMutableDictionary *imageDict;
@property(nonatomic,retain)UIImagePickerController *imagePickerController;
@property(nonatomic,retain)NSMutableData *responseData;
@property(nonatomic,retain)NSMutableArray *albumArray;
@property(nonatomic,retain)NSMutableArray *queueViewsArray;*/

-(IBAction)cameraButtonTapped;
-(IBAction)gallaryButtonTapped;
-(IBAction)uploadActiveButtonTapped;

#pragma Mark - Method For SnapView
-(IBAction)addAudioBtnTapped;
-(IBAction)addDetailBtnTapped;
-(IBAction)addToQueueBtnTapped;
-(IBAction)recordButtonTapped;
-(IBAction)playButtonTapped;
-(IBAction)uploadBtnTapped;


#pragma Mark - Method For DetailView
-(IBAction)doneButtonTapped;
-(IBAction)detailUploadBtnTapped;
-(IBAction)showAlbumBtntapped;
-(IBAction)addAlbumBtnTapped;
-(IBAction)switchAction;

-(IBAction)sliderValueChanged;
- (IBAction)changePage:(id)sender;
-(IBAction)queueExpanded;

-(IBAction)editDescBtnTapped;
-(IBAction)editDoneBtnTapped;
-(IBAction)editCancelBtnTapped;


-(IBAction)editAudioBtnTapped:(id)sender;
-(IBAction)editAudioCancelBtnTapped;
-(IBAction)editAudioDoneBtnTapped;
-(IBAction)editAudioRecordBtnTapped;
-(IBAction)editAudioPlayBtnTapped;
-(IBAction)hideGridViewBtnTapped;
-(void)updateUIAfterImageUploaded:(NSNotification*)notification;
-(IBAction)expanStreamBtnTapped;

@end
