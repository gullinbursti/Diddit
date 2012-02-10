//
//  DIUsernameViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 02.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIFormDataRequest.h"
#import "DILoadOverlay.h"

@interface DIUsernameViewController : UIViewController <ASIHTTPRequestDelegate, UITextFieldDelegate> {
	
	UILabel *_usernameLabel;
	UITextField *_usernameTxtField;
	
	int _type;
	
	ASIFormDataRequest *_signupDataRequest;
	DILoadOverlay *_loadOverlay;
}

-(id)initWithType:(int)type;

@end
