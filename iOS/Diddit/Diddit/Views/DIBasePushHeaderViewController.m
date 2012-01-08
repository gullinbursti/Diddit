//
//  DIBasePushHeaderViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIBasePushHeaderViewController.h"

#import "DIAppDelegate.h"

@implementation DIBasePushHeaderViewController

#pragma mark - View lifecycle
-(id)initWithTitle:(NSString *)titleTxt header:(NSString *)headerTxt backBtn:(NSString *)backTxt {
	if ((self = [super initWithTitle:titleTxt header:headerTxt])) {
		UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		backButton.frame = CGRectMake(0, 0, 59.0, 34);
		[backButton setBackgroundImage:[[UIImage imageNamed:@"headerBackButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[backButton setBackgroundImage:[[UIImage imageNamed:@"headerBackButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		backButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		backButton.titleLabel.shadowColor = [UIColor blackColor];
		backButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		backButton.titleEdgeInsets = UIEdgeInsetsMake(1, 4, -1, -4);
		[backButton setTitle:backTxt forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
	}
	
	return (self);
}


-(void)loadView {
	[super loadView];
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
	[self dismissModalViewControllerAnimated:YES];
}


@end
