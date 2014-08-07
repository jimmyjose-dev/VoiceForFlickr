//
//  AfterImageUploading.h
//  SnapAndRun
//
//  Created by VarshylMobile on 03/09/12.
//
//

#import <UIKit/UIKit.h>
#import "ObjectiveFlickr.h"
@interface AfterImageUploading : UIViewController<OFFlickrAPIRequestDelegate,UITableViewDelegate,UITableViewDataSource>
{
    OFFlickrAPIRequest *flickrRequest;
    NSString *userId;
    NSMutableDictionary *dictionary;
    NSMutableData *responseData;
    NSMutableDictionary *imageDict;
    NSMutableArray *imagesArray;
    int pageNo;
    int totalPages;
}
@property(nonatomic,retain) NSMutableData *responseData;
@property(nonatomic,retain) OFFlickrAPIRequest *flickrRequest;
@end
