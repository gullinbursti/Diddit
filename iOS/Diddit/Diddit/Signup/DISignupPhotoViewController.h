//
//  DISignupPhotoViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 02.09.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIFormDataRequest.h"
#import "DILoadOverlay.h"

@interface DISignupPhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, ASIHTTPRequestDelegate> {
	int _type;
	NSString *_username;
	
	DILoadOverlay *_loadOverlay;
	
	NSString *_photoDate;
	BOOL _isCameraPic;
}

-(id)initWithType:(int)type withUsername:(NSString *)username;

@end
