//
//  DIOfferDetailsViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIOfferDetailsViewController.h"
#import "EGOImageView.h"
#import "DIAppDelegate.h"
#import "DINavBackBtnView.h"
#import "DINavTitleView.h"
#import "DIChoreStatsView.h"
#import "DIOffersHelpViewController.h"
#import "DIOfferVideoViewController.h"

@implementation DIOfferDetailsViewController


-(id)init {
	if ((self = [super init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:[_offer.app_name lowercaseString]] autorelease];
		
		DINavBackBtnView *backBtnView = [[[DINavBackBtnView alloc] init] autorelease];
		[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
	}
	
	return (self);
}

-(id)initWithOffer:(DIOffer *)offer {
	_offer = offer;
	
	if ((self = [self init])) {
		
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
	
	CGSize textSize = [_offer.info sizeWithFont:[[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12] constrainedToSize:CGSizeMake(300.0, CGFLOAT_MAX) lineBreakMode:UILineBreakModeClip];
	
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0, self.view.bounds.size.width, 392)];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	scrollView.opaque = NO;
	scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 525 + textSize.height);
	scrollView.scrollsToTop = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = YES;
	scrollView.alwaysBounceVertical = NO;
	[self.view addSubview:scrollView];
	
	DIChoreStatsView *choreStatsView = [[[DIChoreStatsView alloc] initWithFrame:CGRectMake(10, 13, 300, 34)]autorelease];
	[scrollView addSubview:choreStatsView];
	
	UIButton *helpBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	helpBtn.frame = CGRectMake(228, 15, 84, 34);
	helpBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
	[helpBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[helpBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[helpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	helpBtn.titleLabel.shadowColor = [UIColor blackColor];
	helpBtn.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	[helpBtn setTitle:@"Need Help" forState:UIControlStateNormal];
	[helpBtn addTarget:self action:@selector(_goHelp) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:helpBtn];
	
	UIImageView *dividerImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerDivider.png"]] autorelease];
	CGRect frame = dividerImgView.frame;
	frame.origin.y = 54;
	dividerImgView.frame = frame;
	[scrollView addSubview:dividerImgView];
	
	EGOImageView *icoImgView = [[[EGOImageView alloc] initWithFrame:CGRectMake(10, 67, 60, 60)] autorelease];
	icoImgView.imageURL = [NSURL URLWithString:_offer.ico_url];
	icoImgView.layer.cornerRadius = 8.0;
	icoImgView.clipsToBounds = YES;
	icoImgView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
	icoImgView.layer.borderWidth = 1.0;
	[scrollView addSubview:icoImgView];
	
	UILabel *appTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(76, 86, 180.0, 22)] autorelease];
	appTitleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:14.0];
	appTitleLabel.backgroundColor = [UIColor clearColor];
	appTitleLabel.textColor = [UIColor blackColor];
	appTitleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	appTitleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	appTitleLabel.text = _offer.title;
	[scrollView addSubview:appTitleLabel];
	
	UIImageView *ptsIcoView = [[[UIImageView alloc] initWithFrame:CGRectMake(76, 106.0, 17, 17)] autorelease];
	ptsIcoView.image = [UIImage imageNamed:@"piggyIcon.png"];
	[scrollView addSubview:ptsIcoView];
	
	UILabel *pointsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(96, 106, 120.0, 16)] autorelease];
	pointsLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
	pointsLabel.backgroundColor = [UIColor clearColor];
	pointsLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	pointsLabel.text = _offer.disp_points;
	[scrollView addSubview:pointsLabel];
	
	UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 146, 300, textSize.height)] autorelease];
	infoLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	infoLabel.textColor = [UIColor colorWithWhite:0.33 alpha:1.0];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.numberOfLines = 0;
	infoLabel.text = _offer.info;
	[scrollView addSubview:infoLabel];
	
	UIImageView *divider2ImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]] autorelease];
	frame = divider2ImgView.frame;
	frame.origin.y = 169 + textSize.height;
	divider2ImgView.frame = frame;
	[scrollView addSubview:divider2ImgView];
	
	
	_imgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 197 + textSize.height, 320, 420)];
	_imgScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_imgScrollView.opaque = NO;
	_imgScrollView.contentSize = CGSizeMake(320 * [_offer.images count], 420);
	_imgScrollView.scrollsToTop = NO;
	_imgScrollView.pagingEnabled = YES;
	_imgScrollView.delegate = self;
	_imgScrollView.showsHorizontalScrollIndicator = NO;
	_imgScrollView.showsVerticalScrollIndicator = NO;
	_imgScrollView.alwaysBounceVertical = NO;
	[scrollView addSubview:_imgScrollView];
	
	int xOffset = 55;
	for (NSDictionary *dict in _offer.images) {
		NSLog(@"IMG:%d)>[%@]", [[dict objectForKey:@"type"] intValue], [dict objectForKey:@"url"]);
		
		int type = [[dict objectForKey:@"type"] intValue];
		NSString *url = [dict objectForKey:@"url"];
		CGSize size = CGSizeMake(300, 200);
		
		UIView *holderView = [[UIView alloc] initWithFrame:CGRectMake(xOffset, 0, size.width, size.height)];
		EGOImageView *appImgView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
		appImgView.imageURL = [NSURL URLWithString:url];
		
		if (type == 2) {
			appImgView.center = CGPointMake(size.width * 0.5, size.height * 0.5);
			[holderView addSubview:appImgView];
			[_imgScrollView addSubview:holderView];
			
			
			appImgView.transform = CGAffineTransformMakeRotation(3.0 * M_PI / 2);
			appImgView.center = CGPointMake(0.0, 0.0);
			frame = appImgView.frame;
			frame.origin.x += size.height * 0.5;
			frame.origin.y += size.width * 0.5;
			appImgView.frame = frame;	
			
		} else {
			[holderView addSubview:appImgView];
			[_imgScrollView addSubview:holderView];
		}
		
		xOffset += 320;
		[url release];
		[holderView release];
		[appImgView release];
	}
	
	_paginationView = [[DIPaginationView alloc] initWithTotal:[_offer.images count] coords:CGPointMake(160, 510 + textSize.height)];
	[scrollView addSubview:_paginationView];
	
	
	
	UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 348, 320, 72)] autorelease];
	footerView.backgroundColor = [UIColor colorWithRed:0.2706 green:0.7804 blue:0.4549 alpha:1.0];
	[self.view addSubview:footerView];
	
	UIButton *watchButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	watchButton.frame = CGRectMake(0, 352, 320, 59);
	watchButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	watchButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[watchButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[watchButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[watchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[watchButton setTitle:@"watch trailer now" forState:UIControlStateNormal];
	[watchButton addTarget:self action:@selector(_goWatch) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:watchButton];
	
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


-(void)dealloc {
	[_offer release];
	[_paginationView release];
	[_imgScrollView release];
	
	[super dealloc];
}


#pragma mark - navigation
-(void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)_goWatch {
	DIOfferVideoViewController *offersVideoViewController = [[[DIOfferVideoViewController alloc] initWithURL:_offer.video_url] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:offersVideoViewController] autorelease];
	[navigationController setNavigationBarHidden:YES animated:NO];
	[self.navigationController presentModalViewController:navigationController animated:YES];	
}

-(void)_goHelp {
	DIOffersHelpViewController *offersHelpViewController = [[[DIOffersHelpViewController alloc] initWithTitle:@"need help?" header:@"earning didds is easy and fun" closeLabel:@"Done"] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:offersHelpViewController] autorelease];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}

#pragma mark - ScrollView Delegates
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	int page = _imgScrollView.contentOffset.x / 320;
	
	[_paginationView updToPage:page];
	NSLog(@"SCROLL PAGE:[%d]", page);
}

@end
