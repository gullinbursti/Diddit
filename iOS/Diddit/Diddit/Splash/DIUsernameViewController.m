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
	
	UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 45, 280.0, 16)] autorelease];
	titleLabel.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:14.0];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor colorWithWhite:0.398 alpha:1.0];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.text = @"enter a username";
	[self.view addSubview:titleLabel];
	
	UIView *txtBGView = [[UIView alloc] initWithFrame:CGRectMake(25, 90, 275, 53)];
	txtBGView.backgroundColor = [UIColor whiteColor];
	txtBGView.layer.cornerRadius = 8.0;
	txtBGView.clipsToBounds = YES;
	txtBGView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
	txtBGView.layer.borderWidth = 1.0;
	[self.view addSubview:txtBGView];
	
	_usernameTxtField = [[[UITextField alloc] initWithFrame:CGRectMake(35, 107, 200, 64)] autorelease];
	[_usernameTxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_usernameTxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_usernameTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_usernameTxtField setBackgroundColor:[UIColor clearColor]];
	[_usernameTxtField setReturnKeyType:UIReturnKeyDone];
	[_usernameTxtField addTarget:self action:@selector(onTxtDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
	_usernameTxtField.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:16];
	_usernameTxtField.keyboardType = UIKeyboardTypeDefault;
	_usernameTxtField.text = @"";
	_usernameTxtField.placeholder = @"Enter username";
	[self.view addSubview:_usernameTxtField];
	
	
	UIButton *nextButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	nextButton.frame = CGRectMake(205, 170, 99, 54.0);
	[nextButton setBackgroundImage:[[UIImage imageNamed:@"submitUserButton_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	[nextButton setBackgroundImage:[[UIImage imageNamed:@"submitUserButton_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateSelected];
	nextButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:14.0];
	nextButton.titleLabel.textColor = [UIColor blackColor];
	nextButton.titleLabel.shadowColor = [UIColor blackColor];
	nextButton.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	//nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
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
	
	if (![DIAppDelegate deviceToken])
		[DIAppDelegate setDeviceToken:[NSString stringWithFormat:@"%064d", 0]];
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	ASIFormDataRequest *signupDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
	[signupDataRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
	[signupDataRequest setPostValue:[DIAppDelegate deviceUUID] forKey:@"uuID"];
	[signupDataRequest setPostValue:[UIDevice currentDevice].model forKey:@"model"];
	[signupDataRequest setPostValue:[UIDevice currentDevice].systemVersion forKey:@"os"];
	[signupDataRequest setPostValue:[DIAppDelegate deviceToken] forKey:@"uaID"];
	[signupDataRequest setPostValue:[UIDevice currentDevice].name forKey:@"deviceName"];
	[signupDataRequest setPostValue:_usernameTxtField.text forKey:@"username"];
	[signupDataRequest setPostValue:@"000" forKey:@"pin"];
	
	if (_type == 1)
		[signupDataRequest setPostValue:@"Y" forKey:@"master"];
	
	else
		[signupDataRequest setPostValue:@"N" forKey:@"master"];
	
	[signupDataRequest setDelegate:self];
	[signupDataRequest startAsynchronous];
}

-(void)onTxtDoneEditing:(id)sender {
	[self _goNext];
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
			
	@autoreleasepool {
		NSError *error = nil;
		NSDictionary *parsedUser = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
				
		if (error != nil)
			NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
				
		else {
			NSLog(@"NEW USER: %@", parsedUser);
			[DIAppDelegate setUserProfile:parsedUser];
		}
	}
			
	NSLog(@"USER ID:[%@]", [[DIAppDelegate profileForUser] objectForKey:@"id"]);
	
	[_loadOverlay remove];
	[self dismissViewControllerAnimated:YES completion:^(void) {
		
		if (_type == 1)
			[[NSNotificationCenter defaultCenter] postNotificationName:@"PRESENT_MASTER_LIST" object:nil];
		
		else
			[[NSNotificationCenter defaultCenter] postNotificationName:@"PRESENT_SUB_LIST" object:nil];
	}];
}


-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
	
	//[_delegates perform:@selector(jobList:didFailLoadWithError:) withObject:self withObject:request.error];
	//MBL_RELEASE_SAFELY(_jobListRequest);
}
@end
