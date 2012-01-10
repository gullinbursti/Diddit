//
//  DIBasePushHeaderViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIBasePushHeaderViewController.h"

#import "DIAppDelegate.h"
#import "DINavBackBtnView.h"

@implementation DIBasePushHeaderViewController

#pragma mark - View lifecycle
-(id)initWithTitle:(NSString *)titleTxt header:(NSString *)headerTxt backBtn:(NSString *)backTxt {
	if ((self = [super initWithTitle:titleTxt header:headerTxt])) {
		
		DINavBackBtnView *backBtnView = [[DINavBackBtnView alloc] init];
		[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
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
	[self.navigationController popViewControllerAnimated:YES];
}


@end
