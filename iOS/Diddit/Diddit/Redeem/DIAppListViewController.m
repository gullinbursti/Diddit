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
	}
	
	return (self);
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	
	_featuredDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Store.php"]] retain];
	[_featuredDataRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
	[_featuredDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[_featuredDataRequest setDelegate:self];
	//[_featuredDataRequest startAsynchronous];
	
	_appsDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Store.php"]] retain];
	[_appsDataRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
	[_appsDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[_appsDataRequest setDelegate:self];
	[_appsDataRequest startAsynchronous];
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]] autorelease];
	[self.view addSubview:bgImgView];
	
	DIChoreStatsView *choreStatsView = [[[DIChoreStatsView alloc] initWithFrame:CGRectMake(10, 13, 300, 34)] autorelease];
	[self.view addSubview:choreStatsView];
	
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
	
	
	
	UIImageView *dividerImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerDivider.png"]] autorelease];
	CGRect frame = dividerImgView.frame;
	frame.origin.y = 54;
	dividerImgView.frame = frame;
	[self.view addSubview:dividerImgView];
	
	_featuredView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 230)];
	[self fillFeatured:4];
	
	_appsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 56, self.view.bounds.size.width, self.view.bounds.size.height - 56) style:UITableViewStylePlain];
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
	[_apps release];
	[_cells release];
	[_loadOverlay release];
	
	[super dealloc];
}


#pragma mark - Layout
-(void)fillFeatured:(int)tot {
	
	for (int i=0; i<tot; i++) {
		
		int col = i % 2;
		int row = i / 2;
		
		DIFeaturedItemButton *featuredItemButton = [[[DIFeaturedItemButton alloc] initWithImage:[UIImage imageNamed:@"storeFeature.png"]] retain];
		CGRect frame = featuredItemButton.frame;
		frame.origin.x = col * 154;
		frame.origin.y = row * 104;
		featuredItemButton.frame = frame;
		
		[featuredItemButton addTarget:self action:@selector(_goFeature) forControlEvents:UIControlEventTouchUpInside];
		[_featuredView addSubview:featuredItemButton];
	}
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

-(void)_goFeature {
	NSLog(@"GO FEATURE!!!");
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
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
		
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
		UITableViewCell *cell = (UITableViewCell *)[_cells objectAtIndex:indexPath.row];
		cell.alpha = 1.0;
		
		DIApp *app = (DIApp *)[_apps objectAtIndex:indexPath.row - 1];
		
		[self.navigationController pushViewController:[[[DIAppDetailsViewController alloc] initWithApp:app] autorelease] animated:YES];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		
		/*
		UITableViewCell *cell = (UITableViewCell *)[_cells objectAtIndex:indexPath.row];
		[UIView animateWithDuration:0.125 animations:^(void){cell.alpha = 0.5;} completion:^(BOOL finished){
			cell.alpha = 0.85;
			
			UITableViewCell *cell = (UITableViewCell *)[_cells objectAtIndex:indexPath.row];
			cell.alpha = 1.0;
			
			DIApp *app = (DIApp *)[_apps objectAtIndex:indexPath.row];
			
			[self.navigationController pushViewController:[[[DIAppDetailsViewController alloc] initWithApp:app] autorelease] animated:YES];
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		}];
		*/
		//
		//[UIView animateWithDuration:0.125 animations:^{
		//	cell.alpha = 0.5;
		//}];
		//
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
	}
	
	[_loadOverlay remove];
}


-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
}


@end
