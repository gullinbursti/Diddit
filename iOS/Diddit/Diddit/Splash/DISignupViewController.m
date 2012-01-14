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
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"sign up"] autorelease];
		
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
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]] autorelease];
	[self.view addSubview:bgImgView];
	
	
	UIImageView *dividerImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]] autorelease];
	CGRect frame = dividerImgView.frame;
	frame.origin.y = 68;
	dividerImgView.frame = frame;
	[self.view addSubview:dividerImgView];
	
	
	_emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, 200, 64)];
	_emailLabel.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:17];
	_emailLabel.textColor = [UIColor colorWithWhite:0.201 alpha:1.0];
	_emailLabel.backgroundColor = [UIColor clearColor];
	_emailLabel.shadowColor = [UIColor whiteColor];
	_emailLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	_emailLabel.text = @"enter email address";
	[self.view addSubview:_emailLabel];
	
	_emailTxtField = [[[UITextField alloc] initWithFrame:CGRectMake(10, 25, 300, 64)] autorelease];
	[_emailTxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_emailTxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_emailTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_emailTxtField setBackgroundColor:[UIColor clearColor]];
	_emailTxtField.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:17];
	_emailTxtField.textColor = [UIColor colorWithWhite:0.201 alpha:1.0];
	_emailTxtField.keyboardType = UIKeyboardTypeDefault;
	_emailTxtField.delegate = self;
	[self.view addSubview:_emailTxtField];
	
	UIButton *skipButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	skipButton.frame = CGRectMake(71, 100, 84, 37);
	skipButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
	[skipButton setBackgroundImage:[[UIImage imageNamed:@"skipButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[skipButton setBackgroundImage:[[UIImage imageNamed:@"skipButton_active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[skipButton setTitleColor:[UIColor colorWithWhite:0.609 alpha:1.0] forState:UIControlStateNormal];
	[skipButton setTitle:@"skip this" forState:UIControlStateNormal];
	[skipButton addTarget:self action:@selector(_goSkip) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:skipButton];
	
	UIButton *submitButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	submitButton.frame = CGRectMake(165, 100, 84, 37);
	submitButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
	[submitButton setBackgroundImage:[[UIImage imageNamed:@"submitButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[submitButton setBackgroundImage:[[UIImage imageNamed:@"submitButton_active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[submitButton setTitleColor:[UIColor colorWithWhite:0.2588 alpha:1.0] forState:UIControlStateNormal];
	[submitButton setTitle:@"sign up" forState:UIControlStateNormal];
	[submitButton addTarget:self action:@selector(_goSubmit) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:submitButton];
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
}

-(void)viewDidLoad {
	[super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[_emailTxtField becomeFirstResponder];
}

-(void)viewDidUnload {
	[_emailTxtField resignFirstResponder];
	
	[super viewDidUnload];
}

-(void)dealloc {
	[_emailLabel release];
	[_loadOverlay release];
	
	[super dealloc];
}


#pragma mark - Navigation
-(void)_goBack {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"REVEAL_WELCOME_SCREEN" object:nil];
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)_goSkip {
	NSLog(@"EMAIL:[%@]", _emailTxtField.text);
	NSLog(@"DEVICE ID:[%@]", [[DIAppDelegate profileForUser] objectForKey:@"device_id"]);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"CONCEAL_WELCOME_SCREEN" object:nil];
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	
	ASIFormDataRequest *userRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
	[userRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
	[userRequest setPostValue:[DIAppDelegate deviceToken] forKey:@"deviceID"];
	[userRequest setPostValue:_emailTxtField.text forKey:@"email"];
	[userRequest setPostValue:[NSString stringWithString:@"000"] forKey:@"pin"];
	[userRequest setDelegate:self];
	[userRequest startAsynchronous];
}

-(void)_goSubmit {
	
	BOOL isSubmit = YES;
	NSString *pinCode = [NSString stringWithString:@"000"];
	//NSString *pinCode = [NSString stringWithFormat:@"%@%@%@%@", _pinCode1TxtField.text, _pinCode2TxtField.text, _pinCode3TxtField.text, _pinCode4TxtField.text];
	
	if (![DIAppDelegate deviceToken])
		[DIAppDelegate setDeviceToken:[NSString stringWithFormat:@"%064d", 0]];
	
	if (![DIAppDelegate validateEmail:_emailTxtField.text])
		isSubmit = NO;
	
	if ([pinCode length] != 3)
		isSubmit = NO;
	
	if (isSubmit) {
		NSLog(@"EMAIL:[%@]", _emailTxtField.text);
		NSLog(@"PIN:[%@]", pinCode);
		NSLog(@"DEVICE ID:[%@]", [[DIAppDelegate profileForUser] objectForKey:@"device_id"]);
		
		_loadOverlay = [[DILoadOverlay alloc] init];
		
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
	
//	if ([textField.text length] >= 1 && ![string isEqualToString:@""]) {
//		textField.text = [textField.text substringToIndex:1];
//		
//		if (textField.tag == 0) {
//			[_pinCode1TxtField resignFirstResponder];
//			[_pinCode2TxtField becomeFirstResponder];
//		}
//		
//		if (textField.tag == 1) {
//			[_pinCode2TxtField resignFirstResponder];
//			[_pinCode3TxtField becomeFirstResponder];
//		}
//		
//		if (textField.tag == 2) {
//			[_pinCode3TxtField resignFirstResponder];
//			[_pinCode4TxtField becomeFirstResponder];
//		}
//		
//		return (NO);
//	}
//	
//	return (YES);
	
	if ([textField.text length] == 0)
		_emailLabel.hidden = YES;
	
	return (YES);
}

-(void)textFieldDidEndEditing:(UITextField *)textField {	
	if ([textField.text length] == 0)
		_emailLabel.hidden = NO;
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
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"CONCEAL_WELCOME_SCREEN" object:nil];
			[self dismissViewControllerAnimated:YES completion:^(void) {
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISS_WELCOME_SCREEN" object:nil];
			}];
		}
	}
	
	[_loadOverlay remove];
}


-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
	
		//[_delegates perform:@selector(jobList:didFailLoadWithError:) withObject:self withObject:request.error];
		//MBL_RELEASE_SAFELY(_jobListRequest);
}

@end
