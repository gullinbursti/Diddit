//
//  DIBaseModalHeaderViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAppDelegate.h"
#import "DINavRightBtnView.h"

#import "DIBaseModalHeaderViewController.h"

@implementation DIBaseModalHeaderViewController

#pragma mark - View lifecycle
-(id)initWithTitle:(NSString *)titleTxt header:(NSString *)headerTxt closeLabel:(NSString *)closeLbl {
	_closeLbl = closeLbl;
	
	if ((self = [super initWithTitle:titleTxt header:headerTxt])) {
		
		DINavRightBtnView *closeBtnView = [[[DINavRightBtnView alloc] initWithLabel:closeLbl] autorelease];
		[[closeBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:closeBtnView] autorelease];
	}
	
	return (self);
}

-(void)loadBaseView {
	[super loadBaseView];
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
	[_closeLbl release];
	
	[super dealloc];
}

#pragma mark - Navigation
-(void)_goBack {
	[self dismissModalViewControllerAnimated:YES];
}

@end
