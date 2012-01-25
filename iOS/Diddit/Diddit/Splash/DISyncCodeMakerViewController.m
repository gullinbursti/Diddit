//
//  DISyncCodeMakerViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.24.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DISyncCodeMakerViewController.h"
#import "DIAppDelegate.h"
#import "DINavTitleView.h"
#import "DINavBackBtnView.h"
#import "DINavRightBtnView.h"

@implementation DISyncCodeMakerViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"enter passcode"] autorelease];
		
		DINavBackBtnView *backBtnView = [[[DINavBackBtnView alloc] init] autorelease];
		[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
		
		DINavRightBtnView *nextBtnView = [[[DINavRightBtnView alloc] initWithLabel:@"Next"] autorelease];
		[[nextBtnView btn] addTarget:self action:@selector(_goNext) forControlEvents:UIControlEventTouchUpInside];		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:nextBtnView] autorelease];
		
		if (![DIAppDelegate deviceToken])
			[DIAppDelegate setDeviceToken:[NSString stringWithFormat:@"%064d", 0]];
		
		_loadOverlay = [[DILoadOverlay alloc] init];
		_signupDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
		[_signupDataRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
		[_signupDataRequest setPostValue:[DIAppDelegate deviceUUID] forKey:@"uuID"];
		[_signupDataRequest setPostValue:[UIDevice currentDevice].model forKey:@"model"];
		[_signupDataRequest setPostValue:[UIDevice currentDevice].systemVersion forKey:@"os"];
		[_signupDataRequest setPostValue:[DIAppDelegate deviceToken] forKey:@"uaID"];
		[_signupDataRequest setPostValue:[UIDevice currentDevice].name forKey:@"deviceName"];
		[_signupDataRequest setPostValue:@"" forKey:@"username"];
		[_signupDataRequest setPostValue:@"000" forKey:@"pin"];
		[_signupDataRequest setDelegate:self];
		[_signupDataRequest startAsynchronous];
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
	
	NSString *code = [[DIAppDelegate md5:[NSString stringWithFormat:@"%d", arc4random()]] uppercaseString];
	
	_codeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20.0, 180.0, 280.0, 80)] autorelease];
	_codeLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:60.0];
	_codeLabel.backgroundColor = [UIColor clearColor];
	_codeLabel.textColor = [UIColor blackColor];
	_codeLabel.textAlignment = UITextAlignmentCenter;
	_codeLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	_codeLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	_codeLabel.text = [code substringToIndex:[code length] - 28];
	
	[self.view addSubview:_codeLabel];
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

-(void)_goNext {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"CONCEAL_WELCOME_SCREEN" object:nil];
	[self dismissViewControllerAnimated:YES completion:^(void) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISS_WELCOME_SCREEN" object:nil];
	}];
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	if ([request isEqual:_codeDataRequest]) {
	
		@autoreleasepool {
			NSError *error = nil;
			NSDictionary *parsedCode = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				NSLog(@"SYNC CODE: %@", parsedCode);
				_codeLabel.text = [parsedCode objectForKey:@"hex_code"];
			}
		}
	
		[_loadOverlay remove];
	
	} else if ([request isEqual:_signupDataRequest]) {
		
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
		
		_codeDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
		[_codeDataRequest setPostValue:[NSString stringWithFormat:@"%d", 5] forKey:@"action"];
		[_codeDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[_codeDataRequest setDelegate:self];
		[_codeDataRequest startAsynchronous];
	}
}


-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
	
	//[_delegates perform:@selector(jobList:didFailLoadWithError:) withObject:self withObject:request.error];
	//MBL_RELEASE_SAFELY(_jobListRequest);
}


@end
