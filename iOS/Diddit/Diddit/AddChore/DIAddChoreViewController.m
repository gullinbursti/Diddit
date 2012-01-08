//
//  DIAddChoreViewController.m
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DIAddChoreViewController.h"

#import "DIAppDelegate.h"
#import "DIMyChoresViewCell.h"
#import "DIChoreExpiresViewController.h"
#import "DIConfirmChoreViewController.h"

#import "DIChore.h"

@implementation DIAddChoreViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 195, 40)];
		
		UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(-10, 3, 195, 40)] autorelease];
		headerLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor];
		headerLabel.textColor = [UIColor colorWithRed:0.184313725490196 green:0.537254901960784 blue:0.298039215686275 alpha:1.0];
		headerLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		headerLabel.text = @"add chore";
		
		[headerView addSubview:headerLabel];
		self.navigationItem.titleView = headerView;
		
		UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
		cancelButton.frame = CGRectMake(0, 0, 59.0, 34);
		[cancelButton setBackgroundImage:[[UIImage imageNamed:@"headerButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[cancelButton setBackgroundImage:[[UIImage imageNamed:@"headerButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		cancelButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		cancelButton.titleLabel.shadowColor = [UIColor blackColor];
		cancelButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
		[cancelButton addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:cancelButton] autorelease];
		
		
		UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
		nextButton.frame = CGRectMake(0, 0, 59.0, 34);
		[nextButton setBackgroundImage:[[UIImage imageNamed:@"headerButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[nextButton setBackgroundImage:[[UIImage imageNamed:@"headerButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		nextButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		nextButton.titleLabel.shadowColor = [UIColor blackColor];
		nextButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		[nextButton setTitle:@"Next" forState:UIControlStateNormal];
		[nextButton addTarget:self action:@selector(_goNext) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:nextButton] autorelease];
	}
	
	return (self);
}



- (void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor blackColor]];
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
	[self.view addSubview:bgImgView];
	
	CGRect frame;
	
	UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
	frame = dividerImgView.frame;
	frame.origin.y = 68;
	dividerImgView.frame = frame;
	[self.view addSubview:dividerImgView];

	_titleTxtField = [[[UITextField alloc] initWithFrame:CGRectMake(10, 25, 200, 64)] autorelease];
	[_titleTxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_titleTxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_titleTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_titleTxtField setBackgroundColor:[UIColor clearColor]];
	_titleTxtField.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:16];
	_titleTxtField.keyboardType = UIKeyboardTypeDefault;
	_titleTxtField.placeholder = @"give your chore a title";
	[self.view addSubview:_titleTxtField];
	
	_infoTxtField = [[[UITextField alloc] initWithFrame:CGRectMake(10, 75, 200, 64)] autorelease];
	[_infoTxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_infoTxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_infoTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_infoTxtField setBackgroundColor:[UIColor clearColor]];
	[_infoTxtField setTextColor:[UIColor colorWithWhite:0.67 alpha:1.0]];
	_infoTxtField.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	_infoTxtField.keyboardType = UIKeyboardTypeDefault;
	_infoTxtField.placeholder = @"additional note (optional)";
	[self.view addSubview:_infoTxtField];
	
	UIImageView *overlayImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]];
	frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
	
	[_titleTxtField becomeFirstResponder];
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

-(void)dealloc {
	[super dealloc];
}

#pragma mark - Notification Handlers

#pragma mark - Navigation
-(void)_goBack {
	[self dismissViewControllerAnimated:YES completion:nil];	
}

-(void)_goNext {
	DIChore *chore = [DIChore choreWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"id", _titleTxtField.text, @"title", _infoTxtField.text, @"info", @"", @"icoPath", @"", @"imgPath", @"0000-00-00 00:00:00", @"expires", @"0", @"points", @"0", @"cost", nil]];
	[self.navigationController pushViewController:[[[DIChoreExpiresViewController alloc] initWithChore:chore] autorelease] animated:YES];
}


@end
