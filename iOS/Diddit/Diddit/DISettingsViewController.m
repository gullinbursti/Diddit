//
//  DISettingsViewController.m
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import "DISettingsViewController.h"

@implementation DISettingsViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 39)] autorelease];
		//headerLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:18.0];
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor];
		headerLabel.textColor = [UIColor whiteColor];
		headerLabel.shadowColor = [UIColor colorWithWhite:0.25 alpha:1.0];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		headerLabel.text = @"Settings";
		[headerLabel sizeToFit];
		self.navigationItem.titleView = headerLabel;
	}
	
	return (self);
}

- (void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]] autorelease];
	[self.view addSubview:bgImgView];
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)dealloc {
	[super dealloc];
}

@end
