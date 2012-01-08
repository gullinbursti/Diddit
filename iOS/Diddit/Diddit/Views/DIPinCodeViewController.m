//
//  DIPinCodeViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import "DIPinCodeViewController.h"

#import "DIAppDelegate.h"
#import "DIAboutPinCodeViewController.h"
@implementation DIPinCodeViewController

#pragma mark - View lifecycle
-(id)initWithPin:(NSString *)pin chore:(DIChore *)aChore fromSettings:(BOOL)isSettings {
	if ((self = [super initWithTitle:@"passcode" header:@"parents, please approve the chore" closeLabel:@"Cancel"])) {
		_pin = pin;
		_chore = aChore;
		_isSettings = isSettings;
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	UIImageView *digit1ImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(20, 65.0, 78, 78)] autorelease];
	digit1ImgView.image = [UIImage imageNamed:@"passcodeBG.png"];
	[self.view addSubview:digit1ImgView];
	
	_digit1TxtField = [[[UITextField alloc] initWithFrame:CGRectMake(50, 85, 30, 80)] autorelease];
	[_digit1TxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_digit1TxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_digit1TxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_digit1TxtField setBackgroundColor:[UIColor clearColor]];
	[_digit1TxtField setTextColor:[UIColor colorWithWhite:0.67 alpha:1.0]];
	[_digit1TxtField setSecureTextEntry:YES];	
	_digit1TxtField.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:30];
	_digit1TxtField.keyboardType = UIKeyboardTypeNumberPad;
	_digit1TxtField.clearsOnBeginEditing = YES;
	_digit1TxtField.tag = 0;
	_digit1TxtField.delegate = self;
	[self.view addSubview:_digit1TxtField];
	
	UIImageView *digit2ImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(120, 65.0, 78, 78)] autorelease];
	digit2ImgView.image = [UIImage imageNamed:@"passcodeBG.png"];
	[self.view addSubview:digit2ImgView];

	_digit2TxtField = [[[UITextField alloc] initWithFrame:CGRectMake(150, 85, 30, 80)] autorelease];
	[_digit2TxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_digit2TxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_digit2TxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_digit2TxtField setBackgroundColor:[UIColor clearColor]];
	[_digit2TxtField setTextColor:[UIColor colorWithWhite:0.67 alpha:1.0]];
	[_digit2TxtField setSecureTextEntry:YES];
	_digit2TxtField.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:30];
	_digit2TxtField.keyboardType = UIKeyboardTypeNumberPad;
	_digit2TxtField.clearsOnBeginEditing = YES;
	_digit2TxtField.tag = 1;
	_digit2TxtField.delegate = self;
	[self.view addSubview:_digit2TxtField];
	
	UIImageView *digit3ImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(220, 65.0, 78, 78)] autorelease];
	digit3ImgView.image = [UIImage imageNamed:@"passcodeBG.png"];
	[self.view addSubview:digit3ImgView];

	_digit3TxtField = [[[UITextField alloc] initWithFrame:CGRectMake(250, 85, 30, 80)] autorelease];
	[_digit3TxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_digit3TxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_digit3TxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_digit3TxtField setBackgroundColor:[UIColor clearColor]];
	[_digit3TxtField setTextColor:[UIColor colorWithWhite:0.67 alpha:1.0]];
	[_digit3TxtField setSecureTextEntry:YES];
	_digit3TxtField.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:30];
	_digit3TxtField.keyboardType = UIKeyboardTypeNumberPad;
	_digit3TxtField.clearsOnBeginEditing = YES;
	_digit3TxtField.tag = 2;
	_digit3TxtField.delegate = self;
	[self.view addSubview:_digit3TxtField];
	
	[_digit1TxtField becomeFirstResponder];
	
	
	_submitButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_submitButton.frame = CGRectMake(10, 160, 200, 16);
	[_submitButton setShowsTouchWhenHighlighted:NO];
	[_submitButton addTarget:self action:@selector(_goInfo) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_submitButton];
	
	UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, 200, 16)];
	infoLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	infoLabel.textColor = [UIColor colorWithWhite:0.67 alpha:1.0];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.text = @"What is a passcode for?";
	[self.view addSubview:infoLabel];
	
	
	UIImageView *overlayImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]];
	CGRect frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
}


-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidUnload {
    [super viewDidUnload];
}

-(void)dealloc {
	[super dealloc];
}

#pragma mark - Animators
-(void)_pushViewUp:(BOOL)isUp {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	
	CGRect rect = self.view.frame;
	
	if (isUp) {
		rect.origin.y = -128;
		rect.size.height += 128;
	
	} else {
		rect.origin.y = 0;
		rect.size.height -= 128;
	}
	
	self.view.frame = rect;
	[UIView commitAnimations];
}

#pragma mark - Navigation
-(void)_goInfo {
	DIAboutPinCodeViewController *aboutPinCodeViewController = [[[DIAboutPinCodeViewController alloc] initWithTitle:@"passcode" header:@"what is a passcode for?" closeLabel:@"Done"] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:aboutPinCodeViewController] autorelease];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}

#pragma mark - Event Handlers
-(void)goSubmit {
	NSString *enteredCode = [NSString stringWithFormat:@"%@%@%@", _digit1TxtField.text, _digit2TxtField.text, _digit3TxtField.text];
	
	[_digit1TxtField endEditing:YES];
	[_digit2TxtField endEditing:YES];
	[_digit3TxtField endEditing:YES];
	
	if ([enteredCode isEqualToString:_pin]) {
		NSLog(@"CORRECT!!");
		
		if (_isSettings)
			[self.navigationController popViewControllerAnimated:YES];		
		
		else {
			[self.navigationController dismissViewControllerAnimated:YES completion:^(void) {
				[[NSNotificationCenter defaultCenter] postNotificationName:@"FINISH_CHORE" object:_chore];
			}];
		}
	
	} else {
		NSLog(@"WRONG (%@ [%@])", enteredCode, _pin);
		
		_digit1TxtField.text = @"";
		_digit2TxtField.text = @"";
		_digit3TxtField.text = @"";
		
		[_digit1TxtField becomeFirstResponder];
	}
}


#pragma mark - TextField Delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	//NSLog(@"textFieldShouldBeginEditing");
	
	return (YES);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
	//NSLog(@"textFieldDidBeginEditing");
	
	//if (textField.tag == 0) {
	//	[_digit1TxtField resignFirstResponder];
	//	[_digit2TxtField becomeFirstResponder];
	//}
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	//NSLog(@"textFieldShouldEndEditing");
	
	return (YES);
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
	//NSLog(@"textFieldDidEndEditing [%@]", _digit1TxtField.text);
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	if ([textField.text length] >= 1 && ![string isEqualToString:@""]) {
		textField.text = [textField.text substringToIndex:1];
		
		/*
		if ([textField.text length] == 1) {
			if ([_digit1TxtField isFirstResponder]) {
				[_digit1TxtField resignFirstResponder];
				[_digit2TxtField becomeFirstResponder];
			
			} else if ([_digit2TxtField isFirstResponder]) {
				[_digit2TxtField resignFirstResponder];
				[_digit3TxtField becomeFirstResponder];
				
			} else if ([_digit3TxtField isFirstResponder]) {
				[_digit3TxtField resignFirstResponder];
				[_digit4TxtField becomeFirstResponder];
				
			} else if ([_digit4TxtField isFirstResponder]) {
				[_digit4TxtField resignFirstResponder];
				[_digit1TxtField becomeFirstResponder];	
			}
		}
		*/
		if (textField.tag == 0) {
			[_digit1TxtField resignFirstResponder];
			[_digit2TxtField becomeFirstResponder];
		}
		
		if (textField.tag == 1) {
			[_digit2TxtField resignFirstResponder];
			[_digit3TxtField becomeFirstResponder];
		}
		
		if ((int)[_digit1TxtField.text length] + (int)[_digit2TxtField.text length] + (int)[_digit3TxtField.text length] == 3)
			[self goSubmit];
		
		
		return (NO);
	}
	
	/*
	if ([textField.text length] == 0) {
		if ([_digit1TxtField isFirstResponder]) {
			[_digit1TxtField resignFirstResponder];
			[_digit4TxtField becomeFirstResponder];
			
		} else if ([_digit2TxtField isFirstResponder]) {
			[_digit2TxtField resignFirstResponder];
			[_digit1TxtField becomeFirstResponder];
			
		} else if ([_digit3TxtField isFirstResponder]) {
			[_digit3TxtField resignFirstResponder];
			[_digit2TxtField becomeFirstResponder];
			
		} else if ([_digit4TxtField isFirstResponder]) {
			[_digit4TxtField resignFirstResponder];
			[_digit3TxtField becomeFirstResponder];	
		}
	}
	*/
	
	
	return (YES);
}

@end
