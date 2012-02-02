//
//  DISyncCodeMakerViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.24.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DISyncCodeMakerViewController.h"
#import "DIAppDelegate.h"
#import "DINavTitleView.h"
#import "DINavBackBtnView.h"
#import "DINavRightBtnView.h"
#import "DIWhySignupViewController.h"

@implementation DISyncCodeMakerViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"device setup"] autorelease];
		
		DINavBackBtnView *backBtnView = [[[DINavBackBtnView alloc] init] autorelease];
		[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
		
		DINavRightBtnView *nextBtnView = [[[DINavRightBtnView alloc] initWithLabel:@"Next"] autorelease];
		[[nextBtnView btn] addTarget:self action:@selector(_goNext) forControlEvents:UIControlEventTouchUpInside];		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:nextBtnView] autorelease];
		
		if (![DIAppDelegate deviceToken])
			[DIAppDelegate setDeviceToken:[NSString stringWithFormat:@"%064d", 0]];
		
		_loadOverlay = [[DILoadOverlay alloc] init];
		_signupDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
		[_signupDataRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
		[_signupDataRequest setPostValue:[DIAppDelegate deviceUUID] forKey:@"uuID"];
		[_signupDataRequest setPostValue:[UIDevice currentDevice].model forKey:@"model"];
		[_signupDataRequest setPostValue:[UIDevice currentDevice].systemVersion forKey:@"os"];
		[_signupDataRequest setPostValue:[DIAppDelegate deviceToken] forKey:@"uaID"];
		[_signupDataRequest setPostValue:[UIDevice currentDevice].name forKey:@"deviceName"];
		[_signupDataRequest setPostValue:@"" forKey:@"username"];
		[_signupDataRequest setPostValue:@"000" forKey:@"pin"];
		[_signupDataRequest setDelegate:self];
		[_signupDataRequest startAsynchronous];
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
	
	UILabel *instructLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 30, 280, 32)] autorelease];
	instructLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:14];
	instructLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
	instructLabel.backgroundColor = [UIColor clearColor];
	instructLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	instructLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	instructLabel.textAlignment = UITextAlignmentCenter;
	instructLabel.numberOfLines = 0;
	instructLabel.text = @"use the following passcode to help your kids activate their devices";
	[self.view addSubview:instructLabel];
	
	UIImageView *digit1ImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inputBG.png"]] autorelease];
	frame = digit1ImgView.frame;
	frame.origin.x = 20;
	frame.origin.y = 100;
	digit1ImgView.frame = frame;
	[self.view addSubview:digit1ImgView];
	
	UIImageView *digit2ImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inputBG.png"]] autorelease];
	frame = digit2ImgView.frame;
	frame.origin.x = 125;
	frame.origin.y = 100;
	digit2ImgView.frame = frame;
	[self.view addSubview:digit2ImgView];
	
	UIImageView *digit3ImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inputBG.png"]] autorelease];
	frame = digit3ImgView.frame;
	frame.origin.x = 225;
	frame.origin.y = 100;
	digit3ImgView.frame = frame;
	[self.view addSubview:digit3ImgView];
	
	_digit1Label = [[[UILabel alloc] initWithFrame:CGRectMake(20.0, 110.0, 74.0, 52)] autorelease];
	_digit1Label.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:48.0];
	_digit1Label.backgroundColor = [UIColor clearColor];
	_digit1Label.textColor = [UIColor whiteColor];
	_digit1Label.textAlignment = UITextAlignmentCenter;
	_digit1Label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	_digit1Label.shadowOffset = CGSizeMake(1.0, 1.0);
	[self.view addSubview:_digit1Label];
	
	_digit2Label = [[[UILabel alloc] initWithFrame:CGRectMake(125.0, 110.0, 74.0, 52)] autorelease];
	_digit2Label.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:48.0];
	_digit2Label.backgroundColor = [UIColor clearColor];
	_digit2Label.textColor = [UIColor whiteColor];
	_digit2Label.textAlignment = UITextAlignmentCenter;
	_digit2Label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	_digit2Label.shadowOffset = CGSizeMake(1.0, 1.0);
	[self.view addSubview:_digit2Label];
	
	_digit3Label = [[[UILabel alloc] initWithFrame:CGRectMake(225.0, 110.0, 74.0, 52)] autorelease];
	_digit3Label.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:48.0];
	_digit3Label.backgroundColor = [UIColor clearColor];
	_digit3Label.textColor = [UIColor whiteColor];
	_digit3Label.textAlignment = UITextAlignmentCenter;
	_digit3Label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	_digit3Label.shadowOffset = CGSizeMake(1.0, 1.0);
	[self.view addSubview:_digit3Label];
	
	UIButton *shareButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	shareButton.frame = CGRectMake(88, 200, 147, 28);
	shareButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
	[shareButton setBackgroundImage:[[UIImage imageNamed:@"infoButtonBG.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[shareButton setBackgroundImage:[[UIImage imageNamed:@"infoButtonBG.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[shareButton setTitleColor:[UIColor colorWithWhite:0.2588 alpha:1.0] forState:UIControlStateNormal];
	[shareButton setTitle:@"Do you share a device?" forState:UIControlStateNormal];
	[shareButton addTarget:self action:@selector(_goShare) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:shareButton];
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	frame = overlayImgView.frame;
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


#pragma mark - Navigation
-(void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)_goNext {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"CONCEAL_WELCOME_SCREEN" object:nil];
	[self dismissViewControllerAnimated:YES completion:^(void) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISS_WELCOME_SCREEN" object:nil];
	}];
}

-(void)_goShare {
	DIWhySignupViewController *whySignupViewController = [[[DIWhySignupViewController alloc] initWithTitle:@"why?" header:@"we will never release your info…" closeLabel:@"Done"] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:whySignupViewController] autorelease];
	[self.navigationController presentModalViewController:navigationController animated:YES];	
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	if ([request isEqual:_codeDataRequest]) {
	
		@autoreleasepool {
			NSError *error = nil;
			NSDictionary *parsedCode = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				NSLog(@"SYNC CODE: %@", parsedCode);
				_digit1Label.text = [[parsedCode objectForKey:@"pin_code"] substringWithRange:NSMakeRange(0, 1)];
				_digit2Label.text = [[parsedCode objectForKey:@"pin_code"] substringWithRange:NSMakeRange(1, 1)];
				_digit3Label.text = [[parsedCode objectForKey:@"pin_code"] substringWithRange:NSMakeRange(2, 1)];
			}
		}
	
		[_loadOverlay remove];
	
	} else if ([request isEqual:_signupDataRequest]) {
		
		@autoreleasepool {
			NSError *error = nil;
			NSDictionary *parsedUser = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				NSLog(@"NEW USER: %@", parsedUser);
				[DIAppDelegate setUserProfile:parsedUser];
			}
		}
		
		NSLog(@"USER ID:[%@]", [[DIAppDelegate profileForUser] objectForKey:@"id"]);
		
		_codeDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
		[_codeDataRequest setPostValue:[NSString stringWithFormat:@"%d", 5] forKey:@"action"];
		[_codeDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[_codeDataRequest setDelegate:self];
		[_codeDataRequest startAsynchronous];
	}
}


-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
	
	//[_delegates perform:@selector(jobList:didFailLoadWithError:) withObject:self withObject:request.error];
	//MBL_RELEASE_SAFELY(_jobListRequest);
}


@end
