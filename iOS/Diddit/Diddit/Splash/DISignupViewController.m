//
//  DISignupViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.16.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import "DISignupViewController.h"

#import "DIWhySignupViewController.h"
#import "DINavRightBtnView.h"
#import "DIAppDelegate.h"
#import "DINavTitleView.h"

@implementation DISignupViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"get started"] autorelease];
		
		DINavRightBtnView *closeBtnView = [[[DINavRightBtnView alloc] initWithLabel:@"Cancel"] autorelease];
		[[closeBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:closeBtnView] autorelease];
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
	frame.origin.y = 77;
	dividerImgView.frame = frame;
	[self.view addSubview:dividerImgView];
	
	
	_usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 64)];
	_usernameLabel.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:16];
	_usernameLabel.textColor = [UIColor colorWithWhite:0.201 alpha:1.0];
	_usernameLabel.backgroundColor = [UIColor clearColor];
	_usernameLabel.shadowColor = [UIColor whiteColor];
	_usernameLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	_usernameLabel.text = @"enter your kids name";
	[self.view addSubview:_usernameLabel];
	
	_usernameTxtField = [[[UITextField alloc] initWithFrame:CGRectMake(10, 32, 300, 64)] autorelease];
	[_usernameTxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_usernameTxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_usernameTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_usernameTxtField setBackgroundColor:[UIColor clearColor]];
	_usernameTxtField.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:16];
	_usernameTxtField.textColor = [UIColor colorWithWhite:0.201 alpha:1.0];
	_usernameTxtField.keyboardType = UIKeyboardTypeDefault;
	_usernameTxtField.delegate = self;
	[self.view addSubview:_usernameTxtField];
	
	UIButton *whyButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	whyButton.frame = CGRectMake(71, 119, 84, 37);
	whyButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
	[whyButton setBackgroundImage:[[UIImage imageNamed:@"submitButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[whyButton setBackgroundImage:[[UIImage imageNamed:@"submitButton_active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[whyButton setTitleColor:[UIColor colorWithWhite:0.2588 alpha:1.0] forState:UIControlStateNormal];
	[whyButton setTitle:@"Why?" forState:UIControlStateNormal];
	[whyButton addTarget:self action:@selector(_goWhy) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:whyButton];
	
	UIButton *submitButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	submitButton.frame = CGRectMake(165, 119, 84, 37);
	submitButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
	[submitButton setBackgroundImage:[[UIImage imageNamed:@"submitButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[submitButton setBackgroundImage:[[UIImage imageNamed:@"submitButton_active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[submitButton setTitleColor:[UIColor colorWithWhite:0.2588 alpha:1.0] forState:UIControlStateNormal];
	[submitButton setTitle:@"Submit" forState:UIControlStateNormal];
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
	
	[_usernameTxtField becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

-(void)viewDidUnload {
	[_usernameTxtField resignFirstResponder];
	
	[super viewDidUnload];
}

-(void)dealloc {
	[_usernameLabel release];
	[_loadOverlay release];
	
	[super dealloc];
}


#pragma mark - Navigation
-(void)_goBack {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"REVEAL_WELCOME_SCREEN" object:nil];
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)_goWhy {
	DIWhySignupViewController *whySignupViewController = [[[DIWhySignupViewController alloc] initWithTitle:@"why?" header:@"we will never release your info…" closeLabel:@"Done"] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:whySignupViewController] autorelease];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}

-(void)_goSubmit {
	
	BOOL isSubmit = YES;
	NSString *pinCode = [NSString stringWithString:@"000"];
	//NSString *pinCode = [NSString stringWithFormat:@"%@%@%@%@", _pinCode1TxtField.text, _pinCode2TxtField.text, _pinCode3TxtField.text, _pinCode4TxtField.text];
	
	if (![DIAppDelegate deviceToken])
		[DIAppDelegate setDeviceToken:[NSString stringWithFormat:@"%064d", 0]];
	
	//if (![DIAppDelegate validateEmail:_usernameTxtField.text])
	//	isSubmit = NO;
	
	if ([_usernameTxtField.text length] == 0)
		isSubmit = NO;
	
	if ([pinCode length] != 3)
		isSubmit = NO;
	
	if (isSubmit) {
		NSLog(@"USERNAME:[%@]", _usernameTxtField.text);
		NSLog(@"PIN:[%@]", pinCode);
		NSLog(@"DEVICE ID:[%@]", [[DIAppDelegate profileForUser] objectForKey:@"device_id"]);
		
		_loadOverlay = [[DILoadOverlay alloc] init];
		
		ASIFormDataRequest *userRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
		[userRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
		[userRequest setPostValue:[DIAppDelegate deviceToken] forKey:@"deviceID"];
		[userRequest setPostValue:_usernameTxtField.text forKey:@"username"];
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
		_usernameLabel.hidden = YES;
	
	return (YES);
}

-(void)textFieldDidEndEditing:(UITextField *)textField {	
	if ([textField.text length] == 0)
		_usernameLabel.hidden = NO;
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
