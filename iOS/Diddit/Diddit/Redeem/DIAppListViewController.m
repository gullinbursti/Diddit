//
//  DIRedeemStoreViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAppDelegate.h"
#import "DINavTitleView.h"
#import "DINavHomeIcoBtnView.h"
#import "DIPaginationView.h"
#import "DIChoreStatsView.h"
#import "DIFeaturedItemButton.h"
#import "DIOffersHelpViewController.h"
#import "DIAppDetailsViewController.h"
#import "DIAppListViewController.h"
#import "DIOfferListViewController.h"
#import "DIAppViewCell.h"

@implementation DIAppListViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		_features = [[NSMutableArray alloc] init];
		_apps = [[NSMutableArray alloc] init];
		_cells =[[NSMutableArray alloc] init];
		
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"store"] autorelease];
		
		DINavHomeIcoBtnView *homeBtnView = [[[DINavHomeIcoBtnView alloc] init] autorelease];
		[[homeBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:homeBtnView] autorelease];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_goFeatured:) name:@"PUSH_FEATURED" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_goStatsUpdate:) name:@"UPDATE_STATS" object:nil];
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
	
	_choreStatsView = [[[DIChoreStatsView alloc] initWithFrame:CGRectMake(10, 13, 300, 34)] autorelease];
	[self.view addSubview:_choreStatsView];
	
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
	[self.view addSubview:offersBtn];
	
	UIImageView *dividerImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]] autorelease];
	frame = dividerImgView.frame;
	frame.origin.y = 61;
	dividerImgView.frame = frame;
	[self.view addSubview:dividerImgView];
	
	_featuredView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 230)];
	
	_appsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 62, self.view.bounds.size.width, self.view.bounds.size.height - 56) style:UITableViewStylePlain];
	_appsTableView.rowHeight = 80;
	_appsTableView.backgroundColor = [UIColor clearColor];
	_appsTableView.separatorColor = [UIColor clearColor];
	_appsTableView.delegate = self;
	_appsTableView.dataSource = self;
	[self.view addSubview:_appsTableView];
	_appsTableView.hidden = YES;
	
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	
	_appsDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Store.php"]] retain];
	[_appsDataRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
	[_appsDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[_appsDataRequest setDelegate:self];
	[_appsDataRequest startAsynchronous];
}

-(void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}


-(void)dealloc {
	[_featuredView release];
	[_featuredScrollView release];
	[_paginationView release];
	[_appsTableView release];
	[_featuredDataRequest release];
	[_appsDataRequest release];
	[_features release];
	//[_apps release];
	[_cells release];
	[_loadOverlay release];
	
	[super dealloc];
}


#pragma mark - navigation
-(void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)_goOffers {
	//[self.navigationController popViewControllerAnimated:NO];
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"PUSH_OFFERS_SCREEN" object:nil];
	
	//	[self.navigationController dismissViewControllerAnimated:YES completion:^(void) {
	//		[[NSNotificationCenter defaultCenter] postNotificationName:@"PUSH_OFFERS_SCREEN" object:nil];
	//	}];
	
	[self.navigationController pushViewController:[[[DIOfferListViewController alloc] init] autorelease] animated:YES];
}

-(void)_goFeatured:(NSNotification *)notification {
	NSLog(@"GO FEATURE!!! [%d]", [(NSNumber *)[notification object] intValue]);
	[self.navigationController pushViewController:[[[DIAppDetailsViewController alloc] initWithApp:(DIApp *)[_features objectAtIndex:[(NSNumber *)[notification object] intValue]]] autorelease] animated:YES];
}


#pragma mark - Notifications
-(void)_goStatsUpdate:(NSNotification *)notification {
	[[_choreStatsView ptsBtn] setTitle:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle] forState:UIControlStateNormal];
}

#pragma mark - TableView Data Source Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([_apps count] + 1);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) {
		UITableViewCell *cell = nil;
		cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
		
		if (cell == nil) {			
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			[cell addSubview:_featuredView];
		}
		
		[_cells addObject:cell];
		return (cell);
		
	} else {
		DIAppViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIAppViewCell cellReuseIdentifier]];
		
		if (cell == nil)
			cell = [[[DIAppViewCell alloc] init] autorelease];
		
		cell.app = [_apps objectAtIndex:indexPath.row - 1];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		[_cells addObject:cell];
		return (cell);		
	}
}



/*
#pragma mark - TableView Delegates
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return (136);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return (_featuredView);
}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"SELECTED [%d]", indexPath.row);
	
	if (indexPath.row > 0) {
		DIAppViewCell *cell = (DIAppViewCell *)[tableView cellForRowAtIndexPath:indexPath];
		[cell toggleSelected];
		
		[self.navigationController pushViewController:[[[DIAppDetailsViewController alloc] initWithApp:(DIApp *)[_apps objectAtIndex:indexPath.row - 1]] autorelease] animated:YES];
	}	
}

/*
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"DESELECTED [%d]", indexPath.row);
	
	UITableViewCell *cell = (UITableViewCell *)[_cells objectAtIndex:indexPath.row];
	cell.alpha = 1.0;
	
	DIApp *app = (DIApp *)[_apps objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:[[[DIAppDetailsViewController alloc] initWithApp:app] autorelease] animated:YES];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0)
		return (230);
	else
		return (80);
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	//	cell.textLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12.0];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
}


#pragma mark - ScrollView Delegates
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	int page = _featuredScrollView.contentOffset.x / 160;
	
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
				
				for (NSDictionary *serverApp in parsedApps) {
					DIApp *app = [DIApp appWithDictionary:serverApp];
					
					//NSLog(@"APP \"%@\"", app.title);
					
					if (app != nil)
						[appList addObject:app];
				}
				
				_apps = [appList retain];
				[_appsTableView reloadData];
				
				if ([_apps count] > 0) {
					_appsTableView.hidden = NO;
					//_emptyLabel.hidden = YES;
				}
				
				//[choreList sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO]]];
			}
			
			_featuredDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Store.php"]] retain];
			[_featuredDataRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
			[_featuredDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
			[_featuredDataRequest setDelegate:self];
			[_featuredDataRequest startAsynchronous];
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
					
					//NSLog(@"APP \"%@\"", app.title);
					
					if (app != nil)
						[appList addObject:app];
				}
				
				_features = [appList retain];
			}
			
			for (int i=0; i<[_features count]; i++) {
				int col = i % 2;
				int row = i / 2;
				
				//DIFeaturedItemButton *featuredItemButton = [[[DIFeaturedItemButton alloc] initWithImage:[UIImage imageNamed:@"storeFeature.png"]] retain];
				DIFeaturedItemButton *featuredItemButton = [[DIFeaturedItemButton alloc] initWithApp:(DIApp *)[_features objectAtIndex:i] AtIndex:i];
				CGRect frame = featuredItemButton.frame;
				frame.origin.x = col * 154;
				frame.origin.y = row * 114;
				featuredItemButton.frame = frame;
				[_featuredView addSubview:featuredItemButton];
			}
			
			UIImageView *divider1ImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]] autorelease];
			CGRect frame = divider1ImgView.frame;
			frame.origin.x = -10;
			frame.origin.y = 104;
			divider1ImgView.frame = frame;
			[_featuredView addSubview:divider1ImgView];
			
			UIImageView *divider2ImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]] autorelease];
			frame = divider2ImgView.frame;
			frame.origin.x = -10;
			frame.origin.y = 220;
			divider2ImgView.frame = frame;
			[_featuredView addSubview:divider2ImgView];
		}
		
		[_loadOverlay remove];	
	}
}


-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
}


@end
