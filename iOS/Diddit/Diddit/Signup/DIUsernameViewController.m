//
//  DIUsernameViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 02.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIUsernameViewController.h"
#import "DIAppDelegate.h"
#import "ASIFormDataRequest.h"

#import "DISignupPhotoViewController.h"

@implementation DIUsernameViewController

#pragma mark - View lifecycle
-(id)initWithType:(int)type {
	if ((self = [super init])) {
		_type = type;
	}
	
	return (self);
}


-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fue_background.jpg"]] autorelease];
	[self.view addSubview:bgImgView];
	
	UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 40, 280.0, 20)] autorelease];
	titleLabel.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:16.0];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [DIAppDelegate diColor333333];
	titleLabel.textAlignment = UITextAlignmentCenter;
	
	switch (_type) {
		case 1:
			titleLabel.text = @"enter your child's username";
			break;
			
		case 2:
			titleLabel.text = @"enter your giftee username";
			break;
			
		case 3:
			titleLabel.text = @"enter a username";
			break;
	}
	
	[self.view addSubview:titleLabel];
	
	UIView *txtBGView = [[UIView alloc] initWithFrame:CGRectMake(23, 94, 275, 53)];
	txtBGView.backgroundColor = [UIColor whiteColor];
	txtBGView.layer.cornerRadius = 8.0;
	txtBGView.clipsToBounds = YES;
	txtBGView.layer.borderColor = [[DIAppDelegate diColor666666] CGColor];
	txtBGView.layer.borderWidth = 1.0;
	[self.view addSubview:txtBGView];
	
	
	_usernameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(35, 108, 200, 24)] autorelease];
	_usernameLabel.font = [[DIAppDelegate diOpenSansFontSemibold] fontWithSize:16];
	_usernameLabel.textColor = [DIAppDelegate diColor666666];
	_usernameLabel.backgroundColor = [UIColor clearColor];
	_usernameLabel.text = @"Enter username";
	[self.view addSubview:_usernameLabel];
	
	_usernameTxtField = [[[UITextField alloc] initWithFrame:CGRectMake(35, 107, 200, 24)] autorelease];
	[_usernameTxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_usernameTxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_usernameTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_usernameTxtField setBackgroundColor:[UIColor clearColor]];
	[_usernameTxtField setReturnKeyType:UIReturnKeyDone];
	[_usernameTxtField addTarget:self action:@selector(onTxtDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
	[_usernameTxtField setTextColor:[DIAppDelegate diColor666666]];
	_usernameTxtField.font = [[DIAppDelegate diOpenSansFontSemibold] fontWithSize:16];
	_usernameTxtField.keyboardType = UIKeyboardTypeDefault;
	_usernameTxtField.delegate = self;
	_usernameTxtField.text = @"";
	[self.view addSubview:_usernameTxtField];
	
	
	UIButton *nextButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	nextButton.frame = CGRectMake(205, 168, 99, 54.0);
	[nextButton setBackgroundImage:[[UIImage imageNamed:@"submitUserButton_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	[nextButton setBackgroundImage:[[UIImage imageNamed:@"submitUserButton_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateSelected];
	nextButton.titleLabel.font = [[DIAppDelegate diOpenSansFontBold] fontWithSize:16.0];
	nextButton.titleLabel.shadowColor = [UIColor blackColor];
	nextButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	nextButton.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
	[nextButton setTitle:@"Next" forState:UIControlStateNormal];
	[nextButton addTarget:self action:@selector(_goNext) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:nextButton];
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
-(void)_goNext {
	[_usernameTxtField resignFirstResponder];
	
	[self.navigationController pushViewController:[[[DISignupPhotoViewController alloc] initWithType:_type withUsername:_usernameTxtField.text] autorelease] animated:YES];
}

-(void)onTxtDoneEditing:(id)sender {
	[self _goNext];
}

#pragma mark - TextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if ([textField.text length] == 0)
		_usernameLabel.hidden = YES;
	
	return (YES);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
	_usernameLabel.hidden = YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
	
	if ([textField.text length] == 0)
		_usernameLabel.hidden = NO;
	
	[textField resignFirstResponder];
}

@end
