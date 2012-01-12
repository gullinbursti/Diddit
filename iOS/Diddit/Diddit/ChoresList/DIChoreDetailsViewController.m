//
//  DIChoreDetailsViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIChoreDetailsViewController.h"

#import "DIAppDelegate.h"
#import "DINavTitleView.h"
#import "DINavHomeIcoBtnView.h"
#import "DIPinCodeViewController.h"

@implementation DIChoreDetailsViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_finishChore:) name:@"FINISH_CHORE" object:nil];
		
		DINavHomeIcoBtnView *homeBtnView = [[DINavHomeIcoBtnView alloc] init];
		[[homeBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:homeBtnView] autorelease];
	}
	
	return (self);
}

-(id)initWithChore:(DIChore *)chore {
	if ((self = [self init])) {
		_chore = chore;
		self.navigationItem.titleView = [[DINavTitleView alloc] initWithTitle:[_chore.title lowercaseString]];		
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
	[self.view addSubview:bgImgView];
	
	CGSize textSize = [_chore.info sizeWithFont:[[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12] constrainedToSize:CGSizeMake(265.0, CGFLOAT_MAX) lineBreakMode:UILineBreakModeClip];
	
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 392)];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	scrollView.contentSize = CGSizeMake(320, 300 + textSize.height);
	scrollView.opaque = NO;
	scrollView.scrollsToTop = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = YES;
	scrollView.alwaysBounceVertical = NO;
	[self.view addSubview:scrollView];
	
	_imgView = [[EGOImageView alloc] initWithFrame:CGRectMake(58, 35, 205, 174)];
	_imgView.backgroundColor = [UIColor colorWithRed:1.0 green:0.988235294117647 blue:0.874509803921569 alpha:1.0];
	_imgView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
	_imgView.layer.borderWidth = 1.0;
	_imgView.clipsToBounds = YES;
	_imgView.imageURL = [NSURL URLWithString:_chore.imgPath];
	[scrollView addSubview:_imgView];
	
	UILabel *pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 225, 320, 40)];
	pointsLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:30];
	pointsLabel.textColor = [UIColor blackColor];
	pointsLabel.backgroundColor = [UIColor clearColor];
	pointsLabel.textAlignment = UITextAlignmentCenter;
	pointsLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	pointsLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	pointsLabel.text = [NSString stringWithFormat:@"%@ didds", _chore.disp_points];
	[scrollView addSubview:pointsLabel];
	
	UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 265, 300, textSize.height)];
	infoLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	infoLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.numberOfLines = 0;
	infoLabel.text = _chore.info;
	[scrollView addSubview:infoLabel];
	
	UIImageView *calendarImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 275 + textSize.height, 14, 14)] autorelease];
	calendarImgView.image = [UIImage imageNamed:@"cal_Icon.png"];
	[scrollView addSubview:calendarImgView];
	
	UILabel *expiresLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 275 + textSize.height, 200, 16)];
	expiresLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	expiresLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
	expiresLabel.backgroundColor = [UIColor clearColor];
	expiresLabel.text = [NSString stringWithFormat:@"Expires on %@", _chore.disp_expires];
	[scrollView addSubview:expiresLabel];
	
	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 348, 320, 72)];
	footerView.backgroundColor = [UIColor colorWithRed:0.2706 green:0.7804 blue:0.4549 alpha:1.0];
	[self.view addSubview:footerView];
	
	_completeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_completeButton.frame = CGRectMake(0, 352, 320, 60);
	_completeButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	_completeButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[_completeButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[_completeButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_completeButton setTitle:@"approve chore" forState:UIControlStateNormal];
	[_completeButton addTarget:self action:@selector(_goComplete) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_completeButton];
	
	UIImageView *overlayImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]];
	CGRect frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];

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
	
	DIPinCodeViewController *pinCodeViewController = [[[DIPinCodeViewController alloc] initWithChore:_chore fromSettings:NO] autorelease];
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
	
	} //else
		//[_loadOverlayView toggle:NO];
	
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
	//[_loadOverlayView toggle:NO];
}

@end
