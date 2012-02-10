//
//  DIAppTypeViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.24.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAppTypeViewController.h"
#import "DIAppDelegate.h"
#import "DINavTitleView.h"
#import "DINavLeftBtnView.h"

#import "DIUsernameViewController.h"

@implementation DIAppTypeViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"device setup"] autorelease];
		
		//DINavLeftBtnView *backBtnView = [[[DINavLeftBtnView alloc] initWithLabel:@"Back"] autorelease];
		//[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		//self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fue_background.jpg"]] autorelease];
	[self.view addSubview:bgImgView];
	
	UILabel *instructLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 42, 300, 20)] autorelease];
	instructLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:16];
	instructLabel.textColor = [DIAppDelegate diColor333333];
	instructLabel.backgroundColor = [UIColor clearColor];
	instructLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	instructLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	instructLabel.textAlignment = UITextAlignmentCenter;
	instructLabel.text = @"please select your account type";
	[self.view addSubview:instructLabel];
	
	UIButton *masterSignupButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	masterSignupButton.frame = CGRectMake(20, 93, 282, 82);
	[masterSignupButton setBackgroundImage:[[UIImage imageNamed:@"fue_buttonTop_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[masterSignupButton setBackgroundImage:[[UIImage imageNamed:@"fue_buttonTop_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	masterSignupButton.titleLabel.font = [[DIAppDelegate diOpenSansFontBold] fontWithSize:16];
	masterSignupButton.titleLabel.shadowColor = [UIColor blackColor];
	masterSignupButton.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	[masterSignupButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -95, 0, 95)];
	[masterSignupButton setImageEdgeInsets:UIEdgeInsetsMake(0, 135, 0, -135)];
	[masterSignupButton setImage:[UIImage imageNamed:@"fueArrow.png"] forState:UIControlStateNormal];
	[masterSignupButton setTitle:@"Parent" forState:UIControlStateNormal];
	[masterSignupButton addTarget:self action:@selector(_goMaster) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:masterSignupButton];
	
	UIButton *subSignupButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	subSignupButton.frame = CGRectMake(20, 175, 282, 82);
	[subSignupButton setBackgroundImage:[[UIImage imageNamed:@"fue_buttonBottom_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[subSignupButton setBackgroundImage:[[UIImage imageNamed:@"fue_buttonBottom_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	subSignupButton.titleLabel.font = [[DIAppDelegate diOpenSansFontBold] fontWithSize:16];
	subSignupButton.titleLabel.shadowColor = [UIColor blackColor];
	subSignupButton.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	[subSignupButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -105, 0, 105)];
	[subSignupButton setImageEdgeInsets:UIEdgeInsetsMake(0, 121, 0, -121)];
	[subSignupButton setImage:[UIImage imageNamed:@"fueArrow.png"] forState:UIControlStateNormal];
	[subSignupButton setTitle:@"Kid" forState:UIControlStateNormal];
	[subSignupButton addTarget:self action:@selector(_goSub) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:subSignupButton];
	
	
	UIButton *giftSignupButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	giftSignupButton.frame = CGRectMake(129, 280, 170, 16);
	giftSignupButton.titleLabel.font = [[DIAppDelegate diOpenSansFontSemibold] fontWithSize:11];
	[giftSignupButton setTitleColor:[DIAppDelegate diColor666666] forState:UIControlStateNormal];
	[giftSignupButton setTitleColor:[DIAppDelegate diColor666666] forState:UIControlStateSelected];
	[giftSignupButton setTitle:@"Are you here to gift someone?" forState:UIControlStateNormal];
	[giftSignupButton addTarget:self action:@selector(_goGift) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:giftSignupButton];
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
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
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)_goMaster {
	[self.navigationController pushViewController:[[[DIUsernameViewController alloc] initWithType:1] autorelease] animated:YES];
}

-(void)_goSub {
	[self.navigationController pushViewController:[[[DIUsernameViewController alloc] initWithType:3] autorelease] animated:YES];
}

-(void)_goGift {
	[self.navigationController pushViewController:[[[DIUsernameViewController alloc] initWithType:2] autorelease] animated:YES];
}


@end
