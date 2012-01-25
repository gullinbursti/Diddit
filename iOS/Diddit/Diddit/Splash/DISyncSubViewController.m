//
//  DISyncSubViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.24.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DISyncSubViewController.h"
#import "DIAppDelegate.h"
#import "DINavTitleView.h"
#import "DINavBackBtnView.h"

@implementation DISyncSubViewController


#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"sync device"] autorelease];
		
		DINavBackBtnView *backBtnView = [[[DINavBackBtnView alloc] init] autorelease];
		[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
	}
	
	return (self);
}


-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fue_background.jpg"]] autorelease];
	CGRect frame = bgImgView.frame;
	frame.origin.y = -20;
	bgImgView.frame = frame;
	[self.view addSubview:bgImgView];
	
	_codeTxtField = [[[UITextField alloc] initWithFrame:CGRectMake(10, 32, 300, 64)] autorelease];
	[_codeTxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_codeTxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_codeTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_codeTxtField setBackgroundColor:[UIColor whiteColor]];
	_codeTxtField.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:16];
	_codeTxtField.textColor = [UIColor colorWithWhite:0.201 alpha:1.0];
	_codeTxtField.keyboardType = UIKeyboardTypeDefault;
	_codeTxtField.delegate = nil;
	[self.view addSubview:_codeTxtField];
	
	UIButton *submitButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	submitButton.frame = CGRectMake(0, 180, 320, 59);
	submitButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	submitButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	[submitButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[submitButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[submitButton setTitle:@"submit" forState:UIControlStateNormal];
	[submitButton addTarget:self action:@selector(_goSubmit) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:submitButton];
	
	
	[_codeTxtField becomeFirstResponder];
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
	
	// back to root
	//[self dismissViewControllerAnimated:YES completion:nil];
	
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)_goSubmit {
	_loadOverlay = [[DILoadOverlay alloc] init];
	
	if (![DIAppDelegate deviceToken])
		[DIAppDelegate setDeviceToken:[NSString stringWithFormat:@"%064d", 0]];
	
	ASIFormDataRequest *syncDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
	[syncDataRequest setPostValue:[NSString stringWithFormat:@"%d", 6] forKey:@"action"];
	[syncDataRequest setPostValue:[DIAppDelegate deviceUUID] forKey:@"uuID"];
	[syncDataRequest setPostValue:[UIDevice currentDevice].model forKey:@"model"];
	[syncDataRequest setPostValue:[UIDevice currentDevice].systemVersion forKey:@"os"];
	[syncDataRequest setPostValue:[DIAppDelegate deviceToken] forKey:@"uaID"];
	[syncDataRequest setPostValue:[UIDevice currentDevice].name forKey:@"deviceName"];
	[syncDataRequest setPostValue:_codeTxtField.text forKey:@"hex"];
	[syncDataRequest setDelegate:self];
	[syncDataRequest startAsynchronous];
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
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"CONCEAL_WELCOME_SCREEN" object:nil];
			[self dismissViewControllerAnimated:YES completion:^(void) {
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISS_WELCOME_SCREEN" object:nil];
			}];
		}
	}
	
	[_loadOverlay remove];
}


-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
	
	//[_delegates perform:@selector(jobList:didFailLoadWithError:) withObject:self withObject:request.error];
	//MBL_RELEASE_SAFELY(_jobListRequest);
}
@end
