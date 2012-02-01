//
//  DIChoreListViewController.m
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIMasterListViewController.h"

#import "DIAppDelegate.h"
#import "DIChoreStatsView.h"
#import "DIAddChoreTypeViewController.h"
#import "DIAppListViewController.h"
#import "DIAppDetailsViewController.h"
#import "DIOfferListViewController.h"
#import "DIOfferDetailsViewController.h"
#import "DISettingsViewController.h"
#import "DIMyChoresViewCell.h"
#import "DISubDeviceViewController.h"
#import "DISponsorship.h"
#import "DIDevice.h"

#import "DIAddNewRewardViewController.h"

#import "MBProgressHUD.h"

@implementation DIMasterListViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadData:) name:@"DISMISS_WELCOME_SCREEN" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goAddChore:) name:@"PRESENT_ADD_CHORE" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadData:) name:@"REFRESH_CHORE_LIST" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_addChore:) name:@"ADD_CHORE" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_finishChore:) name:@"FINISH_CHORE" object:nil];
		
		_activity = [[NSMutableArray alloc] init];
		_devices = [[NSMutableArray alloc] init];
		
		_devicesToggleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		_devicesToggleButton.frame = CGRectMake(0.0, 3.0, 69.0, 39.0);
		[_devicesToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleLeft_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
		[_devicesToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleLeft_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
		[_devicesToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleLeft_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateSelected];
		_devicesToggleButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		_devicesToggleButton.titleLabel.shadowColor = [UIColor blackColor];
		_devicesToggleButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		_devicesToggleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
		[_devicesToggleButton setTitle:@"Devices" forState:UIControlStateNormal];
		[_devicesToggleButton addTarget:self action:@selector(_goDevices) forControlEvents:UIControlEventTouchUpInside];
		
		_activityToggleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		_activityToggleButton.frame = CGRectMake(69.0, 3.0, 69.0, 39.0);
		[_activityToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleRight_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
		[_activityToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleRight_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
		[_activityToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleRight_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateSelected];
		_activityToggleButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		_activityToggleButton.titleLabel.shadowColor = [UIColor blackColor];
		_activityToggleButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		_activityToggleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 3);
		[_activityToggleButton setTitle:@"Activity" forState:UIControlStateNormal];
		[_activityToggleButton addTarget:self action:@selector(_goActivity) forControlEvents:UIControlEventTouchUpInside];
		
		UIView *ltBtnView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 138.0, 39.0)] autorelease];
		[ltBtnView addSubview:_devicesToggleButton];
		[ltBtnView addSubview:_activityToggleButton];
		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:ltBtnView] autorelease];
		//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rtBtnView] autorelease];
		
		_loadOverlay = [[DILoadOverlay alloc] init];
		_devicesRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
		[_devicesRequest setPostValue:[NSString stringWithFormat:@"%d", 7] forKey:@"action"];
		[_devicesRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[_devicesRequest setDelegate:self];
		[_devicesRequest startAsynchronous];
		
		/*
		 _activityRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
		[_activityRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
		[_activityRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[_activityRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"sub_id"] forKey:@"subID"];
		[_activityRequest setDelegate:self];
		[_activityRequest startAsynchronous];
		 */
	}
	
	return (self);
}
	
-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

-(void)viewDidLoad {
	[super viewDidLoad];
	
	CGRect frame;
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]] autorelease];
	[self.view addSubview:bgImgView];
	
	_activityTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_activityTableView.rowHeight = 290;
	_activityTableView.backgroundColor = [UIColor clearColor];
	_activityTableView.separatorColor = [UIColor clearColor];
	_activityTableView.dataSource = self;
	_activityTableView.delegate = self;
	_activityTableView.layer.borderColor = [[UIColor clearColor] CGColor];
	_activityTableView.layer.borderWidth = 1.0;
	_activityTableView.hidden = YES;
	
	_footerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"footerBG.png"]];
	frame = _footerImgView.frame;
	frame.origin.y = 420 - (frame.size.height + 4);
	_footerImgView.frame = frame;
	[self.view addSubview:_footerImgView];
			
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
	
	UIButton *guideBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain]; 
	guideBtn.frame = CGRectMake(15, 357, 79, 54);
	[guideBtn setBackgroundImage:[[UIImage imageNamed:@"guide_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[guideBtn setBackgroundImage:[[UIImage imageNamed:@"guide_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[guideBtn addTarget:self action:@selector(_goGuide) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:guideBtn];
	
	UIButton *settingsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	settingsButton.frame = CGRectMake(220, 357, 79, 54);
	[settingsButton setBackgroundImage:[[UIImage imageNamed:@"settingsIcon_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[settingsButton setBackgroundImage:[[UIImage imageNamed:@"settingsIcon_active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[settingsButton addTarget:self action:@selector(_goSettings) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:settingsButton];
	
	
	UIButton *rewardButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	rewardButton.frame = CGRectMake(125, 357.0, 79, 54);
	[rewardButton setBackgroundImage:[[UIImage imageNamed:@"reward_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[rewardButton setBackgroundImage:[[UIImage imageNamed:@"reward_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[rewardButton addTarget:self action:@selector(_goFooterAnimation) forControlEvents:UIControlEventTouchDown];
	[rewardButton addTarget:self action:@selector(goRewards) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:rewardButton];
	
	_devicesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height - 100.0)];
	_devicesScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_devicesScrollView.delegate = self;
	_devicesScrollView.opaque = NO;
	_devicesScrollView.contentSize = CGSizeMake(320.0 * 3.0, _devicesScrollView.frame.size.height - 100);
	_devicesScrollView.pagingEnabled = YES;
	_devicesScrollView.scrollsToTop = NO;
	_devicesScrollView.showsHorizontalScrollIndicator = NO;
	_devicesScrollView.showsVerticalScrollIndicator = NO;
	_devicesScrollView.alwaysBounceVertical = NO;
	[self.view addSubview:_devicesScrollView];
}

-(void)viewDidUnload {
    [super viewDidUnload];
}


-(void)dealloc {
	[_activityRequest release];
	[_loadOverlay release];
	[_activityTableView release];
	[_devices release];
	[_activity release];
	[_footerImgView release];
	
	[super dealloc];
}

#pragma mark - Button Handlers
-(void)_goDevices {
	[_devicesToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleLeft_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
	[_devicesToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleLeft_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	
	[_activityToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleRight_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	
	_activityTableView.hidden = YES;	
	
	_devicesRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
	[_devicesRequest setPostValue:[NSString stringWithFormat:@"%d", 7] forKey:@"action"];
	[_devicesRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[_devicesRequest setDelegate:self];
	[_devicesRequest startAsynchronous];
}

-(void)_goActivity {
	[_activityToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleRight_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
	[_activityToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleRight_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	
	[_devicesToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleLeft_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	
	_activityTableView.hidden = NO;
	[_activityTableView reloadData];
	
	[_activityTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


-(void)_goSettings {
	[self.navigationController pushViewController:[[[DISettingsViewController alloc] init] autorelease] animated:YES];
}

-(void)_goFooterAnimation {
	
	/*
	[UIView animateWithDuration:0.15 animations:^{
		_footer1ImgView.hidden = YES;
		_footer2ImgView.hidden = NO;
	
	} completion:^(BOOL finished){
		[UIView animateWithDuration:0.15 animations:^{
			_footer2ImgView.hidden = YES;
			_footer3ImgView.hidden = NO;
		}];
	}];
	*/
}


-(void)_goGuide {
	//[self.navigationController pushViewController:[[[DIAppListViewController alloc] init] autorelease] animated:YES];
}

-(void)_goAchievements {
	
}


#pragma mark - Notification Handlers
-(void)_loadData:(NSNotification *)notification {
	/*
	_loadOverlay = [[DILoadOverlay alloc] init];
	 _activityRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
	[_activityRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
	[_activityRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[_activityRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"sub_id"] forKey:@"subID"];
	[_activityRequest setDelegate:self];
	[_activityRequest startAsynchronous];
	*/
	
	//_achievementsRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Achievements.php"]] retain];
	//[_achievementsRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
	//[_achievementsRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	//[_achievementsRequest setDelegate:self];
	//[_achievementsRequest startAsynchronous];
}

-(void)goAddChore:(NSNotification *)notification {
	
	/*
	 [UIView animateWithDuration:0.15 animations:^{
	 _footer3ImgView.hidden = YES;
	 _footer2ImgView.hidden = NO;
	 
	 } completion:^(BOOL finished){
	 [UIView animateWithDuration:0.15 animations:^{
	 _footer2ImgView.hidden = YES;
	 _footer1ImgView.hidden = NO;
	 }];
	 }];
	 */
	
	DIAddNewRewardViewController *addChoreViewController = [[[DIAddNewRewardViewController alloc] init] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:addChoreViewController] autorelease];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}


-(void)_addChore:(NSNotification *)notification {
	/*
	if (_isRewardList) {
		[_rewards insertObject:(DIChore *)[notification object] atIndex:0];	
		[_myRewardsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
		
	} else {
		[_chores insertObject:(DIChore *)[notification object] atIndex:0];	
		[_myChoresTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
	}
	
	[_activeDisplay insertObject:(DIChore *)[notification object] atIndex:0];
	*/
	
	NSLog(@"ChoreListViewController - addChore:[]");
}


-(void)_finishChore:(NSNotification *)notification {
	DIChore *chore = (DIChore *)[notification object];
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	
	_userUpdRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
	[_userUpdRequest setPostValue:[NSString stringWithFormat:@"%d", 4] forKey:@"action"];
	[_userUpdRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[_userUpdRequest setPostValue:[NSString stringWithFormat:@"%d", chore.points] forKey:@"points"];
	[_userUpdRequest setDelegate:self];
	[_userUpdRequest startAsynchronous];
	
	_choreUpdRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
	[_choreUpdRequest setPostValue:[NSString stringWithFormat:@"%d", 6] forKey:@"action"];
	[_choreUpdRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[_choreUpdRequest setPostValue:[NSString stringWithFormat:@"%d", chore.chore_id] forKey:@"choreID"];
	
	if ([[NSUserDefaults standardUserDefaults] valueForKey:chore.imgPath]) {
		[[NSUserDefaults standardUserDefaults] setObject:nil forKey:chore.imgPath];
	}
	
	[_activity removeObjectIdenticalTo:chore];
	[_activityTableView reloadData];	
}

#pragma mark - ScrollView Delegates
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	int page = _devicesScrollView.contentOffset.x / 320;
	
	[_paginationView updToPage:page];
	NSLog(@"SCROLL PAGE:[(%f) %d]", _devicesScrollView.contentOffset.x, page);
}


#pragma mark - TableView Data Source Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//return ((_isRewardList) ? [_rewards count] + 1 : [_chores count] + 1);
	return ([_activity count]);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
//	if (indexPath.row == 0) {
//		UITableViewCell *cell = nil;
//		cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//		
//		if (cell == nil) {			
//			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
//			[cell addSubview:_sponsorshipHolderView];
//			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//		}
//		
//		return (cell);
//		
//	} else 
	DIMyChoresViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIMyChoresViewCell cellReuseIdentifier]];
		
	if (cell == nil)
		cell = [[[DIMyChoresViewCell alloc] init] autorelease];
	
	cell.chore = [_activity objectAtIndex:indexPath.row];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
	return (cell);
}

#pragma mark - TableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	DIMyChoresViewCell *cell = (DIMyChoresViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	[cell toggleSelected];
	
//	if (_isRewardList) {
//		[[NSNotificationCenter defaultCenter] postNotificationName:@"FINISH_CHORE" object:cell.chore];
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reward Redeemed" message:@"Added your didds" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//		[alert show];
//		[alert release];
//		
//		//[self.navigationController pushViewController:[[[DIChoreDetailsViewController alloc] initWithChore:[_chores objectAtIndex:indexPath.row]] autorelease] animated:YES];	
//	
//	} else {
//		//[self.navigationController pushViewController:[[[DIChoreDetailsViewController alloc] initWithChore:[_chores objectAtIndex:indexPath.row]] autorelease] animated:YES];	
//	}
//	
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	/*
	[UIView animateWithDuration:0.2 animations:^(void) {
		cell.alpha = 0.5;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.15 animations:^(void) {
			cell.alpha = 1.0;
			
			[self.navigationController pushViewController:[[[DIChoreDetailsViewController alloc] initWithChore:[_chores objectAtIndex:indexPath.row]] autorelease] animated:YES];	
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		}];
	}];
	 */
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (90);
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	//	cell.textLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12.0];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	NSLog(@"ChoreListViewController [_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	if ([request isEqual:_devicesRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			NSArray *parsedDevices = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				NSMutableArray *deviceList = [NSMutableArray array];
				_viewControllers = [NSMutableArray new];
				
				for (NSDictionary *serverDevice in parsedDevices) {
					DIDevice *device = [DIDevice deviceWithDictionary:serverDevice];
					
					//NSLog(@"APP \"%@\"", app.title);
					
					if (device != nil)
						[deviceList addObject:device];
					
					DISubDeviceViewController *subDeviceViewController = [[[DISubDeviceViewController alloc] initWithDevice:device] autorelease];
					[_viewControllers addObject:subDeviceViewController];
				}
				
				_devices = [deviceList retain];
				
				_devicesScrollView.contentSize = CGSizeMake(_devicesScrollView.frame.size.width * [_viewControllers count], _devicesScrollView.frame.size.height);
				
				NSInteger page = 0;
				for (DISubDeviceViewController *deviceViewController in _viewControllers) {
					deviceViewController.view.frame = CGRectMake(page * _devicesScrollView.frame.size.width, 0.0, _devicesScrollView.frame.size.width, _devicesScrollView.frame.size.height);
					[_devicesScrollView addSubview:deviceViewController.view];
					page++;
				}
				
				_paginationView = [[DIPaginationView alloc] initWithTotal:[_devices count] coords:CGPointMake(160, 330)];
				[self.view addSubview:_paginationView];
			}			
		}
		
		[_loadOverlay remove];
		
	} else if ([request isEqual:_activityRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			NSArray *parsedList = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				NSMutableArray *activityList = [NSMutableArray array];
				
				for (NSDictionary *dict in parsedList) {
					DIChore *chore = [DIChore choreWithDictionary:dict];
					
					NSLog(@"CHORE \"%@\" (%d)", chore.title, chore.type_id);
					[activityList addObject:chore];
				}
				
				_activity = [activityList retain];
				
				[_activityTableView reloadData];
			}			
		}
		
		[_loadOverlay remove];
	
	} else if ([request isEqual:_userUpdRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			NSDictionary *parsedUser = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				[DIAppDelegate setUserProfile:parsedUser];
				[_choreUpdRequest startAsynchronous];
			}
		}
		
		[_loadOverlay remove];
		
	} else if ([request isEqual:_choreUpdRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			//NSDictionary *parsedTotal = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
			}
		}
		
		[_loadOverlay remove];
	}
	
	
	
	/*else if ([request isEqual:_achievementsRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			NSArray *parsedAchievements = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				NSMutableArray *achievementList = [NSMutableArray array];
				
				for (NSDictionary *serverAchievement in parsedAchievements) {
					DIChore *achievement = [DIChore choreWithDictionary:serverAchievement];
					
					if (achievement != nil)
						[achievementList addObject:achievement];
				}
				
				_achievements = [achievementList retain];
			}
		}
	}*/
}


-(void)requestFailed:(ASIHTTPRequest *)request {

	if (request == _activityRequest) {
		//[_delegates perform:@selector(jobList:didFailLoadWithError:) withObject:self withObject:request.error];
		//MBL_RELEASE_SAFELY(_jobListRequest);
	}
	
	[_loadOverlay remove];
}

@end
