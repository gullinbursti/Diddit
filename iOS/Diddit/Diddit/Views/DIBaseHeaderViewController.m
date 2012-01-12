//
//  DIBaseHeaderViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIBaseHeaderViewController.h"

#import "DIAppDelegate.h"
#import "DINavTitleView.h"

@implementation DIBaseHeaderViewController

#pragma mark - View lifecycle
-(id)initWithTitle:(NSString *)titleTxt header:(NSString *)headerTxt {
	_titleTxt = titleTxt;
	_headerTxt = headerTxt;
	
	if ((self = [super init])) {
		self.navigationItem.titleView = [[DINavTitleView alloc] initWithTitle:titleTxt];
	}
	
	return (self);
}

-(void)loadBaseView {
	[super loadView];
}

-(void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor colorWithRed:0.988235294117647 green:0.988235294117647 blue:0.713725490196078 alpha:1.0]];
	
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
	headerView.backgroundColor = [UIColor colorWithRed:0.988235294117647 green:0.988235294117647 blue:0.713725490196078 alpha:1.0];
	[self.view addSubview:headerView];
	
	CGRect frame;
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];
	titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:16];
	titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	titleLabel.text = _headerTxt;
	titleLabel.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:titleLabel];
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
	frame = bgImgView.frame;
	frame.origin.y = 48;
	bgImgView.frame = frame;
	[self.view addSubview:bgImgView];
	
	UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
	frame = dividerImgView.frame;
	frame.origin.y = 48;
	dividerImgView.frame = frame;
	[self.view addSubview:dividerImgView];
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

@end
