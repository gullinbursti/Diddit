//
//  DIPinCodeViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIPinCodeViewController : UIViewController <UITextFieldDelegate> {
	
	UIView *_holderView;
	
	UITextField *_digit1TxtField;
	UITextField *_digit2TxtField;
	UITextField *_digit3TxtField;
	UITextField *_digit4TxtField;
	UIButton *_submitButton;
	
	NSArray *_digits;
	NSString *_pin;
	
	int _digitIndex;
}

-(id)initWithPin:(NSString *)pin;
//-(void)animateViewUp:(BOOL)isUp;

@end
