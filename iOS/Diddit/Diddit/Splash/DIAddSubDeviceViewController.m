//
//  DIAddSubDeviceViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.24.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAddSubDeviceViewController.h"
#import "DIAppDelegate.h"
#import "DINavTitleView.h"
#import "DINavBackBtnView.h"

#import "DISyncCodeMakerViewController.h"


@implementation DIAddSubDeviceViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"add device"] autorelease];
		
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
	
	UIButton *iPodButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	iPodButton.frame = CGRectMake(0, 140, 320, 59);
	iPodButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	iPodButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	[iPodButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[iPodButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[iPodButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[iPodButton setTitle:@"iPod Touch" forState:UIControlStateNormal];
	[iPodButton addTarget:self action:@selector(_goPod) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:iPodButton];
	
	UIButton *iPhoneButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	iPhoneButton.frame = CGRectMake(0, 210, 320, 59);
	iPhoneButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	iPhoneButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	[iPhoneButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[iPhoneButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[iPhoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[iPhoneButton setTitle:@"iPhone" forState:UIControlStateNormal];
	[iPhoneButton addTarget:self action:@selector(_goPhone) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:iPhoneButton];
	
	UIButton *iPadButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	iPadButton.frame = CGRectMake(0, 280, 320, 59);
	iPadButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	iPadButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	[iPadButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[iPadButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[iPadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[iPadButton setTitle:@"iPad" forState:UIControlStateNormal];
	[iPadButton addTarget:self action:@selector(_goPad) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:iPadButton];
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
	
	// back to root
	//[self dismissViewControllerAnimated:YES completion:nil];
	
	[self.navigationController popViewControllerAnimated:YES];
}


-(void)_goPod {
	[self.navigationController pushViewController:[[[DISyncCodeMakerViewController alloc] init] autorelease] animated:YES];
}

-(void)_goPhone {
	[self.navigationController pushViewController:[[[DISyncCodeMakerViewController alloc] init] autorelease] animated:YES];
}

-(void)_goPad {
	[self.navigationController pushViewController:[[[DISyncCodeMakerViewController alloc] init] autorelease] animated:YES];
}


@end
