//
//  Constants.h
//  FlickerVoice
//
//  Created by Varshyl3 on 06/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef FlickerVoice_Constants_h
#define FlickerVoice_Constants_h

#define SnapAndRunShouldUpdateAuthInfoNotification   @"SnapAndRunShouldUpdateAuthInfoNotification"

// preferably, the auth token is stored in the keychain, but since working with keychain is a pain, we use the simpler default system
#define kStoredAuthTokenKeyName         @"FlickrOAuthToken"
#define kStoredAuthTokenSecretKeyName = @"FlickrOAuthTokenSecret"

#define kGetAccessTokenStep = @"kGetAccessTokenStep"
#define kCheckTokenStep = @"kCheckTokenStep"

//NSString *SRCallbackURLBaseString = @"snapnrun://auth";
#define SRCallbackURLBaseString = @"flickervoice://auth"

#define kFetchRequestTokenStep = @"kFetchRequestTokenStep"
#define kGetUserInfoStep = @"kGetUserInfoStep"
#define kSetImagePropertiesStep = @"kSetImagePropertiesStep"
#define kUploadImageStep = @"kUploadImageStep"


#endif
