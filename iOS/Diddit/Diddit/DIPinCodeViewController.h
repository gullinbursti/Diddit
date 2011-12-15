//
//  DIPinCodeViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIChore.h"

@interface DIPinCodeViewController : UIViewController <UITextFieldDelegate> {
	
	UITextField *_digit1TxtField;
	UITextField *_digit2TxtField;
	UITextField *_digit3TxtField;
	UITextField *_digit4TxtField;
	UIButton *_submitButton;
	
	NSString *_pin;
	DIChore *_chore;
	
	BOOL _isNewChore;
}

-(id)initWithPin:(NSString *)pin chore:(DIChore *)aChore fromAdd:(BOOL)isAdd;
//-(void)animateViewUp:(BOOL)isUp;

@end
