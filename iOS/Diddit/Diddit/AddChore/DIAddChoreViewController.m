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
#import "DINavTitleView.h"
#import "DINavLeftBtnView.h"
#import "DINavRightBtnView.h"
#import "DIMyChoresViewCell.h"
#import "DIChoreExpiresViewController.h"

#import "DIChore.h"

@implementation DIAddChoreViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"add chore"] autorelease];
		
		DINavLeftBtnView *cancelBtnView = [[[DINavLeftBtnView alloc] initWithLabel:@"Cancel"] autorelease];
		[[cancelBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:cancelBtnView] autorelease];
		
		
		DINavRightBtnView *nextBtnView = [[[DINavRightBtnView alloc] initWithLabel:@"Next"] autorelease];
		[[nextBtnView btn] addTarget:self action:@selector(_goNext) forControlEvents:UIControlEventTouchUpInside];		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:nextBtnView] autorelease];
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
	_titleLbl.text = @"give your chore a title";
	[self.view addSubview:_titleLbl];
	
	_titleTxtField = [[[UITextField alloc] initWithFrame:CGRectMake(10, 32, 200, 64)] autorelease];
	[_titleTxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_titleTxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_titleTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_titleTxtField setBackgroundColor:[UIColor clearColor]];
	_titleTxtField.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:17];
	_titleTxtField.keyboardType = UIKeyboardTypeDefault;
	_titleTxtField.delegate = self;
	[self.view addSubview:_titleTxtField];
	
	UIImageView *dividerImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]] autorelease];
	frame = dividerImgView.frame;
	frame.origin.y = 77;
	dividerImgView.frame = frame;
	[self.view addSubview:dividerImgView];
	
	_infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 160, 20)];
	_infoLbl.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	_infoLbl.textColor = [UIColor lightGrayColor];
	_infoLbl.backgroundColor = [UIColor clearColor];
	_infoLbl.text = @"additional note (optional)";
	[self.view addSubview:_infoLbl];
	
	_infoTxtView = [[[UITextView alloc] initWithFrame:CGRectMake(0, 75, 300, 160)] autorelease];
	[_infoTxtView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_infoTxtView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_infoTxtView setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_infoTxtView setBackgroundColor:[UIColor clearColor]];
	[_infoTxtView setTextColor:[UIColor colorWithWhite:0.67 alpha:1.0]];
	_infoTxtView.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	_infoTxtView.keyboardType = UIKeyboardTypeDefault;
	_infoTxtView.delegate = self;
	[self.view addSubview:_infoTxtView];
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
}

- (void)viewDidLoad {
	[_titleTxtField becomeFirstResponder];
	
	[super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewDidUnload {
	[_titleTxtField resignFirstResponder];
	
	[super viewDidUnload];
}

-(void)dealloc {
	//[_titleTxtField release];
	[_titleLbl release];
	[_infoLbl release];
	
	[super dealloc];
}

#pragma mark - Notification Handlers

#pragma mark - Navigation
-(void)_goBack {
	[self dismissViewControllerAnimated:YES completion:nil];	
}

-(void)_goNext {
	DIChore *chore = [DIChore choreWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"id", _titleTxtField.text, @"title", _infoTxtView.text, @"info", @"", @"icoPath", @"", @"imgPath", @"0000-00-00 00:00:00", @"expires", @"0", @"points", @"0", @"cost", nil]];
	[self.navigationController pushViewController:[[[DIChoreExpiresViewController alloc] initWithChore:chore] autorelease] animated:YES];
}

#pragma mark - TextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if ([textField.text length] == 0)
		_titleLbl.hidden = YES;
	
	return (YES);
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
	
	if ([textField.text length] == 0)
		_titleLbl.hidden = NO;
}

#pragma mark - TextView Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView {
	_infoLbl.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
	
	if ([textView.text length] == 0)
		_infoLbl.hidden = NO;
}

@end
