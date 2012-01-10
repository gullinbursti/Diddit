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
	
	UILabel *diddsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 60, 26)];
	diddsLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10];
	diddsLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
	diddsLabel.backgroundColor = [UIColor clearColor];
	diddsLabel.text = @"DIDDS";
	[self.view addSubview:diddsLabel];
	
	UIButton *pointsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	pointsButton.frame = CGRectMake(50, 15, 59, 34);
	pointsButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10.0];
	//pointsButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[pointsButton setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[pointsButton setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateSelected];
	[pointsButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
	[pointsButton setTitle:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle] forState:UIControlStateNormal];
	[self.view addSubview:pointsButton];
	
	UILabel *choresLabel = [[UILabel alloc] initWithFrame:CGRectMake(122, 20, 60, 26)];
	choresLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10];
	choresLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
	choresLabel.backgroundColor = [UIColor clearColor];
	choresLabel.text = @"CHORES";
	[self.view addSubview:choresLabel];
	
	UIButton *finishedButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	finishedButton.frame = CGRectMake(170, 15, 38, 34);
	finishedButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10.0];
	[finishedButton setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[finishedButton setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateSelected];
	[finishedButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
	[finishedButton setTitle:[NSString stringWithFormat:@"%d", [DIAppDelegate userTotalFinished]] forState:UIControlStateNormal];
	[self.view addSubview:finishedButton];
	
	UIButton *offersBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	offersBtn.frame = CGRectMake(228, 15, 84, 34);
	offersBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
	[offersBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_nonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[offersBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_Active.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateSelected];
	[offersBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	offersBtn.titleLabel.shadowColor = [UIColor blackColor];
	offersBtn.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	[offersBtn setTitle:@"Earn Didds" forState:UIControlStateNormal];
	[offersBtn addTarget:self action:@selector(_goOffers) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:offersBtn];
	
	UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
	CGRect frame = dividerImgView.frame;
	frame.origin.y = 54;
	dividerImgView.frame = frame;
	[self.view addSubview:dividerImgView];
	
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 56, self.view.bounds.size.width, 336)];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	scrollView.opaque = NO;
	scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 378);
	scrollView.scrollsToTop = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = YES;
	scrollView.alwaysBounceVertical = NO;
	[self.view addSubview:scrollView];
	
	EGOImageView *icoImgView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 15, 60, 60)];
	icoImgView.imageURL = [NSURL URLWithString:_app.ico_url];
	icoImgView.layer.cornerRadius = 8.0;
	icoImgView.clipsToBounds = YES;
	icoImgView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
	icoImgView.layer.borderWidth = 1.0;
	[scrollView addSubview:icoImgView];
	
	UILabel *appTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(76, 30, 180.0, 22)];
	appTitleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:14.0];
	appTitleLabel.backgroundColor = [UIColor clearColor];
	appTitleLabel.textColor = [UIColor blackColor];
	appTitleLabel.text = _app.title;
	[scrollView addSubview:appTitleLabel];
	
	UIImageView *ptsIcoView = [[[UIImageView alloc] initWithFrame:CGRectMake(76, 50.0, 17, 17)] autorelease];
	ptsIcoView.image = [UIImage imageNamed:@"piggyIcon.png"];
	[scrollView addSubview:ptsIcoView];
	
	UILabel *pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(96, 50, 120.0, 16)];
	pointsLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
	pointsLabel.backgroundColor = [UIColor clearColor];
	pointsLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	pointsLabel.text = _app.disp_points;
	[scrollView addSubview:pointsLabel];
	
	UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 300, 40)];
	infoLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	infoLabel.textColor = [UIColor colorWithWhite:0.33 alpha:1.0];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.numberOfLines = 0;
	infoLabel.text = _app.info;
	[scrollView addSubview:infoLabel];
	
	UIImageView *divider2ImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
	frame = divider2ImgView.frame;
	frame.origin.y = 140;
	divider2ImgView.frame = frame;
	[scrollView addSubview:divider2ImgView];
	
	EGOImageView *appImgView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 168, 300, 210)];
	appImgView.imageURL = [NSURL URLWithString:_app.img_url];
	[scrollView addSubview:appImgView];
	
	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 348, 320, 72)];
	footerView.backgroundColor = [UIColor colorWithRed:0.2706 green:0.7804 blue:0.4549 alpha:1.0];
	[self.view addSubview:footerView];
	
	UIImageView *overlayImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]];
	frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];

	UIButton *purchaseButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	purchaseButton.frame = CGRectMake(0, 350, 320, 60);
	purchaseButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	purchaseButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[purchaseButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[purchaseButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[purchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[purchaseButton setTitle:@"purchase" forState:UIControlStateNormal];
	[purchaseButton addTarget:self action:@selector(_goPurchase) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:purchaseButton];
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

@end
