//
//  QueueView.h
//  FlickerVoice
//
//  Created by Varshyl3 on 13/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QueueViewDelegate;
@interface QueueView : UIView
{
    UIImageView *containerView;
    UIImageView *checkImageView;
    BOOL isSelected;
    BOOL isShowPreview;
    NSMutableArray *selectedQueueArray;
    id <QueueViewDelegate> delegate; 
}
@property(nonatomic,retain)     UIImageView *containerView;
@property(nonatomic,retain)     UIImageView *checkImageView;
@property(nonatomic,retain)     NSMutableArray *selectedQueueArray;
@property(nonatomic,retain)     id <QueueViewDelegate> delegate; 
@property(nonatomic)            BOOL isSelected;
@property(nonatomic)            BOOL isShowPreview;
@end

@protocol QueueViewDelegate <NSObject>
@optional
-(void)selecteObjectForIndex:(NSUInteger)index;
-(void)addObjectForIndex:(NSUInteger)index;
-(void)removeObjectForIndex:(NSUInteger)index;
-(void)showPreviewForIndex:(NSUInteger)index;

@end