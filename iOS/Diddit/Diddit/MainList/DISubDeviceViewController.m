//
//  DISubDeviceViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.31.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DISubDeviceViewController.h"
#import "DIAppDelegate.h"

@implementation DISubDeviceViewController

#pragma mark - View lifecycle
-(id)initWithDevice:(DIDevice *)device {
	if ((self = [super init])) {
		_device = device;
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	_deviceImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subdevice_BG.png"]];
	CGRect frame = _deviceImgView.frame;
	frame.origin.x = 90;
	frame.origin.y = 50;
	_deviceImgView.frame = frame;
	[self.view addSubview:_deviceImgView];
	
	_deviceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 210, 280, 52)];
	_deviceNameLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:32];
	_deviceNameLabel.textColor = [UIColor colorWithRed:0.243 green:0.259 blue:0.247 alpha:1.0];
	_deviceNameLabel.backgroundColor = [UIColor clearColor];
	_deviceNameLabel.textAlignment = UITextAlignmentCenter;
	_deviceNameLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	_deviceNameLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	_deviceNameLabel.text = _device.device_name;
	[self.view addSubview:_deviceNameLabel];
	
	
	_infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, 280, 50)];
	_infoLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:20];
	_infoLabel.textColor = [UIColor colorWithRed:0.243 green:0.259 blue:0.247 alpha:1.0];
	_infoLabel.backgroundColor = [UIColor clearColor];
	_infoLabel.textAlignment = UITextAlignmentCenter;
	_infoLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	_infoLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	_infoLabel.numberOfLines = 0;
	_infoLabel.text = [NSString stringWithFormat:@"%@ currently has %@ didds available to use", _device.device_name, @"1,500"];
	[self.view addSubview:_infoLabel];
	
	_rewardButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_rewardButton.frame = CGRectMake(110, 300, 100, 34);
	_rewardButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
	[_rewardButton setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[_rewardButton setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[_rewardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	_rewardButton.titleLabel.shadowColor = [UIColor blackColor];
	_rewardButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	[_rewardButton setTitle:@"Tap screen to reward" forState:UIControlStateNormal];
	[_rewardButton addTarget:self action:@selector(_goAddReward) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_rewardButton];
	
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc {
	[super dealloc];
}


#pragma mark - Navigation
-(void)_goAddReward {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PRESENT_ADD_CHORE" object:nil];
}

@end
