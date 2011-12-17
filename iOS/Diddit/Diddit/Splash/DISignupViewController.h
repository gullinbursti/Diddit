//
//  DISignupViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.16.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIFormDataRequest.h"

@interface DISignupViewController : UIViewController <ASIHTTPRequestDelegate, UITextFieldDelegate> {
	
	UITextField *_emailTxtField;
	UITextField *_pinCode1TxtField;
	UITextField *_pinCode2TxtField;
	UITextField *_pinCode3TxtField;
	UITextField *_pinCode4TxtField;
}

@end
