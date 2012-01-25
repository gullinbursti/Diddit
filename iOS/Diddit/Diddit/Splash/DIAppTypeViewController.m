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
#import "DIAddSubDeviceViewController.h"
#import "DISyncSubViewController.h"

@implementation DIAppTypeViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"get started"] autorelease];
		
		DINavLeftBtnView *backBtnView = [[[DINavLeftBtnView alloc] initWithLabel:@"Back"] autorelease];
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
	
	UIButton *masterSignupButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	masterSignupButton.frame = CGRectMake(0, 200, 320, 59);
	masterSignupButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	masterSignupButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	[masterSignupButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[masterSignupButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[masterSignupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[masterSignupButton setTitle:@"parent signup" forState:UIControlStateNormal];
	[masterSignupButton addTarget:self action:@selector(_goMaster) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:masterSignupButton];
	
	UIButton *subSignupButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	subSignupButton.frame = CGRectMake(0, 280, 320, 59);
	subSignupButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	subSignupButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	[subSignupButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[subSignupButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[subSignupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[subSignupButton setTitle:@"device passcode" forState:UIControlStateNormal];
	[subSignupButton addTarget:self action:@selector(_goSub) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:subSignupButton];
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
	[self.navigationController pushViewController:[[[DIAddSubDeviceViewController alloc] init] autorelease] animated:YES];
}

-(void)_goSub {
	[self.navigationController pushViewController:[[[DISyncSubViewController alloc] init] autorelease] animated:YES];
}

@end
