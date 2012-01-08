//
//  DIPinCodeViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIBaseModalHeaderViewController.h"

#import "DIChore.h"

@interface DIPinCodeViewController : DIBaseModalHeaderViewController <UITextFieldDelegate> {
	
	UITextField *_digit1TxtField;
	UITextField *_digit2TxtField;
	UITextField *_digit3TxtField;
	UIButton *_submitButton;
	
	NSString *_pin;
	DIChore *_chore;
	
	BOOL _isSettings;
}

-(id)initWithPin:(NSString *)pin chore:(DIChore *)aChore fromSettings:(BOOL)isSettings;
//-(void)animateViewUp:(BOOL)isUp;

-(void)goSubmit;

@end
