//
//  DIAddChoreTypeViewController.m
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DIAddChoreTypeViewController.h"

#import "DIAppDelegate.h"
#import "DINavTitleView.h"
#import "DINavLeftBtnView.h"
#import "DIMyChoresViewCell.h"
#import "DIAddChoreTitleViewController.h"

#import "DIChore.h"

@implementation DIAddChoreTypeViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"add reward"] autorelease];
		
		DINavLeftBtnView *cancelBtnView = [[[DINavLeftBtnView alloc] initWithLabel:@"Cancel"] autorelease];
		[[cancelBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:cancelBtnView] autorelease];
	}
	
	return (self);
}



- (void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor blackColor]];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]] autorelease];
	[self.view addSubview:bgImgView];
	
	CGRect frame;
	
	_titleLbl = [[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 300, 64)] autorelease];
	_titleLbl.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:17];
	_titleLbl.textColor = [UIColor colorWithWhite:0.33 alpha:1.0];
	_titleLbl.backgroundColor = [UIColor clearColor];
	_titleLbl.shadowColor = [UIColor whiteColor];
	_titleLbl.shadowOffset = CGSizeMake(1.0, 1.0);
	_titleLbl.text = @"";
	[self.view addSubview:_titleLbl];
	
	//UIImageView *dividerImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]] autorelease];
	//frame = dividerImgView.frame;
	//frame.origin.y = 77;
	//dividerImgView.frame = frame;
	//[self.view addSubview:dividerImgView];
	
	UIImageView *butonsBGImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fue_backPlate.png"]] autorelease];
	frame = butonsBGImgView.frame;
	frame.origin.x = 20;
	frame.origin.y = 65;
	butonsBGImgView.frame = frame;
	[self.view addSubview:butonsBGImgView];
	
	UIButton *instantButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	instantButton.frame = CGRectMake(0, 70, 320, 59);
	instantButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	instantButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[instantButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[instantButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[instantButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	instantButton.titleLabel.shadowColor = [UIColor whiteColor];
	instantButton.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	[instantButton setTitle:@"Instant" forState:UIControlStateNormal];
	[instantButton addTarget:self action:@selector(_goInstantReward) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:instantButton];
	
	UIButton *choreButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	choreButton.frame = CGRectMake(0, 150, 320, 59);
	choreButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	choreButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[choreButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[choreButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[choreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	choreButton.titleLabel.shadowColor = [UIColor whiteColor];
	choreButton.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	[choreButton setTitle:@"Chore" forState:UIControlStateNormal];
	[choreButton addTarget:self action:@selector(_goChoreReward) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:choreButton];
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

-(void)dealloc {
	[_titleLbl release];
	
	[super dealloc];
}


#pragma mark - Navigation
-(void)_goInstantReward {
	DIChore *chore = [DIChore choreWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"id", @"", @"title", @"", @"info", @"", @"icoPath", @"00000000000000", @"imgPath", @"0000-00-00 00:00:00", @"expires", @"0", @"points", @"0", @"cost", @"2", @"type_id", nil]];
	[self.navigationController pushViewController:[[[DIAddChoreTitleViewController alloc] initWithChore:chore] autorelease] animated:YES];	
}

-(void)_goChoreReward {
	DIChore *chore = [DIChore choreWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"id", @"", @"title", @"", @"info", @"", @"icoPath", @"00000000000000", @"imgPath", @"0000-00-00 00:00:00", @"expires", @"0", @"points", @"0", @"cost", @"1", @"type_id", nil]];
	[self.navigationController pushViewController:[[[DIAddChoreTitleViewController alloc] initWithChore:chore] autorelease] animated:YES];
}


-(void)_goBack {
	[self dismissViewControllerAnimated:YES completion:nil];	
}


@end
