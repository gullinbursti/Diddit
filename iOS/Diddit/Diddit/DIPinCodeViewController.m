//
//  DIPinCodeViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import "DIPinCodeViewController.h"

@implementation DIPinCodeViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 39)] autorelease];
		//headerLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:18.0];
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor];
		headerLabel.textColor = [UIColor whiteColor];
		headerLabel.shadowColor = [UIColor colorWithWhite:0.25 alpha:1.0];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		headerLabel.text = @"Pincode Entry";
		[headerLabel sizeToFit];
		self.navigationItem.titleView = headerLabel;
		
		UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		backButton.frame = CGRectMake(0, 0, 60.0, 30);
		[backButton setBackgroundImage:[[UIImage imageNamed:@"non_Active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateNormal];
		[backButton setBackgroundImage:[[UIImage imageNamed:@"active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateHighlighted];
		backButton.titleEdgeInsets = UIEdgeInsetsMake(-1.0, 1.0, 1.0, -1.0);
		//backButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
		[backButton setTitle:@"Back" forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
	}
	
	return (self);
}

-(id)initWithPin:(NSString *)pin {
	if ((self = [self init])) {
		_pin = pin;
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor colorWithWhite:0.33 alpha:1.0]];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(64, 32, 192, 32)];
	//label.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:11.0];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor colorWithWhite:0.0 alpha:1.0];
	label.text = @"Enter Pincode…";
	label.textAlignment = UITextAlignmentCenter;
	label.lineBreakMode = UILineBreakModeTailTruncation;
	[self.view addSubview:label];
	
	_digit1TxtField = [[[UITextField alloc] initWithFrame:CGRectMake(64, 80, 16, 64)] autorelease];
	[_digit1TxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_digit1TxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_digit1TxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_digit1TxtField setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
	[_digit1TxtField setSecureTextEntry:YES];	
	_digit1TxtField.keyboardType = UIKeyboardTypeNumberPad;
	_digit1TxtField.clearsOnBeginEditing = YES;
	_digit1TxtField.delegate = self;
	[self.view addSubview:_digit1TxtField];
	
	_digit2TxtField = [[[UITextField alloc] initWithFrame:CGRectMake(96, 80, 16, 64)] autorelease];
	[_digit2TxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_digit2TxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_digit2TxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_digit2TxtField setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
	[_digit2TxtField setSecureTextEntry:YES];
	_digit2TxtField.keyboardType = UIKeyboardTypeNumberPad;
	_digit2TxtField.clearsOnBeginEditing = YES;
	_digit2TxtField.delegate = self;
	[self.view addSubview:_digit2TxtField];
	
	_digit3TxtField = [[[UITextField alloc] initWithFrame:CGRectMake(128, 80, 16, 64)] autorelease];
	[_digit3TxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_digit3TxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_digit3TxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_digit3TxtField setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
	[_digit3TxtField setSecureTextEntry:YES];	
	_digit3TxtField.keyboardType = UIKeyboardTypeNumberPad;
	_digit3TxtField.clearsOnBeginEditing = YES;
	_digit3TxtField.delegate = self;
	[self.view addSubview:_digit3TxtField];
	
	_digit4TxtField = [[[UITextField alloc] initWithFrame:CGRectMake(160, 80, 16, 64)] autorelease];
	[_digit4TxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_digit4TxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_digit4TxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_digit4TxtField setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
	[_digit4TxtField setSecureTextEntry:YES];	
	_digit4TxtField.keyboardType = UIKeyboardTypeNumberPad;
	_digit4TxtField.clearsOnBeginEditing = YES;
	_digit4TxtField.delegate = self;
	[self.view addSubview:_digit4TxtField];
	
	_digitIndex = 0;
	_digits = [[NSArray alloc] initWithObjects:_digit1TxtField, _digit2TxtField, _digit3TxtField, _digit4TxtField, nil];
	
	[_digit1TxtField becomeFirstResponder];
	
	_submitButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_submitButton.frame = CGRectMake(32, 128, 256, 32);
	//_submitButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
	_submitButton.titleEdgeInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
	[_submitButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButton.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[_submitButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButtonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:7] forState:UIControlStateHighlighted];
	[_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_submitButton setTitle:@"Submit" forState:UIControlStateNormal];
	[_submitButton addTarget:self action:@selector(_goSubmit) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_submitButton];
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


#pragma mark - Event Handlers
-(void)_goSubmit {
	NSString *enteredCode = [NSString stringWithFormat:@"%@%@%@%@", _digit1TxtField.text, _digit2TxtField.text, _digit3TxtField.text, _digit4TxtField.text];
	
	[_digit1TxtField endEditing:YES];
	[_digit2TxtField endEditing:YES];
	[_digit3TxtField endEditing:YES];
	[_digit4TxtField endEditing:YES];
	
	if ([enteredCode isEqualToString:_pin]) {
		NSLog(@"CORRECT!!");
		
		[self dismissViewControllerAnimated:YES completion:^(void) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISS_CONFIRM_CHORE" object:nil];
		}];
	
	} else {
		NSLog(@"WRONG (%@ [%@])", enteredCode, _pin);
		
		_digit1TxtField.text = @"";
		_digit2TxtField.text = @"";
		_digit3TxtField.text = @"";
		_digit4TxtField.text = @"";
		
		[_digit1TxtField becomeFirstResponder];
	}
}


#pragma mark - TextField Delegates
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	if ([textField.text length] >= 1 && ![string isEqualToString:@""]) {
		textField.text = [textField.text substringToIndex:1];
		
		int oldIndex = _digitIndex;
		
		if ([textField.text length] == 1)
			_digitIndex++;
		
		if ([textField.text length] == 0)
			_digitIndex--;
		
		if (_digitIndex < 0)
			_digitIndex = 0;
		
		if (_digitIndex > 3)
			_digitIndex = 3;
		
		
		[(UITextField *)[_digits objectAtIndex:oldIndex] resignFirstResponder];
		[(UITextField *)[_digits objectAtIndex:_digitIndex] becomeFirstResponder];
		
		return (NO);
	}
	
	return (YES);
}

@end
