//
//  FlickerManager.h
//  FlickerVoice
//
//  Created by Varshyl3 on 06/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveFlickr.h"
@interface FlickerManager : NSObject<OFFlickrAPIRequestDelegate>
{
    OFFlickrAPIContext *flickrContext;
	OFFlickrAPIRequest *flickrRequest;
	NSString *flickrUserName;
    
}
@property(nonatomic,retain) OFFlickrAPIContext *flickrContext;
@property(nonatomic,retain) OFFlickrAPIRequest *flickrRequest;
@property(nonatomic,retain)NSString *flickrUserName;
+(id)sharedInstance;
- (void)setAndStoreFlickrAuthToken:(NSString *)inAuthToken secret:(NSString *)inSecret;
@end
