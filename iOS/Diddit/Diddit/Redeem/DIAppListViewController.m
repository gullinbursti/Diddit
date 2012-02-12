//
//  DIRedeemStoreViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAppDelegate.h"
#import "DINavTitleView.h"
#import "DINavBackBtnView.h"
#import "DIPaginationView.h"
#import "DIFeaturedItemButton.h"
#import "DIAppDetailsViewController.h"
#import "DIAppListViewController.h"
#import "DIAppViewCell.h"
#import "DIStoreItemButton.h"

@implementation DIAppListViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		_features = [[NSMutableArray alloc] init];
		_apps = [[NSMutableArray alloc] init];
		_giftCards = [[NSMutableArray alloc] init];
		
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"store"] autorelease];
		
		DINavBackBtnView *backBtnView = [[[DINavBackBtnView alloc] init] autorelease];
		[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_goFeatured:) name:@"PUSH_FEATURED" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_goApp:) name:@"PUSH_STORE_APP" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_goCard:) name:@"PUSH_STORE_CARD" object:nil];
	}
	
	return (self);
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

-(void)loadView {
	[super loadView];
	
	CGRect frame;
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]] autorelease];
	[self.view addSubview:bgImgView];
	
	_mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	_mainScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_mainScrollView.opaque = NO;
	_mainScrollView.scrollsToTop = NO;
	_mainScrollView.showsHorizontalScrollIndicator = NO;
	_mainScrollView.showsVerticalScrollIndicator = NO;
	_mainScrollView.alwaysBounceVertical = NO;
	_mainScrollView.contentSize = self.view.bounds.size;
	[self.view addSubview:_mainScrollView];
	
	_featuredScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 22, 320, 170)];
	_featuredScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_featuredScrollView.opaque = NO;
	_featuredScrollView.scrollsToTop = NO;
	_featuredScrollView.pagingEnabled = YES;
	_featuredScrollView.delegate = self;
	_featuredScrollView.showsHorizontalScrollIndicator = NO;
	_featuredScrollView.showsVerticalScrollIndicator = NO;
	_featuredScrollView.alwaysBounceVertical = NO;
	_featuredScrollView.bounces = NO;
	_featuredScrollView.contentSize = CGSizeMake(320, 100);
	[_mainScrollView addSubview:_featuredScrollView];
	
	_cardsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 178, 320, 192)];
	_cardsScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_cardsScrollView.opaque = NO;
	_cardsScrollView.scrollsToTop = NO;
	_cardsScrollView.pagingEnabled = NO;
	_cardsScrollView.delegate = self;
	_cardsScrollView.showsHorizontalScrollIndicator = NO;
	_cardsScrollView.showsVerticalScrollIndicator = NO;
	_cardsScrollView.alwaysBounceVertical = NO;
	_cardsScrollView.contentSize = CGSizeMake(320, 145);
	[_mainScrollView addSubview:_cardsScrollView];
	
	
	UIView *cardsHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 178, 320, 35)] autorelease];
	cardsHeaderView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.05];
	[_mainScrollView addSubview:cardsHeaderView];
	
	UILabel *cardsLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 10, 300.0, 16)];
	cardsLabel.font = [[DIAppDelegate diOpenSansFontBold] fontWithSize:10.0];
	cardsLabel.backgroundColor = [UIColor clearColor];
	cardsLabel.textColor = [DIAppDelegate diColor5D5D5D];
	cardsLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	cardsLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	cardsLabel.text = @"Gift cards and credits";
	[cardsHeaderView addSubview:cardsLabel];
	
	_appsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 327, 320, 192)];
	_appsScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_appsScrollView.opaque = NO;
	_appsScrollView.scrollsToTop = NO;
	_appsScrollView.pagingEnabled = NO;
	_appsScrollView.delegate = self;
	_appsScrollView.showsHorizontalScrollIndicator = NO;
	_appsScrollView.showsVerticalScrollIndicator = NO;
	_appsScrollView.alwaysBounceVertical = NO;
	_appsScrollView.contentSize = CGSizeMake(320, 145);
	[_mainScrollView addSubview:_appsScrollView];
	
	UIView *appsHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 327, 320, 35)] autorelease];
	appsHeaderView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.05];
	[_mainScrollView addSubview:appsHeaderView];
	
	UILabel *appsLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 10, 300.0, 16)];
	appsLabel.font = [[DIAppDelegate diOpenSansFontBold] fontWithSize:10.0];
	appsLabel.backgroundColor = [UIColor clearColor];
	appsLabel.textColor = [DIAppDelegate diColor5D5D5D];
	appsLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	appsLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	appsLabel.text = @"Paid Applications";
	[appsHeaderView addSubview:appsLabel];
	
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	
	_featuredDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kServerPath, @"Store.php"]]] retain];
	[_featuredDataRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
	[_featuredDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[_featuredDataRequest setDelegate:self];
	[_featuredDataRequest startAsynchronous];
}

-(void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}


-(void)dealloc {
	[_mainScrollView release];
	[_featuredScrollView release];
	[_paginationView release];
	[_featuredDataRequest release];
	[_appsDataRequest release];
	[_features release];
	[_apps release];
	[_giftCards release];
	[_loadOverlay release];
	
	[super dealloc];
}


#pragma mark - navigation
-(void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)_goFeatured:(NSNotification *)notification {
	NSLog(@"GO FEATURE!!! [%d]", [(NSNumber *)[notification object] intValue]);
	[self.navigationController pushViewController:[[[DIAppDetailsViewController alloc] initWithApp:(DIApp *)[_features objectAtIndex:[(NSNumber *)[notification object] intValue]]] autorelease] animated:YES];
}

-(void)_goApp:(NSNotification *)notification {
	[self.navigationController pushViewController:[[[DIAppDetailsViewController alloc] initWithApp:(DIApp *)[_apps objectAtIndex:[(NSNumber *)[notification object] intValue]]] autorelease] animated:YES];
}

-(void)_goCard:(NSNotification *)notification {
	[self.navigationController pushViewController:[[[DIAppDetailsViewController alloc] initWithApp:(DIApp *)[_giftCards objectAtIndex:[(NSNumber *)[notification object] intValue]]] autorelease] animated:YES];
}


#pragma mark - Notifications
-(void)_goStatsUpdate:(NSNotification *)notification {
	//[[_choreStatsView ptsBtn] setTitle:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle] forState:UIControlStateNormal];
}

#pragma mark - ScrollView Delegates
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	int page = _featuredScrollView.contentOffset.x / 320;
	
	[_paginationView updToPage:page];
	NSLog(@"SCROLL PAGE:[%d]", page);
}

#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	NSLog(@"AppListViewController [_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	
	if ([request isEqual:_appsDataRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			NSArray *parsedApps = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				NSMutableArray *appList = [NSMutableArray array];
				NSMutableArray *cardList = [NSMutableArray array];
				
				for (NSDictionary *serverApp in parsedApps) {
					DIApp *app = [DIApp appWithDictionary:serverApp];
					
					//NSLog(@"APP \"%@\" (%d)", app.title, app.type_id);
					
					if (app != nil) {
						
						if (app.type_id == 1)
							[appList addObject:app];
						
						else
							[cardList addObject:app];
					}
				}
				
				_apps = [appList retain];
				_giftCards = [cardList retain];
				
				int i = 0;
				for (DIApp *app in _giftCards) {
					DIStoreItemButton *storeItemButton = [[[DIStoreItemButton alloc] initWithApp:app AtIndex:i] autorelease];
					CGRect frame = storeItemButton.frame;
					frame.origin.x = 20 + (i * 90);
					frame.origin.y = 52;
					storeItemButton.frame = frame;
					[_cardsScrollView addSubview:storeItemButton];
					i++;
				}
				_cardsScrollView.contentSize = CGSizeMake(20 + ([_giftCards count] * 90), 145);
				
				i = 0;
				for (DIApp *app in _apps) {
					DIStoreItemButton *storeItemButton = [[[DIStoreItemButton alloc] initWithApp:app AtIndex:i] autorelease];
					CGRect frame = storeItemButton.frame;
					frame.origin.x = 20 + (i * 90);
					frame.origin.y = 52;
					storeItemButton.frame = frame;
					[_appsScrollView addSubview:storeItemButton];
					i++;
				}
				_appsScrollView.contentSize = CGSizeMake(20 + ([_apps count] * 90), 145);
				
				//[choreList sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO]]];
			}
		}
	
	} else {
		@autoreleasepool {
			NSError *error = nil;
			NSArray *parsedApps = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				NSMutableArray *appList = [NSMutableArray array];
				
				for (NSDictionary *serverApp in parsedApps) {
					DIApp *app = [DIApp appWithDictionary:serverApp];
					
					NSLog(@"APP \"%@\" (%@)", app.title, app.img_url);
					
					if (app != nil)
						[appList addObject:app];
				}
				
				_features = [appList retain];
			}
			
			for (int i=0; i<[_features count]; i++) {
				DIFeaturedItemButton *featuredItemButton = [[DIFeaturedItemButton alloc] initWithApp:(DIApp *)[_features objectAtIndex:i] AtIndex:i];
				CGRect frame = featuredItemButton.frame;
				frame.origin.x = 25 + (i * 320);
				featuredItemButton.frame = frame;
				[_featuredScrollView addSubview:featuredItemButton];
			}
			
			_featuredScrollView.contentSize = CGSizeMake(320 * [_features count], 100);
			_paginationView = [[DIPaginationView alloc] initWithTotal:[_features count] coords:CGPointMake(160, 165)];
			[_mainScrollView addSubview:_paginationView];
			
			_appsDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kServerPath, @"Store.php"]]] retain];
			[_appsDataRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
			[_appsDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
			[_appsDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"sub_id"] forKey:@"subID"];
			[_appsDataRequest setDelegate:self];
			[_appsDataRequest startAsynchronous];
			
		}
		
		[_loadOverlay remove];	
	}
}


-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
}


@end
