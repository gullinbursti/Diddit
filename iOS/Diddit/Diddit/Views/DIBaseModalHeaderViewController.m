//
//  DIBaseModalHeaderViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAppDelegate.h"

#import "DIBaseModalHeaderViewController.h"

@implementation DIBaseModalHeaderViewController

#pragma mark - View lifecycle
-(id)initWithTitle:(NSString *)titleTxt header:(NSString *)headerTxt closeLabel:(NSString *)closeLbl {
	_closeLbl = closeLbl;
	
	if ((self = [super initWithTitle:titleTxt header:headerTxt])) {
		UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		closeButton.frame = CGRectMake(0, 0, 59.0, 34);
		[closeButton setBackgroundImage:[[UIImage imageNamed:@"headerButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[closeButton setBackgroundImage:[[UIImage imageNamed:@"headerButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		closeButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		closeButton.titleLabel.shadowColor = [UIColor blackColor];
		closeButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		[closeButton setTitle:_closeLbl forState:UIControlStateNormal];
		[closeButton addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:closeButton] autorelease];
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
