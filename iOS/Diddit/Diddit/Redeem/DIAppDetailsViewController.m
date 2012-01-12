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
#import "DIChoreStatsView.h"
#import "DIRedeemCodeViewController.h"

@implementation DIAppDetailsViewController

-(id)init {
	if ((self = [super init])) {
		self.navigationItem.titleView = [[DINavTitleView alloc] initWithTitle:[_app.title lowercaseString]];
		
		DINavBackBtnView *backBtnView = [[DINavBackBtnView alloc] init];
		[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
	}
	
	return (self);
}

-(id)initWithApp:(DIApp *)app {
	_app = app;
	
	if ((self = [self init])) {
		
	}
	
	return (self);
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
	[self.view addSubview:bgImgView];
	
	CGSize textSize = [_app.app_info sizeWithFont:[[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12] constrainedToSize:CGSizeMake(300.0, CGFLOAT_MAX) lineBreakMode:UILineBreakModeClip];
	
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0, self.view.bounds.size.width, 396)];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	scrollView.opaque = NO;
	scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, textSize.height + 400);
	scrollView.scrollsToTop = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = YES;
	scrollView.alwaysBounceVertical = NO;
	[self.view addSubview:scrollView];
	
	
	DIChoreStatsView *choreStatsView = [[DIChoreStatsView alloc] initWithFrame:CGRectMake(10, 13, 300, 34)];
	[scrollView addSubview:choreStatsView];
	
	UIButton *offersBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	offersBtn.frame = CGRectMake(228, 15, 84, 34);
	offersBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
	[offersBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[offersBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[offersBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	offersBtn.titleLabel.shadowColor = [UIColor blackColor];
	offersBtn.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	[offersBtn setTitle:@"Earn Didds" forState:UIControlStateNormal];
	[offersBtn addTarget:self action:@selector(_goOffers) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:offersBtn];
	
	UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
	CGRect frame = dividerImgView.frame;
	frame.origin.y = 54;
	dividerImgView.frame = frame;
	[scrollView addSubview:dividerImgView];
	
	EGOImageView *icoImgView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 71, 60, 60)];
	icoImgView.imageURL = [NSURL URLWithString:_app.ico_url];
	icoImgView.layer.cornerRadius = 8.0;
	icoImgView.clipsToBounds = YES;
	icoImgView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
	icoImgView.layer.borderWidth = 1.0;
	[scrollView addSubview:icoImgView];
	
	UILabel *appTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(76, 76, 180.0, 22)];
	appTitleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
	appTitleLabel.backgroundColor = [UIColor clearColor];
	appTitleLabel.textColor = [UIColor colorWithRed:0.208 green:0.682 blue:0.369 alpha:1.0];
	appTitleLabel.text = _app.title;
	[scrollView addSubview:appTitleLabel];
	
	UIView *ptsView = [[[UIView alloc] initWithFrame:CGRectMake(257, 85.0, 52, 25)] autorelease];
	ptsView.backgroundColor = [UIColor colorWithRed:0.976 green:0.976 blue:0.929 alpha:1.0];
	ptsView.layer.cornerRadius = 6.0;
	ptsView.clipsToBounds = YES;
	ptsView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
	ptsView.layer.borderWidth = 2.0;
	[scrollView addSubview:ptsView];
	
	UILabel *pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 52, 20)];
	pointsLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
	pointsLabel.backgroundColor = [UIColor clearColor];
	pointsLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	pointsLabel.text = [NSString stringWithFormat:@"%@ D", _app.disp_points];
	pointsLabel.textAlignment = UITextAlignmentCenter;
	[ptsView addSubview:pointsLabel];
	
	UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(76, 95, 300.0, 16)];
	infoLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:14];
	infoLabel.textColor = [UIColor blackColor];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.text = _app.info;
	[scrollView addSubview:infoLabel];
	
	UILabel *storeInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 145, 300, textSize.height)];
	storeInfoLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
	storeInfoLabel.backgroundColor = [UIColor clearColor];
	storeInfoLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	storeInfoLabel.numberOfLines = 0;
	storeInfoLabel.text = _app.app_info;
	[scrollView addSubview:storeInfoLabel];
	
	_imgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 160 + textSize.height, 320, 420)];
	_imgScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_imgScrollView.opaque = NO;
	_imgScrollView.contentSize = CGSizeMake(320 * [_app.images count], 420);
	_imgScrollView.scrollsToTop = NO;
	_imgScrollView.pagingEnabled = YES;
	_imgScrollView.delegate = self;
	_imgScrollView.showsHorizontalScrollIndicator = NO;
	_imgScrollView.showsVerticalScrollIndicator = NO;
	_imgScrollView.alwaysBounceVertical = NO;
	[scrollView addSubview:_imgScrollView];
	
	int xOffset = 10;
	for (NSDictionary *dict in _app.images) {
		NSLog(@"IMG:%d)>[%@]", [[dict objectForKey:@"type"] intValue], [dict objectForKey:@"url"]);
		
		int type = [[dict objectForKey:@"type"] intValue];
		NSString *url = [dict objectForKey:@"url"];
		
		
		CGSize size = CGSizeMake(300, 200);
		
		UIView *holderView = [[UIView alloc] initWithFrame:CGRectMake(xOffset, 0, size.width, size.height)];
		EGOImageView *appImgView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
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
	
	_paginationView = [[DIPaginationView alloc] initWithTotal:[_app.images count] coords:CGPointMake(160, 370 + textSize.height)];
	[scrollView addSubview:_paginationView];
	
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
	
	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 348, 320, 72)];
	footerView.backgroundColor = [UIColor colorWithRed:0.2706 green:0.7804 blue:0.4549 alpha:1.0];
	[self.view addSubview:footerView];
	
	UIButton *purchaseButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	purchaseButton.frame = CGRectMake(0, 352, 320, 60);
	purchaseButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	purchaseButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[purchaseButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[purchaseButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[purchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[purchaseButton setTitle:@"purchase" forState:UIControlStateNormal];
	[purchaseButton addTarget:self action:@selector(_goPurchase) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:purchaseButton];
	
	UIImageView *overlayImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]];
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


-(void)dealloc {
	[super dealloc];
}


#pragma mark - navigation
-(void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)_goOffers {
	[self.navigationController popToRootViewControllerAnimated:NO];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PUSH_OFFERS_SCREEN" object:nil];
}

-(void)_goPurchase {
	DIRedeemCodeViewController *redeemCodeViewController = [[[DIRedeemCodeViewController alloc] initWithApp:_app] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:redeemCodeViewController] autorelease];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}


#pragma mark - ScrollView Delegates
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	int page = _imgScrollView.contentOffset.x / 320;
	
	[_paginationView updToPage:page];
	NSLog(@"SCROLL PAGE:[%d]", page);
}

@end
