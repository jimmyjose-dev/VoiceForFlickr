//
//  iCommon.h
//  FlickerVoice
//
//  Created by Varshyl3 on 06/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveFlickr.h"
@protocol iCommonDelegate;
@interface iCommon : NSObject<OFFlickrAPIRequestDelegate>
{
   OFFlickrAPIRequest *flickrRequest;
    id <iCommonDelegate>delegate;
}
@property(nonatomic,retain) OFFlickrAPIRequest *flickrRequest;
@property(nonatomic,retain)id <iCommonDelegate>delegate;
//- (void)startUpload:(UIImage *)image withParams:(NSDictionary*)params;
- (void)startUpload:(NSData *)imageData withParams:(NSDictionary*)params;
- (void)updateData:(NSDictionary*)params;
-(void)updateTagWithParams:(NSDictionary*)params;
-(void)replaceData:(NSData*)imgData withParams:(NSDictionary*)params;
-(void)getUserInfoForId:(NSString*)userId;

@end

@protocol iCommonDelegate <NSObject>

-(void)getAccountInfo:(NSUInteger)isPro;

@end