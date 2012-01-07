//
//  DIChoreDetailsViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import "DIChoreDetailsViewController.h"

#import "DIAppDelegate.h"
#import "DIPinCodeViewController.h"

@implementation DIChoreDetailsViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_finishChore:) name:@"FINISH_CHORE" object:nil];
		
		 UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		 backButton.frame = CGRectMake(0, 0, 47.0, 34.0);
		 [backButton setBackgroundImage:[[UIImage imageNamed:@"homeButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		 [backButton setBackgroundImage:[[UIImage imageNamed:@"homeButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		 [backButton addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		 self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
	}
	
	return (self);
}

-(id)initWithChore:(DIChore *)chore {
	if ((self = [self init])) {
		_chore = chore;
		
		UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 39)] autorelease];
		headerLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:18.0];
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor];
		headerLabel.textColor = [UIColor whiteColor];
		headerLabel.shadowColor = [UIColor colorWithWhite:0.25 alpha:1.0];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		headerLabel.text = [_chore.title lowercaseString];
		[headerLabel sizeToFit];
		self.navigationItem.titleView = headerLabel;
		
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
	[self.view addSubview:bgImgView];
	
	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 348, 320, 72)];
	footerView.backgroundColor = [UIColor colorWithRed:0.2706 green:0.7804 blue:0.4549 alpha:1.0];
	[self.view addSubview:footerView];
	
	_imgView = [[EGOImageView alloc] initWithFrame:CGRectMake(58, 40, 205, 174)];
	_imgView.imageURL = [NSURL URLWithString:_chore.imgPath];
	[self.view addSubview:_imgView];
	
	UILabel *pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 230, 320, 40)];
	pointsLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:30];
	pointsLabel.textColor = [UIColor blackColor];
	pointsLabel.backgroundColor = [UIColor clearColor];
	pointsLabel.textAlignment = UITextAlignmentCenter;
	pointsLabel.text = [NSString stringWithFormat:@"%@ didds", _chore.disp_points];
	[self.view addSubview:pointsLabel];
	
	UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 230, 320, 40)];
	infoLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10];
	infoLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.textAlignment = UITextAlignmentCenter;
	infoLabel.text = _chore.info;
	[self.view addSubview:infoLabel];
	
	UIImageView *calendarImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 300.0, 14, 14)] autorelease];
	calendarImgView.image = [UIImage imageNamed:@"cal_Icon.png"];
	[self.view addSubview:calendarImgView];
	
	UILabel *expiresLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 300, 200, 16)];
	expiresLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	expiresLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
	expiresLabel.backgroundColor = [UIColor clearColor];
	expiresLabel.text = [NSString stringWithFormat:@"Expires on %@", _chore.disp_expires];
	[self.view addSubview:expiresLabel];
	
	_completeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_completeButton.frame = CGRectMake(10, 350, 300, 64);
	_completeButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	_completeButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[_completeButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:22 topCapHeight:0] forState:UIControlStateNormal];
	[_completeButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:22 topCapHeight:0] forState:UIControlStateHighlighted];
	[_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_completeButton setTitle:@"approve chore" forState:UIControlStateNormal];
	[_completeButton addTarget:self action:@selector(_goComplete) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_completeButton];
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
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)_goComplete {
	
	DIPinCodeViewController *pinCodeViewController = [[[DIPinCodeViewController alloc] initWithPin:@"0000" chore:_chore fromAdd:NO] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:pinCodeViewController] autorelease];
	//[self.navigationController presentViewController:navigationController animated:YES completion:nil];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}


#pragma mark - notication handlers
-(void)_finishChore:(NSNotification *)notification {

	/*
	_updUserRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
	[_updUserRequest setPostValue:[NSString stringWithFormat:@"%d", 4] forKey:@"action"];
	[_updUserRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[_updUserRequest setPostValue:[NSString stringWithFormat:@"%d", _chore.cost * 100] forKey:@"points"];
	[_updUserRequest setDelegate:self];
	[_updUserRequest startAsynchronous];
	*/
	/*
	ASIFormDataRequest *finishChoreRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
	[finishChoreRequest setPostValue:[NSString stringWithFormat:@"%d", 6] forKey:@"action"];
	[finishChoreRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[finishChoreRequest setPostValue:[NSString stringWithFormat:@"%d", _chore.chore_id] forKey:@"choreID"];
	[finishChoreRequest setDelegate:self];
	[finishChoreRequest startAsynchronous];
	*/
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	if ([request isEqual:_updUserRequest]) {
		ASIFormDataRequest *finishChoreRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
		[finishChoreRequest setPostValue:[NSString stringWithFormat:@"%d", 6] forKey:@"action"];
		[finishChoreRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[finishChoreRequest setPostValue:[NSString stringWithFormat:@"%d", _chore.chore_id] forKey:@"choreID"];
		[finishChoreRequest setDelegate:self];
		[finishChoreRequest startAsynchronous];
	}
	
//	@autoreleasepool {
//		NSError *error = nil;
//		NSArray *parsedChores = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
//		
//		if (error != nil)
//			NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
//		
//		else {
//			NSMutableArray *choreList = [NSMutableArray array];
//			
//			for (NSDictionary *serverChore in parsedChores) {
//				DIChore *chore = [DIChore choreWithDictionary:serverChore];
//				
//				if (chore != nil)
//					[choreList addObject:chore];
//			}
//			
//		}
//	}
}


-(void)requestFailed:(ASIHTTPRequest *)request {
}

@end
