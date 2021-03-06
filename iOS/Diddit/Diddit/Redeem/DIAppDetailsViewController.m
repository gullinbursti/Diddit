//
//  DIAppDetailsViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DIAppDetailsViewController.h"

#import "EGOImageView.h"
#import "DIAppDelegate.h"
#import "DINavBackBtnView.h"
#import "DINavTitleView.h"
#import "DIOfferListViewController.h"
#import "DIRedeemCodeViewController.h"

@implementation DIAppDetailsViewController

-(id)init {
	if ((self = [super init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"details"] autorelease];
		
		DINavBackBtnView *backBtnView = [[[DINavBackBtnView alloc] init] autorelease];
		[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
	}
	
	return (self);
}

-(id)initWithApp:(DIApp *)app {
	_app = app;
	
	if ((self = [self init])) {
		_isStoreAlert = NO;
	}
	
	return (self);
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]] autorelease];
	[self.view addSubview:bgImgView];
	
	//CGSize textSize = [_app.app_info sizeWithFont:[[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12] constrainedToSize:CGSizeMake(300.0, CGFLOAT_MAX) lineBreakMode:UILineBreakModeClip];
	CGRect frame;
	
	UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0, self.view.bounds.size.width, 396)] autorelease];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	scrollView.opaque = NO;
	scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 480);
	scrollView.scrollsToTop = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = YES;
	scrollView.alwaysBounceVertical = NO;
	//[self.view addSubview:scrollView];
	
	UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 38, 280, 30)] autorelease];
	titleLabel.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:24.0];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [DIAppDelegate diColor333333];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	titleLabel.text = _app.title;
	[self.view addSubview:titleLabel];
	
	UILabel *storeInfoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 75, 290, 30)] autorelease];
	storeInfoLabel.font = [[DIAppDelegate diOpenSansFontSemibold] fontWithSize:12.0];
	storeInfoLabel.backgroundColor = [UIColor clearColor];
	storeInfoLabel.textColor = [DIAppDelegate diColor666666];
	storeInfoLabel.numberOfLines = 2;
	storeInfoLabel.textAlignment = UITextAlignmentCenter;
	storeInfoLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	storeInfoLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	storeInfoLabel.text = _app.app_info;
	[self.view addSubview:storeInfoLabel];
	
	_imgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(17, 119, 320, 300)];
	_imgScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_imgScrollView.opaque = NO;
	_imgScrollView.contentSize = CGSizeMake(320, 240);
	_imgScrollView.scrollsToTop = NO;
	_imgScrollView.pagingEnabled = YES;
	_imgScrollView.delegate = self;
	_imgScrollView.showsHorizontalScrollIndicator = NO;
	_imgScrollView.showsVerticalScrollIndicator = NO;
	_imgScrollView.alwaysBounceVertical = NO;
	_imgScrollView.bounces = NO;
	[self.view addSubview:_imgScrollView];
	
	int xOffset = 10;
	for (NSDictionary *dict in _app.images) {
		NSLog(@"IMG:%d)>[%@]", [[dict objectForKey:@"type"] intValue], [dict objectForKey:@"url"]);
		
		int type = [[dict objectForKey:@"type"] intValue];
		NSString *url = [dict objectForKey:@"url"];
		
		
		CGSize size = CGSizeMake(280, 190);
		
		UIView *holderView = [[[UIView alloc] initWithFrame:CGRectMake(xOffset, 0, size.width, size.height)] autorelease];
		EGOImageView *appImgView = [[[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)] autorelease];
		appImgView.imageURL = [NSURL URLWithString:url];
		
		if (type == 1) {
			[holderView addSubview:appImgView];
			[_imgScrollView addSubview:holderView];
		
		} else {
			appImgView.center = CGPointMake(size.width * 0.5, size.height * 0.5);
			[holderView addSubview:appImgView];
			[_imgScrollView addSubview:holderView];
			
			appImgView.transform = CGAffineTransformMakeRotation(3.0 * M_PI / 2);
			appImgView.center = CGPointMake(0.0, 0.0);
			frame = appImgView.frame;
			frame.origin.x += size.height * 0.5;
			frame.origin.y += size.width * 0.5;
			appImgView.frame = frame;	
		}
		
		xOffset += 320;
	}
	
	_paginationView = [[DIPaginationView alloc] initWithTotal:[_app.images count] coords:CGPointMake(160, 320)];
	//[scrollView addSubview:_paginationView];
	
	/*
	appImgView.imageURL = [NSURL URLWithString:_app.img_url];
	appImgView.center = CGPointMake(210.0, 140.0);
	[holderView addSubview:appImgView];
	[scrollView addSubview:holderView];

	appImgView.transform = CGAffineTransformMakeRotation(3.0 * M_PI / 2);
	appImgView.center = CGPointMake(0.0, 0.0);
	frame = appImgView.frame;
	frame.origin.x += 140;
	frame.origin.y += 225;
	appImgView.frame = frame;
	*/
	
	//[scrollView addSubview:appImgView];
	
		
	NSString *buttonLbl;
	
	if (_app.type_id == 1)
		buttonLbl = @"Purchase Now";
	
	else
		buttonLbl = @"purchase card now";
	
	
	_footerBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_footerBtn.frame = CGRectMake(23, 338, 279, 59);
	_footerBtn.titleLabel.font = [[DIAppDelegate diOpenSansFontBold] fontWithSize:20.0];
	_footerBtn.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
	[_footerBtn setBackgroundImage:[[UIImage imageNamed:@"largeButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[_footerBtn setBackgroundImage:[[UIImage imageNamed:@"largeButton_active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[_footerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	_footerBtn.titleLabel.shadowColor = [UIColor blackColor];
	_footerBtn.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	[_footerBtn setTitle:@"Purchase Now" forState:UIControlStateNormal];
	[_footerBtn addTarget:self action:@selector(_goPurchase) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_footerBtn];
	
	[buttonLbl release];
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
	
}

-(void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}


-(void)dealloc {/*
	[_app release];
	[_paginationView release];
	[_imgScrollView release];
	[_loadOverlay release];
	[_choreStatsView release];
	
	[_footerView release];
	//[_footerBtn release];
	*/[super dealloc];
}


#pragma mark - navigation
-(void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)_goOffers {
	//[self.navigationController popToRootViewControllerAnimated:NO];
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"PUSH_OFFERS_SCREEN" object:nil];
	
	[self.navigationController pushViewController:[[[DIOfferListViewController alloc] init] autorelease] animated:YES];
}

-(void)_goPurchase {
	
	if (_app.type_id == 2) {
		//DIRedeemCodeViewController *redeemCodeViewController = [[[DIRedeemCodeViewController alloc] initWithApp:_app] autorelease];
		//UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:redeemCodeViewController] autorelease];
		//[self.navigationController presentModalViewController:navigationController animated:YES];
	
	} else {
		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase In-App" message:[NSString stringWithFormat:@"Trading %d didds", _app.points] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
		//[alert show];
		//[alert release];
	}
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	ASIFormDataRequest *purchaseRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kServerPath, @"Store.php"]]] retain];
	[purchaseRequest setPostValue:[NSString stringWithFormat:@"%d", 3] forKey:@"action"];
	[purchaseRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[purchaseRequest setPostValue:[NSString stringWithFormat:@"%d", _app.app_id] forKey:@"appID"];
	[purchaseRequest setDelegate:self];
	[purchaseRequest startAsynchronous];
	
	[UIView animateWithDuration:0.33 animations:^(void) {
		CGRect btnFrame = _footerBtn.frame;
		//btnFrame.origin.y += footerFrame.size.height;
		_footerBtn.frame = btnFrame;
	}];
	
}


#pragma mark - ScrollView Delegates
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	int page = _imgScrollView.contentOffset.x / 320;
	
	[_paginationView updToPage:page];
	NSLog(@"SCROLL PAGE:[%d]", page);
}


#pragma mark - AlertView Delegates
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (!_isStoreAlert) {
		switch(_app.type_id) {
			case 1:
				if (buttonIndex == 1) {
					NSLog(@"%@", [NSString stringWithFormat:@"%@://", [[_app.title stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString]]);
					//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://", [[_app.title stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString]]]];
					//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@?mt=8", _app.itunes_id]]];
					//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile"]];
					[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gutz://"]];
				}
				break;
				
			case 2:
				if (buttonIndex == 1) {
					_isStoreAlert = YES;
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Leaving diddit" message:@"Your iTunes gift card number has been copied" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Go to iTunes", nil];
					[alert show];
					[alert release];
				}
				break;
		}
	} else {
		if (buttonIndex == 1) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/redeemLandingPage?mt=8&partnerId=30&siteID=hFutuamrkR4"]];
		}
	}
	
	[alertView dismissWithClickedButtonIndex:1 animated:NO];
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
			[DIAppDelegate setUserProfile:parsedUser];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_STATS" object:nil];
			
			if (_app.type_id == 2) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Leaving diddit" message:@"Your iTunes gift card number has been copied" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Copy", nil];
				[alert show];
				[alert release];
				
				NSString *redeemCode = [[DIAppDelegate md5:[NSString stringWithFormat:@"%d", arc4random()]] uppercaseString];
				redeemCode = [redeemCode substringToIndex:[redeemCode length] - 12];
				
				UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
				[pasteboard setValue:redeemCode forPasteboardType:@"public.utf8-plain-text"];
				
			} else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_app.info message:[NSString stringWithFormat:@"Your in-app good is available inside %@", _app.title] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Launch", nil];
				[alert show];
				[alert release];
			}
				
		}
	}
		
	[_loadOverlay remove];
}

-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
}

@end
