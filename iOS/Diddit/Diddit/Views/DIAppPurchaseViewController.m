//
//  DIAppPurchaseViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.17.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIAppPurchaseViewController.h"
#import "MBProgressHUD.h"
#import "DIAppDelegate.h"

@implementation DIAppPurchaseViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_dismissMe:) name:@"DISMISS_CONFIRM_CHORE" object:nil];
		
		UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 39)] autorelease];
		//headerLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:18.0];
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor];
		headerLabel.textColor = [UIColor whiteColor];
		headerLabel.shadowColor = [UIColor colorWithWhite:0.25 alpha:1.0];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		headerLabel.text = @"App Rewards";
		[headerLabel sizeToFit];
		self.navigationItem.titleView = headerLabel;
		
		UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		backButton.frame = CGRectMake(0, 0, 60.0, 30);
		[backButton setBackgroundImage:[[UIImage imageNamed:@"non_Active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateNormal];
		[backButton setBackgroundImage:[[UIImage imageNamed:@"active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateHighlighted];
		backButton.titleEdgeInsets = UIEdgeInsetsMake(-1.0, 1.0, 1.0, -1.0);
		//backButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
		[backButton setTitle:@"Back" forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
	}
	
	return (self);
}


-(id)initWithApp:(DIApp *)app {
	if ((self = [self init])) {
		_app = app;
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
	
	_icoImgView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 32, 32)];
	_icoImgView.layer.cornerRadius = 8.0;
	_icoImgView.clipsToBounds = YES;
	_icoImgView.layer.borderColor = [[UIColor colorWithWhite:0.671 alpha:1.0] CGColor];
	_icoImgView.layer.borderWidth = 1.0;
	_icoImgView.imageURL = [NSURL URLWithString:_app.ico_url];
	[self.view addSubview:_icoImgView];
	
	UILabel *appLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 16, 260, 20)];
	//appLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12];
	appLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	appLabel.backgroundColor = [UIColor clearColor];
	appLabel.text = _app.title;
	[self.view addSubview:appLabel];

	UILabel *tradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 64, 260, 64)];
	//tradeLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12];
	tradeLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	tradeLabel.backgroundColor = [UIColor clearColor];
	tradeLabel.numberOfLines = 0;
	tradeLabel.text = [NSString stringWithFormat:@"Trade %d points for \n%@?", _app.points, _app.info];
	[self.view addSubview:tradeLabel];
	
	
	_resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 128, 260, 64)];
	//_resultLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12];
	_resultLabel.textColor = [UIColor colorWithWhite:0.0 alpha:1.0];
	_resultLabel.backgroundColor = [UIColor clearColor];
	_resultLabel.numberOfLines = 0;
	_resultLabel.text = @"";
	[self.view addSubview:_resultLabel];

	
	UIButton *purchaseButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	purchaseButton.frame = CGRectMake(32, 375, 256, 32);
	//purchaseButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
	purchaseButton.titleEdgeInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
	[purchaseButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButton.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[purchaseButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButtonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:7] forState:UIControlStateHighlighted];
	[purchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[purchaseButton setTitle:@"Trade It!" forState:UIControlStateNormal];
	[purchaseButton addTarget:self action:@selector(_goPurchase) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:purchaseButton];
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


#pragma mark - navigation
- (void)_goBack {
	[self dismissViewControllerAnimated:YES completion:nil];	
}

- (void)_goPurchase {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	ASIFormDataRequest *purchaseRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Apps.php"]] retain];
	[purchaseRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
	[purchaseRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[purchaseRequest setPostValue:[NSString stringWithFormat:@"%d", _app.app_id] forKey:@"appID"];
	[purchaseRequest setPostValue:[NSString stringWithFormat:@"%d", _app.points] forKey:@"points"];
	[purchaseRequest setDelegate:self];
	[purchaseRequest startAsynchronous];
	
	_hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	_hud.labelText = @"Contacting app…";
	[_hud hide:YES];
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	[_hud hide:YES];
	_hud = nil;
	
	@autoreleasepool {
		NSError *error = nil;
		NSDictionary *parsedResult = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
		
		if (error != nil)
			NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
		
		else {
			NSLog(@"SUCCESS?? (%@)", [parsedResult objectForKey:@"success"]);
			BOOL isSuccess = (BOOL)([[parsedResult objectForKey:@"success"] isEqual:@"true"]);
			
			if (isSuccess) {
				[DIAppDelegate setUserPoints:[DIAppDelegate userPoints] - _app.points];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"PURCHASE_APP" object:nil];
				[self dismissViewControllerAnimated:YES completion:nil];
			
			} else
				_resultLabel.text = @"Failed… try again";
		}
	}
}

@end
