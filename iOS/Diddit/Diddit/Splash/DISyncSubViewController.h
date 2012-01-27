//
//  DISyncSubViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.24.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIFormDataRequest.h"

@class DILoadOverlay;

@interface DISyncSubViewController : UIViewController <ASIHTTPRequestDelegate, UITextFieldDelegate> {
	DILoadOverlay *_loadOverlay;
	NSString *_enteredCode;
	
	UITextField *_digit1TxtField;
	UITextField *_digit2TxtField;
	UITextField *_digit3TxtField;
}

-(void)goSubmit;

@end
