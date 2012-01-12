//
//  DISignupViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.16.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import "DISignupViewController.h"

#import "DIAppDelegate.h"
#import "DINavTitleView.h"

@implementation DISignupViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		self.navigationItem.titleView = [[DINavTitleView alloc] initWithTitle:@"sign up"];
		
		UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
		cancelButton.frame = CGRectMake(0, 0, 59.0, 34);
		[cancelButton setBackgroundImage:[[UIImage imageNamed:@"headerButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[cancelButton setBackgroundImage:[[UIImage imageNamed:@"headerButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		cancelButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		cancelButton.titleLabel.shadowColor = [UIColor blackColor];
		cancelButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
		[cancelButton addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:cancelButton] autorelease];
		
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor blackColor]];
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
	[self.view addSubview:bgImgView];
	
	
	UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
	CGRect frame = dividerImgView.frame;
	frame.origin.y = 68;
	dividerImgView.frame = frame;
	[self.view addSubview:dividerImgView];
	
	_emailTxtField = [[[UITextField alloc] initWithFrame:CGRectMake(10, 25, 300, 64)] autorelease];
	[_emailTxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_emailTxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_emailTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_emailTxtField setBackgroundColor:[UIColor clearColor]];
	_emailTxtField.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:16];
	_emailTxtField.keyboardType = UIKeyboardTypeURL;
	_emailTxtField.placeholder = @"enter email address";
	[self.view addSubview:_emailTxtField];
	
	/*
	UILabel *pinCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 80, 70, 20)];
	//pinCodeLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12];
	pinCodeLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
	pinCodeLabel.backgroundColor = [UIColor clearColor];
	pinCodeLabel.text = @"Pincode:";
	[self.view addSubview:pinCodeLabel];
	
	_pinCode1TxtField = [[[UITextField alloc] initWithFrame:CGRectMake(128, 80, 16, 64)] autorelease];
	[_pinCode1TxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_pinCode1TxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_pinCode1TxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_pinCode1TxtField setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
	[_pinCode1TxtField setSecureTextEntry:YES];	
	_pinCode1TxtField.keyboardType = UIKeyboardTypeNumberPad;
	_pinCode1TxtField.clearsOnBeginEditing = YES;
	_pinCode1TxtField.tag = 0;
	_pinCode1TxtField.delegate = self;
	[self.view addSubview:_pinCode1TxtField];
	
	_pinCode2TxtField = [[[UITextField alloc] initWithFrame:CGRectMake(160, 80, 16, 64)] autorelease];
	[_pinCode2TxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_pinCode2TxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_pinCode2TxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_pinCode2TxtField setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
	[_pinCode2TxtField setSecureTextEntry:YES];
	_pinCode2TxtField.keyboardType = UIKeyboardTypeNumberPad;
	_pinCode2TxtField.clearsOnBeginEditing = YES;
	_pinCode2TxtField.tag = 1;
	_pinCode2TxtField.delegate = self;
	[self.view addSubview:_pinCode2TxtField];
	
	_pinCode3TxtField = [[[UITextField alloc] initWithFrame:CGRectMake(192, 80, 16, 64)] autorelease];
	[_pinCode3TxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_pinCode3TxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_pinCode3TxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_pinCode3TxtField setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
	[_pinCode3TxtField setSecureTextEntry:YES];	
	_pinCode3TxtField.keyboardType = UIKeyboardTypeNumberPad;
	_pinCode3TxtField.clearsOnBeginEditing = YES;
	_pinCode3TxtField.tag = 2;
	_pinCode3TxtField.delegate = self;
	[self.view addSubview:_pinCode3TxtField];
	
	_pinCode4TxtField = [[[UITextField alloc] initWithFrame:CGRectMake(224, 80, 16, 64)] autorelease];
	[_pinCode4TxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_pinCode4TxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_pinCode4TxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_pinCode4TxtField setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
	[_pinCode4TxtField setSecureTextEntry:YES];	
	_pinCode4TxtField.keyboardType = UIKeyboardTypeNumberPad;
	_pinCode4TxtField.clearsOnBeginEditing = YES;
	_pinCode4TxtField.tag = 3;
	_pinCode4TxtField.delegate = self;
	[self.view addSubview:_pinCode4TxtField];
	*/
	
	[_emailTxtField becomeFirstResponder];
	
	UIButton *submitButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	submitButton.frame = CGRectMake(97, 100, 126, 34);
	submitButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
	[submitButton setBackgroundImage:[[UIImage imageNamed:@"genericButton_nonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[submitButton setBackgroundImage:[[UIImage imageNamed:@"genericButton_Active.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateHighlighted];
	[submitButton setTitleColor:[UIColor colorWithWhite:0.2588 alpha:1.0] forState:UIControlStateNormal];
	[submitButton setTitleColor:[UIColor colorWithWhite:0.2588 alpha:1.0] forState:UIControlStateSelected];
	[submitButton setTitle:@"Sign up now" forState:UIControlStateNormal];
	[submitButton addTarget:self action:@selector(_goSubmit) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:submitButton];
}

-(void)viewDidLoad {
	[super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

-(void)viewDidUnload {
	[super viewDidUnload];
}

-(void)dealloc {
	[super dealloc];
}


#pragma mark - Navigation
- (void)_goBack {
	[self dismissViewControllerAnimated:YES completion:nil];	
}

- (void)_goSubmit {
	
	BOOL isSubmit = YES;
	NSString *pinCode = [NSString stringWithString:@"0000"];
	//NSString *pinCode = [NSString stringWithFormat:@"%@%@%@%@", _pinCode1TxtField.text, _pinCode2TxtField.text, _pinCode3TxtField.text, _pinCode4TxtField.text];
	
	if (![DIAppDelegate deviceToken])
		[DIAppDelegate setDeviceToken:[NSString stringWithFormat:@"%064d", 0]];
	
	if ([_emailTxtField.text length] == 0)
	isSubmit = NO;
	
	if ([pinCode length] != 4)
		isSubmit = NO;
	
	if (isSubmit) {
		NSLog(@"EMAIL:[%@]", _emailTxtField.text);
		NSLog(@"PIN:[%@]", pinCode);
		NSLog(@"DEVICE ID:[%@]", [[DIAppDelegate profileForUser] objectForKey:@"device_id"]);
		
		_loadOverlayView = [[DILoadOverlayView alloc] init];
		[_loadOverlayView toggle:YES];
		
		ASIFormDataRequest *userRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
		[userRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
		[userRequest setPostValue:[DIAppDelegate deviceToken] forKey:@"deviceID"];
		[userRequest setPostValue:_emailTxtField.text forKey:@"email"];
		[userRequest setPostValue:pinCode forKey:@"pin"];
		[userRequest setDelegate:self];
		[userRequest startAsynchronous];
	}
}


#pragma mark - TextField Delegates
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	if ([textField.text length] >= 1 && ![string isEqualToString:@""]) {
		textField.text = [textField.text substringToIndex:1];
		
		if (textField.tag == 0) {
			[_pinCode1TxtField resignFirstResponder];
			[_pinCode2TxtField becomeFirstResponder];
		}
		
		if (textField.tag == 1) {
			[_pinCode2TxtField resignFirstResponder];
			[_pinCode3TxtField becomeFirstResponder];
		}
		
		if (textField.tag == 2) {
			[_pinCode3TxtField resignFirstResponder];
			[_pinCode4TxtField becomeFirstResponder];
		}
		
		return (NO);
	}
	
	return (YES);
}



#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	@autoreleasepool {
		NSError *error = nil;
		NSDictionary *parsedUser = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
		
		if (error != nil)
			NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
		
		else {
			NSLog(@"NEW USER: %@", parsedUser);
			[DIAppDelegate setUserProfile:parsedUser];
			
			[self dismissViewControllerAnimated:YES completion:^(void) {
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISS_WELCOME_SCREEN" object:nil];
			}];
		}
	}
	
	[_loadOverlayView toggle:NO];
}


-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlayView toggle:NO];
	
		//[_delegates perform:@selector(jobList:didFailLoadWithError:) withObject:self withObject:request.error];
		//MBL_RELEASE_SAFELY(_jobListRequest);
}

@end
