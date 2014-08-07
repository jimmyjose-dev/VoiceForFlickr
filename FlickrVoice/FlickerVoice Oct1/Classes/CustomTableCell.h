//
//  CustomTableCell.h
//  FlickerVoice
//
//  Created by Varshyl3 on 07/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableCell : UITableViewCell
{
    UIImageView *cellImageView;
    UILabel *lblDetail;
}

@property(nonatomic,retain) UIImageView *cellImageView;
@property(nonatomic,retain) UILabel *lblDetail;
@end
