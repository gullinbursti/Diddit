//
//  DISyncSubViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.24.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DISyncSubViewController.h"
#import "DIAppDelegate.h"
#import "DINavTitleView.h"
#import "DINavBackBtnView.h"
#import "DIWhySignupViewController.h"

@implementation DISyncSubViewController


#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"device setup"] autorelease];
		
		DINavBackBtnView *backBtnView = [[[DINavBackBtnView alloc] init] autorelease];
		[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
	}
	
	return (self);
}


-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fue_background.jpg"]] autorelease];
	CGRect frame = bgImgView.frame;
	frame.origin.y = -20;
	bgImgView.frame = frame;
	[self.view addSubview:bgImgView];
	
	UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 33, 320, 20)] autorelease];
	titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:14];
	titleLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	titleLabel.text = @"enter the provided 3 digit passcode";
	titleLabel.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:titleLabel];
	
	UIImageView *digit1ImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inputBG.png"]] autorelease];
	frame = digit1ImgView.frame;
	frame.origin.x = 20;
	frame.origin.y = 70;
	digit1ImgView.frame = frame;
	[self.view addSubview:digit1ImgView];
	
	UIImageView *digit2ImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inputBG.png"]] autorelease];
	frame = digit2ImgView.frame;
	frame.origin.x = 125;
	frame.origin.y = 70;
	digit2ImgView.frame = frame;
	[self.view addSubview:digit2ImgView];
	
	UIImageView *digit3ImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inputBG.png"]] autorelease];
	frame = digit3ImgView.frame;
	frame.origin.x = 225;
	frame.origin.y = 70;
	digit3ImgView.frame = frame;
	[self.view addSubview:digit3ImgView];
	
	_digit1TxtField = [[UITextField alloc] initWithFrame:CGRectMake(50, 85, 30, 80)];
	[_digit1TxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_digit1TxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_digit1TxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_digit1TxtField setBackgroundColor:[UIColor clearColor]];
	[_digit1TxtField setTextColor:[UIColor whiteColor]];
	[_digit1TxtField setSecureTextEntry:YES];	
	_digit1TxtField.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:30];
	_digit1TxtField.keyboardType = UIKeyboardTypeNumberPad;
	_digit1TxtField.clearsOnBeginEditing = YES;
	_digit1TxtField.tag = 0;
	_digit1TxtField.delegate = self;
	[self.view addSubview:_digit1TxtField];
	
	_digit2TxtField = [[UITextField alloc] initWithFrame:CGRectMake(150, 85, 30, 80)];
	[_digit2TxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_digit2TxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_digit2TxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_digit2TxtField setBackgroundColor:[UIColor clearColor]];
	[_digit2TxtField setTextColor:[UIColor whiteColor]];
	[_digit2TxtField setSecureTextEntry:YES];
	_digit2TxtField.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:30];
	_digit2TxtField.keyboardType = UIKeyboardTypeNumberPad;
	_digit2TxtField.clearsOnBeginEditing = YES;
	_digit2TxtField.tag = 1;
	_digit2TxtField.delegate = self;
	[self.view addSubview:_digit2TxtField];
		
	_digit3TxtField = [[UITextField alloc] initWithFrame:CGRectMake(250, 85, 30, 80)];
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
	
	UIButton *helpButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	helpButton.frame = CGRectMake(68, 160, 187, 28);
	helpButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
	[helpButton setBackgroundImage:[[UIImage imageNamed:@"infoButtonBG.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
	[helpButton setBackgroundImage:[[UIImage imageNamed:@"infoButtonBG.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
	[helpButton setTitleColor:[UIColor colorWithWhite:0.2588 alpha:1.0] forState:UIControlStateNormal];
	[helpButton setTitle:@"What if I don't have a passcode?" forState:UIControlStateNormal];
	[helpButton addTarget:self action:@selector(_goInfo) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:helpButton];
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
	
	[_digit1TxtField becomeFirstResponder];
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidUnload {
	if ([_digit1TxtField isFirstResponder])
		[_digit1TxtField resignFirstResponder];
	
	if ([_digit2TxtField isFirstResponder])
		[_digit2TxtField resignFirstResponder];
	
	if ([_digit3TxtField isFirstResponder])
		[_digit3TxtField resignFirstResponder];
	
	[super viewDidUnload];
}

#pragma mark - Navigation
-(void)_goBack {
	
	// back to root
	//[self dismissViewControllerAnimated:YES completion:nil];
	
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)goSubmit {
	_loadOverlay = [[DILoadOverlay alloc] init];
	
	_enteredCode = [NSString stringWithFormat:@"%@%@%@", _digit1TxtField.text, _digit2TxtField.text, _digit3TxtField.text];
	
	if (![DIAppDelegate deviceToken])
		[DIAppDelegate setDeviceToken:[NSString stringWithFormat:@"%064d", 0]];
	
	ASIFormDataRequest *syncDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
	[syncDataRequest setPostValue:[NSString stringWithFormat:@"%d", 6] forKey:@"action"];
	[syncDataRequest setPostValue:[DIAppDelegate deviceUUID] forKey:@"uuID"];
	[syncDataRequest setPostValue:[UIDevice currentDevice].model forKey:@"model"];
	[syncDataRequest setPostValue:[UIDevice currentDevice].systemVersion forKey:@"os"];
	[syncDataRequest setPostValue:[DIAppDelegate deviceToken] forKey:@"uaID"];
	[syncDataRequest setPostValue:[UIDevice currentDevice].name forKey:@"deviceName"];
	[syncDataRequest setPostValue:[_enteredCode uppercaseString] forKey:@"pinCode"];
	[syncDataRequest setDelegate:self];
	[syncDataRequest startAsynchronous];
}


-(void)_goInfo {
	DIWhySignupViewController *whySignupViewController = [[[DIWhySignupViewController alloc] initWithTitle:@"why?" header:@"we will never release your info…" closeLabel:@"Done"] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:whySignupViewController] autorelease];
	[self.navigationController presentModalViewController:navigationController animated:YES];	
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
	
	return (YES);
}


-(void)dealloc {
	[super dealloc];
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
