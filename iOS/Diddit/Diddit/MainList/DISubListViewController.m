//
//  DISubListViewController.m
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DISubListViewController.h"

#import "DIAppDelegate.h"
#import "DIChoreStatsView.h"
#import "DIAddChoreTypeViewController.h"
#import "DIAppListViewController.h"
#import "DIAppDetailsViewController.h"
#import "DIOfferListViewController.h"
#import "DIOfferDetailsViewController.h"
#import "DISettingsViewController.h"
#import "DIMyChoresViewCell.h"
#import "DISponsorshipItemButton.h"
#import "DISponsorship.h"

#import "MBProgressHUD.h"

@implementation DISubListViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadData:) name:@"DISMISS_WELCOME_SCREEN" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadData:) name:@"REFRESH_CHORE_LIST" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_addChore:) name:@"ADD_CHORE" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_finishChore:) name:@"FINISH_CHORE" object:nil];
		
		_activeDisplay = [[NSMutableArray alloc] init];
		_chores = [[NSMutableArray alloc] init];
		_rewards = [[NSMutableArray alloc] init];
		
		_finishedChores = [[NSMutableArray alloc] init];
		_isRewardList = YES;
		
		_rewardsToggleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		_rewardsToggleButton.frame = CGRectMake(0.0, 3.0, 69.0, 39.0);
		[_rewardsToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleLeft_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
		[_rewardsToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleLeft_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
		[_rewardsToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleLeft_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateSelected];
		_rewardsToggleButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		_rewardsToggleButton.titleLabel.shadowColor = [UIColor blackColor];
		_rewardsToggleButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		_rewardsToggleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
		[_rewardsToggleButton setTitle:@"Rewards" forState:UIControlStateNormal];
		[_rewardsToggleButton addTarget:self action:@selector(_goRewards) forControlEvents:UIControlEventTouchUpInside];
		
		_choresToggleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		_choresToggleButton.frame = CGRectMake(69.0, 3.0, 69.0, 39.0);
		[_choresToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleRight_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
		[_choresToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleRight_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
		[_choresToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleRight_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateSelected];
		_choresToggleButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		_choresToggleButton.titleLabel.shadowColor = [UIColor blackColor];
		_choresToggleButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		_choresToggleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 3);
		[_choresToggleButton setTitle:@"Chores" forState:UIControlStateNormal];
		[_choresToggleButton addTarget:self action:@selector(_goChores) forControlEvents:UIControlEventTouchUpInside];
		
		UIView *ltBtnView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 138.0, 39.0)] autorelease];
		[ltBtnView addSubview:_rewardsToggleButton];
		[ltBtnView addSubview:_choresToggleButton];
		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:ltBtnView] autorelease];
		
		_ptsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		//_ptsButton.frame = CGRectMake(-4.0, 3.0, 69.0, 40.0);
		_ptsButton.frame = CGRectMake(-14.0, 3.0, 85.0, 40.0);
		[_ptsButton setBackgroundImage:[[UIImage imageNamed:@"diddBG_nonActive.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
		[_ptsButton setBackgroundImage:[[UIImage imageNamed:@"diddBG_Active.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateHighlighted];
		_ptsButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		[_ptsButton addTarget:self action:@selector(_goChores) forControlEvents:UIControlEventTouchUpInside];
		
		UIView *ptsHolderView = [[[UIView alloc] initWithFrame:CGRectMake(-5, 8, 40, 30)] autorelease];
		ptsHolderView.backgroundColor = [UIColor clearColor];
		ptsHolderView.clipsToBounds = YES;
		
		_pts1Label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)] autorelease];
		_pts1Label.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:11];
		_pts1Label.textColor = [UIColor colorWithRed:0.243 green:0.259 blue:0.247 alpha:1.0];
		_pts1Label.backgroundColor = [UIColor clearColor];
		_pts1Label.textAlignment = UITextAlignmentCenter;
		_pts1Label.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle];
		[ptsHolderView addSubview:_pts1Label];
		
		_pts2Label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 33, 40, 30)] autorelease];
		_pts2Label.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:11];
		_pts2Label.textColor = [UIColor colorWithRed:0.243 green:0.259 blue:0.247 alpha:1.0];
		_pts2Label.backgroundColor = [UIColor clearColor];
		_pts2Label.textAlignment = UITextAlignmentCenter;
		_pts2Label.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle];
		[ptsHolderView addSubview:_pts2Label];
		
		UIView *rtBtnView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 69.0, 40.0)] autorelease];		
		[rtBtnView addSubview:_ptsButton];
		[rtBtnView addSubview:ptsHolderView];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rtBtnView] autorelease];
		
		_loadOverlay = [[DILoadOverlay alloc] init];
		_activeChoresRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
		[_activeChoresRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
		[_activeChoresRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[_activeChoresRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"sub_id"] forKey:@"subID"];
		[_activeChoresRequest setDelegate:self];
		[_activeChoresRequest startAsynchronous];
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
	
	_emptyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 361.0)];
	_emptyScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_emptyScrollView.contentSize = CGSizeMake(320, 362.0);
	_emptyScrollView.opaque = NO;
	_emptyScrollView.scrollsToTop = NO;
	_emptyScrollView.showsHorizontalScrollIndicator = NO;
	_emptyScrollView.showsVerticalScrollIndicator = NO;
	_emptyScrollView.alwaysBounceVertical = NO;
	
	_holderView = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
	frame = _holderView.frame;
	frame.origin.y = 5.0;
	_holderView.frame = frame;
	[self.view addSubview:_holderView];
	[_holderView addSubview:_emptyScrollView];
	
	_myChoresTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_myChoresTableView.rowHeight = 290;
	_myChoresTableView.backgroundColor = [UIColor clearColor];
	_myChoresTableView.separatorColor = [UIColor clearColor];
	_myChoresTableView.dataSource = self;
	_myChoresTableView.delegate = self;
	_myChoresTableView.layer.borderColor = [[UIColor clearColor] CGColor];
	_myChoresTableView.layer.borderWidth = 1.0;
	_myChoresTableView.hidden = _isRewardList;
	
	_myRewardsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_myRewardsTableView.rowHeight = 290;
	_myRewardsTableView.backgroundColor = [UIColor clearColor];
	_myRewardsTableView.separatorColor = [UIColor clearColor];
	_myRewardsTableView.dataSource = self;
	_myRewardsTableView.delegate = self;
	_myRewardsTableView.layer.borderColor = [[UIColor clearColor] CGColor];
	_myRewardsTableView.layer.borderWidth = 1.0;
	_myRewardsTableView.hidden = !_isRewardList;
	
	_emptyListImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emptyChoreListBG.jpg"]];
	frame = _emptyListImgView.frame;
	frame.origin.x = 0.0;
	frame.origin.y = -45.0;
	_emptyListImgView.frame = frame;
	[_emptyScrollView addSubview:_emptyListImgView];
	
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
	
	UIButton *leftBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain]; 
	leftBtn.frame = CGRectMake(15, 357, 79, 54);
	[leftBtn setBackgroundImage:[[UIImage imageNamed:@"rewardsIcon_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[leftBtn setBackgroundImage:[[UIImage imageNamed:@"rewardsIcon_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[leftBtn addTarget:self action:@selector(_goApps) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:leftBtn];
	
	UIButton *settingsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	settingsButton.frame = CGRectMake(220, 357, 79, 54);
	[settingsButton setBackgroundImage:[[UIImage imageNamed:@"settingsIcon_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[settingsButton setBackgroundImage:[[UIImage imageNamed:@"settingsIcon_active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[settingsButton addTarget:self action:@selector(_goSettings) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:settingsButton];
	
	
	UIButton *achievementsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	achievementsButton.frame = CGRectMake(120, 357, 79, 54);
	[achievementsButton setBackgroundImage:[[UIImage imageNamed:@"achivementsIcon_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[achievementsButton setBackgroundImage:[[UIImage imageNamed:@"achivementsIcon_active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[achievementsButton addTarget:self action:@selector(_goAchievements) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:achievementsButton];
}

-(void)viewDidUnload {
    [super viewDidUnload];
}


-(void)dealloc {
	[_activeChoresRequest release];
	[_loadOverlay release];
	[_myChoresTableView release];
	[_myRewardsTableView release];
	[_chores release];
	[_finishedChores release];
	[_emptyListImgView release];
	[_footerImgView release];
	
	[super dealloc];
}

#pragma mark - Button Handlers
-(void)_goRewards {
	_isRewardList = YES;
	
	
	[_rewardsToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleLeft_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
	[_rewardsToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleLeft_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	
	[_choresToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleRight_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	
	_myChoresTableView.hidden = _isRewardList;
	_myRewardsTableView.hidden = !_isRewardList;
	
	_activeDisplay = [_rewards retain];
	[_myRewardsTableView reloadData];
	
	[_myChoresTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	[_myRewardsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)_goChores {
	_isRewardList = NO;
	
	[_choresToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleRight_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
	[_choresToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleRight_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	
	[_rewardsToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleLeft_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	
	_myChoresTableView.hidden = _isRewardList;
	_myRewardsTableView.hidden = !_isRewardList;
	
	_activeDisplay = [_chores retain];
	[_myChoresTableView reloadData];
	
	[_myChoresTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	[_myRewardsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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

-(void)_goApps {
	[self.navigationController pushViewController:[[[DIAppListViewController alloc] init] autorelease] animated:YES];
}

-(void)_goOffers {
	[self.navigationController pushViewController:[[[DIOfferListViewController alloc] init] autorelease] animated:YES];
}

-(void)_goAchievements {
	
}


#pragma mark - Notification Handlers
-(void)_loadData:(NSNotification *)notification {
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	_activeChoresRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
	[_activeChoresRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
	[_activeChoresRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[_activeChoresRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"sub_id"] forKey:@"subID"];
	[_activeChoresRequest setDelegate:self];
	[_activeChoresRequest startAsynchronous];
	
	//_achievementsRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Achievements.php"]] retain];
	//[_achievementsRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
	//[_achievementsRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	//[_achievementsRequest setDelegate:self];
	//[_achievementsRequest startAsynchronous];
}

-(void)_addChore:(NSNotification *)notification {
	
	if (_isRewardList) {
		[_rewards insertObject:(DIChore *)[notification object] atIndex:0];	
		[_myRewardsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
		
	} else {
		[_chores insertObject:(DIChore *)[notification object] atIndex:0];	
		[_myChoresTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
	}
	
	[_activeDisplay insertObject:(DIChore *)[notification object] atIndex:0];
	
	NSLog(@"ChoreListViewController - addChore:[]");
	
	[_emptyScrollView removeFromSuperview];
	[_holderView addSubview:_myChoresTableView];
	[_holderView addSubview:_myRewardsTableView];
	
	//_emptyListImgView.hidden = YES;
	//_myChoresTableView.hidden = NO;
	[_myChoresTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	[_myRewardsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

	//[_myChoresTableView reloadData];
	//[_myRewardsTableView reloadData];
	
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
	
	[_finishedChores addObject:chore];
	
	if ([[NSUserDefaults standardUserDefaults] valueForKey:chore.imgPath]) {
		[[NSUserDefaults standardUserDefaults] setObject:nil forKey:chore.imgPath];
	}
	
	if (_isRewardList) {
		[_rewards removeObjectIdenticalTo:chore];
		//[_myRewardsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
		
	} else {
		[_chores removeObjectIdenticalTo:chore];
		//[_myChoresTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
	}
	
	[_activeDisplay removeObjectIdenticalTo:chore];
	
	//[_myChoresTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	//[_myRewardsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
	[_myChoresTableView reloadData];
	[_myRewardsTableView reloadData];
	
	if ([_activeDisplay count] == 0) {
		[_myChoresTableView removeFromSuperview];
		[_holderView addSubview:_emptyScrollView];
	}
	
	//DIChoreCompleteViewController *choreCompleteViewController = [[[DIChoreCompleteViewController alloc] initWithChore:chore] autorelease];
	//UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:choreCompleteViewController] autorelease];
	//[self.navigationController presentModalViewController:navigationController animated:YES];
}

#pragma mark - ScrollView Delegates
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	//int page = _sponsorshipsScrollView.contentOffset.x / 154;
	
	//[_paginationView updToPage:page];
	//NSLog(@"SCROLL PAGE:[(%f) %d]", _sponsorshipsScrollView.contentOffset.x, page);
}


#pragma mark - TableView Data Source Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//return ((_isRewardList) ? [_rewards count] + 1 : [_chores count] + 1);
	return ([_activeDisplay count] + 1);
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
	if (indexPath.row < [_activeDisplay count]) {
		DIMyChoresViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIMyChoresViewCell cellReuseIdentifier]];
		
		if (cell == nil)
			cell = [[[DIMyChoresViewCell alloc] init] autorelease];
		
		if (_isRewardList)
			cell.chore = [_rewards objectAtIndex:indexPath.row];
		
		else
			cell.chore = [_chores objectAtIndex:indexPath.row];
		
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		return (cell);
	
	} else {
		UITableViewCell *cell = nil;
		cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
		
		return (cell);
	}
}

#pragma mark - TableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row >= [_activeDisplay count])
		return;
	
	DIMyChoresViewCell *cell = (DIMyChoresViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	[cell toggleSelected];
	
	if (_isRewardList) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"FINISH_CHORE" object:cell.chore];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reward Redeemed" message:@"Added your didds" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
		
		//[self.navigationController pushViewController:[[[DIChoreDetailsViewController alloc] initWithChore:[_chores objectAtIndex:indexPath.row]] autorelease] animated:YES];	
	
	} else {
		//[self.navigationController pushViewController:[[[DIChoreDetailsViewController alloc] initWithChore:[_chores objectAtIndex:indexPath.row]] autorelease] animated:YES];	
	}
	
	
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
	
	if (indexPath.row < [_activeDisplay count])
		return (290);
	
	else
		return (150);
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	//	cell.textLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12.0];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	NSLog(@"ChoreListViewController [_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	if ([request isEqual:_activeChoresRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			NSArray *parsedList = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				NSMutableArray *choreList = [NSMutableArray array];
				NSMutableArray *rewardList = [NSMutableArray array];
				
				for (NSDictionary *dict in parsedList) {
					DIChore *chore = [DIChore choreWithDictionary:dict];
					
					NSLog(@"CHORE \"%@\" (%d)", chore.title, chore.type_id);
					
					if (chore != nil) {
						if (chore.type_id == 1)
							[choreList addObject:chore];
						
						else
							[rewardList addObject:chore];
					}
				}
				
				_chores = [choreList retain];
				_rewards = [rewardList retain];
				
				if (_isRewardList)
					_activeDisplay = [_rewards retain];
				
				else
					_activeDisplay = [_chores retain];
				
				if ([_activeDisplay count] > 0) {
					[_emptyScrollView removeFromSuperview];
					[_holderView addSubview:_myChoresTableView];
					[_holderView addSubview:_myRewardsTableView];
				}
				[_myChoresTableView reloadData];
				[_myRewardsTableView reloadData];
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
				_pts2Label.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle];
				
				[UIView animateWithDuration:0.33 animations:^(void) {
					CGRect pts1Frame = _pts1Label.frame;
					pts1Frame.origin.y = -33;
					_pts1Label.frame = pts1Frame;
					
					CGRect pts2Frame = _pts2Label.frame;
					pts2Frame.origin.y = 0;
					_pts2Label.frame = pts2Frame;
					
				} completion:^(BOOL finished) {
					_pts1Label.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle];
					CGRect pts1Frame = _pts1Label.frame;
					pts1Frame.origin.y = 0;
					_pts1Label.frame = pts1Frame;
					
					CGRect pts2Frame = _pts2Label.frame;
					pts2Frame.origin.y = 33;
					_pts2Label.frame = pts2Frame;
				}];
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
				[_ptsButton setTitle:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle] forState:UIControlStateNormal];
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

	if (request == _activeChoresRequest) {
		//[_delegates perform:@selector(jobList:didFailLoadWithError:) withObject:self withObject:request.error];
		//MBL_RELEASE_SAFELY(_jobListRequest);
	}
	
	[_loadOverlay remove];
}

@end
