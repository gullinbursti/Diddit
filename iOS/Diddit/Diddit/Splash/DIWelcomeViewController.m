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
	if ((self = [super init]))
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_dismissMe:) name:@"DISMISS_WELCOME_SCREEN" object:nil];
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor blackColor]];
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_logo.png"]];
	bgImgView.layer.cornerRadius = 16.0;
	bgImgView.layer.borderColor = [[UIColor blackColor] CGColor];
	bgImgView.clipsToBounds = YES;
	[self.view addSubview:bgImgView];
	
	
	UIImageView *footerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"footerBG.png"]];
	CGRect frame = footerImgView.frame;
	frame.origin.y = 480 - (frame.size.height + 15);
	footerImgView.frame = frame;
	[self.view addSubview:footerImgView];
	
	UIButton *signupBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	signupBtn.frame = CGRectMake(46, 414, 110, 33);
	signupBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:13.0];
	//signupBtn.titleEdgeInsets = UIEdgeInsetsMake(1, 0, -1, 0); //up
	[signupBtn setBackgroundImage:[[UIImage imageNamed:@"FUE_button_nonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[signupBtn setBackgroundImage:[[UIImage imageNamed:@"FUE_button_Active.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateHighlighted];
	[signupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	signupBtn.titleLabel.shadowColor = [UIColor blackColor];
	signupBtn.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	[signupBtn setTitle:@"Sign up" forState:UIControlStateNormal];
	[signupBtn addTarget:self action:@selector(_goSignup) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:signupBtn];
	
	UIButton *videoBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	videoBtn.frame = CGRectMake(164, 414, 110, 33);
	videoBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:13.0];
	//videoBtn.titleEdgeInsets = UIEdgeInsetsMake(-1, 0, 1, 0); //dn
	[videoBtn setBackgroundImage:[[UIImage imageNamed:@"FUE_button_nonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[videoBtn setBackgroundImage:[[UIImage imageNamed:@"FUE_button_Active.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateHighlighted];
	[videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	videoBtn.titleLabel.shadowColor = [UIColor blackColor];
	videoBtn.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	[videoBtn setTitle:@"Play video" forState:UIControlStateNormal];
	[videoBtn addTarget:self action:@selector(_goVideo) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:videoBtn];
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
	[self _goBack];
}


@end
