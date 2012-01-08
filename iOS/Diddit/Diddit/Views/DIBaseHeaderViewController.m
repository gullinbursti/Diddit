//
//  DIBaseHeaderViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIBaseHeaderViewController.h"

#import "DIAppDelegate.h"

@implementation DIBaseHeaderViewController

#pragma mark - View lifecycle
-(id)initWithTitle:(NSString *)titleTxt header:(NSString *)headerTxt {
	_titleTxt = titleTxt;
	_headerTxt = headerTxt;
	
	if ((self = [super init])) {
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 195, 40)];
		UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(-10, 3, 195, 40)] autorelease];
		headerLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor];
		headerLabel.textColor = [UIColor colorWithRed:0.184313725490196 green:0.537254901960784 blue:0.298039215686275 alpha:1.0];
		headerLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		headerLabel.text = _titleTxt;
		
		[headerView addSubview:headerLabel];
		self.navigationItem.titleView = headerView;
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor colorWithRed:0.988235294117647 green:0.988235294117647 blue:0.713725490196078 alpha:1.0]];
	CGRect frame;
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];
	titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:16];
	titleLabel.textColor = [UIColor colorWithWhite:0.67 alpha:1.0];
	titleLabel.backgroundColor = [UIColor clearColor];
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
