//
//  DIWelcomeViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.16.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIWelcomeViewController.h"

#import "DIAppDelegate.h"
#import "DISignupViewController.h"
#import "DISplashVideoViewController.h"

@implementation DIWelcomeViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_dismissMe:) name:@"DISMISS_WELCOME_SCREEN" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_revealMe:) name:@"REVEAL_WELCOME_SCREEN" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_concealMe:) name:@"CONCEAL_WELCOME_SCREEN" object:nil];
	}
	return (self);
}

-(void)loadView {
	[super loadView];
	
	CGRect frame;
	[self.view setBackgroundColor:[UIColor blackColor]];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]] autorelease];
	[self.view addSubview:bgImgView];
	
	_footerImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fueFooterBG.png"]] autorelease];
	frame = _footerImgView.frame;
	frame.origin.y = self.view.frame.size.height;
	_footerImgView.frame = frame;
	[self.view addSubview:_footerImgView];
	
	
	_logoImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]] autorelease];
	frame = _logoImgView.frame;
	frame.origin.x = 93;
	frame.origin.y = 175;
	_logoImgView.frame = frame;
	//_logoImgView.alpha = 0.0;
	[self.view addSubview:_logoImgView];
	
	
	_signupBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_signupBtn.frame = CGRectMake(46, 479, 114, 39);
	_signupBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:14.0];
	_signupBtn.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 2, 0); //up
	[_signupBtn setBackgroundImage:[[UIImage imageNamed:@"FUE_button_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[_signupBtn setBackgroundImage:[[UIImage imageNamed:@"FUE_button_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[_signupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	_signupBtn.titleLabel.shadowColor = [UIColor blackColor];
	_signupBtn.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	[_signupBtn setTitle:@"Sign up" forState:UIControlStateNormal];
	[_signupBtn addTarget:self action:@selector(_goSignup) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_signupBtn];
	
	_videoBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_videoBtn.frame = CGRectMake(164, 479, 114, 39);
	_videoBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:14.0];
	_videoBtn.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
	[_videoBtn setBackgroundImage:[[UIImage imageNamed:@"FUE_button_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[_videoBtn setBackgroundImage:[[UIImage imageNamed:@"FUE_button_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[_videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	_videoBtn.titleLabel.shadowColor = [UIColor blackColor];
	_videoBtn.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	[_videoBtn setTitle:@"Play video" forState:UIControlStateNormal];
	[_videoBtn addTarget:self action:@selector(_goVideo) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_videoBtn];
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	[self.view addSubview:overlayImgView];
}

-(void)viewDidLoad {
	[super viewDidLoad];
	
	[UIView animateWithDuration:0.33 animations:^(void) {
		CGRect logoFrame = _logoImgView.frame;
		logoFrame.origin.y = _logoImgView.frame.origin.y - 70;
		_logoImgView.frame = logoFrame;
		//_logoImgView.alpha = 1.0;
		
		CGRect footerFrame = _footerImgView.frame;
		footerFrame.origin.y = footerFrame.origin.y - _footerImgView.frame.size.height;
		_footerImgView.frame = footerFrame;
		
		CGRect signupFrame = _signupBtn.frame;
		signupFrame.origin.y = signupFrame.origin.y - _footerImgView.frame.size.height;
		_signupBtn.frame = signupFrame;
		
		CGRect videoFrame = _videoBtn.frame;
		videoFrame.origin.y = videoFrame.origin.y - _footerImgView.frame.size.height;
		_videoBtn.frame = videoFrame;
		
	} completion:^(BOOL finished) {
//		[UIView animateWithDuration:0.33 animations:^(void) {
//			CGRect footerFrame = _footerImgView.frame;
//			footerFrame.origin.y = footerFrame.origin.y - _footerImgView.frame.size.height;
//			_footerImgView.frame = footerFrame;
//			
//			CGRect signupFrame = _signupBtn.frame;
//			signupFrame.origin.y = signupFrame.origin.y - _footerImgView.frame.size.height;
//			_signupBtn.frame = signupFrame;
//			
//			CGRect videoFrame = _videoBtn.frame;
//			videoFrame.origin.y = videoFrame.origin.y - _footerImgView.frame.size.height;
//			_videoBtn.frame = videoFrame;
//			
//		}];
	}];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

-(void)viewDidUnload {
	[super viewDidUnload];
}

-(void)dealloc {
	[_footerImgView release];
	[_signupBtn release];
	[_videoBtn release];
	[_logoImgView release];
	
	[super dealloc];
}


#pragma mark - Navigation
- (void)_goBack {
	[self dismissViewControllerAnimated:YES completion:nil];	
}

- (void)_goSignup {
	//[self dismissViewControllerAnimated:YES completion:nil];
	
	DISignupViewController *signupViewController = [[[DISignupViewController alloc] init] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:signupViewController] autorelease];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}


- (void)_goVideo {
	
	DISplashVideoViewController *splashVideoViewController = [[[DISplashVideoViewController alloc] init] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:splashVideoViewController] autorelease];
	[navigationController setNavigationBarHidden:YES];
	[self.navigationController presentModalViewController:navigationController animated:YES];
	
	//UIAlertView *videoAlert = [[UIAlertView alloc] initWithTitle:@"Coming Soon" message:@"This feature isn't available yet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
	//[videoAlert show];
	//[videoAlert release];
}


#pragma mark - Notification Handlers
-(void)_dismissMe:(NSNotification *)notification {
	[self dismissViewControllerAnimated:NO completion:nil];
}

-(void)_revealMe:(NSNotification *)notification {
	self.view.hidden = NO;
}

-(void)_concealMe:(NSNotification *)notification {
	self.view.hidden = YES;
}


@end
