//
//  DIChoreListViewController.m
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIChoreListViewController.h"

#import "DIAppDelegate.h"
#import "DIChoreStatsView.h"
#import "DIChoreDetailsViewController.h"
#import "DIAddChoreViewController.h"
#import "DIChoreCompleteViewController.h"
#import "DIAppListViewController.h"
#import "DIAppDetailsViewController.h"
#import "DIOfferListViewController.h"
#import "DIOfferDetailsViewController.h"
#import "DISettingsViewController.h"
#import "DIMyChoresViewCell.h"
#import "DISponsorshipItemButton.h"
#import "DISponsorship.h"

#import "MBProgressHUD.h"

@implementation DIChoreListViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadData:) name:@"DISMISS_WELCOME_SCREEN" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadData:) name:@"REFRESH_CHORE_LIST" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_addChore:) name:@"ADD_CHORE" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_finishChore:) name:@"FINISH_CHORE" object:nil];
		
		_chores = [[NSMutableArray alloc] init];
		_finishedChores = [[NSMutableArray alloc] init];
		_sponsorships = [[NSMutableArray alloc] init];
		
		_choreStatsView = [[[DIChoreStatsView alloc] initWithFrame:CGRectMake(15, -19, 215, 34)] autorelease];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_choreStatsView] autorelease];
		
		
		UIButton *offersBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		offersBtn.frame = CGRectMake(-4.0, 3.0, 84.0, 34.0);
		[offersBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
		[offersBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
		offersBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		offersBtn.titleLabel.shadowColor = [UIColor blackColor];
		offersBtn.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		[offersBtn setTitle:@"Earn Didds" forState:UIControlStateNormal];
		[offersBtn addTarget:self action:@selector(_goOffers) forControlEvents:UIControlEventTouchUpInside];
		
		UIView *rtBtnView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 84.0, 34.0)] autorelease];
		[rtBtnView addSubview:offersBtn];
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rtBtnView] autorelease];
		
		_loadOverlay = [[DILoadOverlay alloc] init];
		_activeChoresRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
		[_activeChoresRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
		[_activeChoresRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
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
	
	
	_sponsorshipHolderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 130.0)];
	_sponsorshipHolderView.backgroundColor = [UIColor clearColor];
	_sponsorshipHolderView.layer.cornerRadius = 8.0;
	_sponsorshipHolderView.clipsToBounds = YES;
	_sponsorshipHolderView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
	_sponsorshipHolderView.layer.borderWidth = 0.0;
	
	_sponsorshipsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 15.0, 320.0, 120.0)];
	_sponsorshipsScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_sponsorshipsScrollView.delegate = self;
	_sponsorshipsScrollView.opaque = NO;
	_sponsorshipsScrollView.scrollsToTop = NO;
	_sponsorshipsScrollView.pagingEnabled = YES;
	_sponsorshipsScrollView.showsHorizontalScrollIndicator = NO;
	_sponsorshipsScrollView.showsVerticalScrollIndicator = NO;
	_sponsorshipsScrollView.alwaysBounceVertical = NO;
	[_sponsorshipHolderView addSubview:_sponsorshipsScrollView];
	
	_myChoresTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_myChoresTableView.rowHeight = 80;
	_myChoresTableView.backgroundColor = [UIColor clearColor];
	_myChoresTableView.separatorColor = [UIColor clearColor];
	_myChoresTableView.dataSource = self;
	_myChoresTableView.delegate = self;
	_myChoresTableView.layer.borderColor = [[UIColor clearColor] CGColor];
	_myChoresTableView.layer.borderWidth = 1.0;
	//[self.view addSubview:_myChoresTableView];
	//_myChoresTableView.hidden = YES;
	
	_emptyListImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emptyChoreListBG.jpg"]];
	frame = _emptyListImgView.frame;
	frame.origin.x = 0.0;
	frame.origin.y = -45.0;
	_emptyListImgView.frame = frame;
	[_emptyScrollView addSubview:_emptyListImgView];
	
	NSString *footerResource;
	
	if ([DIAppDelegate isParentApp])
		footerResource = @"footer_adult.png";
	
	else
		footerResource = @"footer_child.png";
	
	_footerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:footerResource]];
	frame = _footerImgView.frame;
	frame.origin.y = 420 - (frame.size.height + 4);
	_footerImgView.frame = frame;
	[self.view addSubview:_footerImgView];
	[footerResource release];
	
	_badgesImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noticationBG.png"]];
	//frame = _badgesImgView.frame;
	//frame.origin.x = 20;
	//frame.origin.y = -10;
	_badgesImgView.frame = frame;
	[_footerImgView addSubview:_badgesImgView];
	
		
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
	
	NSString *buttonResource;
	
	if ([DIAppDelegate isParentApp])
		buttonResource = @"devicesIcons";
	
	else
		buttonResource = @"rewardsIcon";
	
	UIButton *leftBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain]; 
	leftBtn.frame = CGRectMake(15, 357, 79, 54);
	[leftBtn setBackgroundImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_nonActive.png", buttonResource]] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[leftBtn setBackgroundImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_Active.png", buttonResource]] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	
	if ([DIAppDelegate isParentApp])
		[leftBtn addTarget:self action:@selector(_goDevices) forControlEvents:UIControlEventTouchUpInside];
	else
		[leftBtn addTarget:self action:@selector(_goApps) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:leftBtn];
	
	UIButton *settingsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	settingsButton.frame = CGRectMake(220, 357, 79, 54);
	[settingsButton setBackgroundImage:[[UIImage imageNamed:@"settingsIcon_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[settingsButton setBackgroundImage:[[UIImage imageNamed:@"settingsIcon_active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[settingsButton addTarget:self action:@selector(_goSettings) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:settingsButton];
	
	
	if ([DIAppDelegate isParentApp]) {	
		UIButton *addChoreButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		addChoreButton.frame = CGRectMake(131, 333.0, 56, 56);
		addChoreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
		[addChoreButton setBackgroundImage:[[UIImage imageNamed:@"addButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[addChoreButton setBackgroundImage:[[UIImage imageNamed:@"addButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		[addChoreButton addTarget:self action:@selector(_goFooterAnimation) forControlEvents:UIControlEventTouchDown];
		[addChoreButton addTarget:self action:@selector(_goAddChore) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:addChoreButton];
		
		UILabel *addLabel = [[[UILabel alloc] initWithFrame:CGRectMake(129, 384, 70, 26)] autorelease];
		addLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:11];
		addLabel.textColor = [UIColor colorWithRed:0.243 green:0.259 blue:0.247 alpha:1.0];
		addLabel.backgroundColor = [UIColor clearColor];
		addLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		addLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		addLabel.text = @"ADD CHORE";
		[self.view addSubview:addLabel];
	
	} else {
		UIButton *achievementsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		achievementsButton.frame = CGRectMake(120, 357, 79, 54);
		[achievementsButton setBackgroundImage:[[UIImage imageNamed:@"achivementsIcon_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[achievementsButton setBackgroundImage:[[UIImage imageNamed:@"achivementsIcon_active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		[achievementsButton addTarget:self action:@selector(_goAchievements) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:achievementsButton];
	}
	
	
	
	
	
	_addBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_addBtn.frame = CGRectMake(100, 30, 115, 28);
	_addBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
	[_addBtn setBackgroundImage:[[UIImage imageNamed:@"genericButton_nonActive.png"] stretchableImageWithLeftCapWidth:17 topCapHeight:0] forState:UIControlStateNormal];
	[_addBtn setBackgroundImage:[[UIImage imageNamed:@"genericButton_Active.png"] stretchableImageWithLeftCapWidth:17 topCapHeight:0] forState:UIControlStateHighlighted];
	[_addBtn setTitleColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateNormal];
	[_addBtn setTitle:@"Add more chores" forState:UIControlStateNormal];
	[_addBtn addTarget:self action:@selector(_goAddChore) forControlEvents:UIControlEventTouchUpInside];
	_addBtn.hidden = [_chores count] < 2;
}

-(void)viewDidUnload {
    [super viewDidUnload];
}


-(void)dealloc {
	[_activeChoresRequest release];
	[_loadOverlay release];
	[_myChoresTableView release];
	[_chores release];
	[_finishedChores release];
	[_emptyListImgView release];
	[_footerImgView release];
	[_addBtn release];
	
	[super dealloc];
}

#pragma mark - Button Handlers
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

-(void)_goAddChore {
	
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
	
	DIAddChoreViewController *addChoreViewController = [[[DIAddChoreViewController alloc] init] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:addChoreViewController] autorelease];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}

-(void)_goDevices {
	NSLog(@"%@", [[DIAppDelegate childDevices] objectAtIndex:0]);
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
	[_activeChoresRequest setDelegate:self];
	[_activeChoresRequest startAsynchronous];
	
	UILabel *appTypeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 300, 320, 26)] autorelease];
	appTypeLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:14];
	appTypeLabel.textColor = [UIColor colorWithRed:0.243 green:0.259 blue:0.247 alpha:1.0];
	appTypeLabel.backgroundColor = [UIColor clearColor];
	appTypeLabel.textAlignment = UITextAlignmentCenter;
	appTypeLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	appTypeLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	
	//_achievementsRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Achievements.php"]] retain];
	//[_achievementsRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
	//[_achievementsRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	//[_achievementsRequest setDelegate:self];
	//[_achievementsRequest startAsynchronous];
}

-(void)_addChore:(NSNotification *)notification {
	[_chores insertObject:(DIChore *)[notification object] atIndex:0];
	
	NSLog(@"ChoreListViewController - addChore:[]");
	
	[_emptyScrollView removeFromSuperview];
	[_holderView addSubview:_myChoresTableView];
	
	//_emptyListImgView.hidden = YES;
	//_myChoresTableView.hidden = NO;
	[_myChoresTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
	//NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
	//[_myChoresTableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
	[_myChoresTableView reloadData];	
	_addBtn.hidden = [_chores count] >= 2;
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
	
	[_chores removeObjectIdenticalTo:chore];
	
	
	[_myChoresTableView reloadData];
	_addBtn.hidden = [_chores count] >= 2;
	
	if ([_chores count] == 0) {
		[_myChoresTableView removeFromSuperview];
		[_holderView addSubview:_emptyScrollView];
		
		//_emptyListImgView.hidden = NO;
		//_myChoresTableView.hidden = YES;
	}

	//[_myChoresTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
	
	
	//DIChoreCompleteViewController *choreCompleteViewController = [[[DIChoreCompleteViewController alloc] initWithChore:chore] autorelease];
	//UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:choreCompleteViewController] autorelease];
	//[self.navigationController presentModalViewController:navigationController animated:YES];
}

#pragma mark - ScrollView Delegates
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	int page = _sponsorshipsScrollView.contentOffset.x / 154;
	
	[_paginationView updToPage:page];
	NSLog(@"SCROLL PAGE:[(%f) %d]", _sponsorshipsScrollView.contentOffset.x, page);
}


#pragma mark - TableView Data Source Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([_chores count] + 1);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) {
		UITableViewCell *cell = nil;
		cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
		
		if (cell == nil) {			
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
			[cell addSubview:_sponsorshipHolderView];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
		
		return (cell);
		
	} else if (indexPath.row < [_chores count]) {
		DIMyChoresViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIMyChoresViewCell cellReuseIdentifier]];
		
		if (cell == nil)
			cell = [[[DIMyChoresViewCell alloc] init] autorelease];
		
		cell.chore = [_chores objectAtIndex:indexPath.row - 1];
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
	
	if (indexPath.row > [_chores count])
		return;
	
	if (indexPath.row == 0) {
		
		if (((DISponsorship *)[_sponsorships objectAtIndex:0]).type_id == 1)
			[self.navigationController pushViewController:[[[DIOfferDetailsViewController alloc] initWithOffer:((DISponsorship *)[_sponsorships objectAtIndex:0]).offer] autorelease] animated:YES];	
		
		else
			[self.navigationController pushViewController:[[[DIAppDetailsViewController alloc] initWithApp:((DISponsorship *)[_sponsorships objectAtIndex:0]).app] autorelease] animated:YES];	
		
	} else {
		DIMyChoresViewCell *cell = (DIMyChoresViewCell *)[tableView cellForRowAtIndexPath:indexPath];
		[cell toggleSelected];
		[self.navigationController pushViewController:[[[DIChoreDetailsViewController alloc] initWithChore:[_chores objectAtIndex:indexPath.row - 1]] autorelease] animated:YES];	
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
	
	if (indexPath.row == 0)
		return (130);
	
	if (indexPath.row <= [_chores count])
		return (80);
	
	else
		return (100);
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
			NSArray *parsedChores = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			if (error != nil) {
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			} else {
				NSMutableArray *choreList = [NSMutableArray array];
				
				for (NSDictionary *serverChore in parsedChores) {
					DIChore *chore = [DIChore choreWithDictionary:serverChore];
					
					NSLog(@"CHORE \"%@\" (%@)", chore.title, chore.expires);
					
					if (chore != nil)
						[choreList addObject:chore];
				}
				
				_chores = [choreList retain];
				//[_myChoresTableView reloadData];
				
				if ([_chores count] > 0) {
					[_emptyScrollView removeFromSuperview];
					[_holderView addSubview:_myChoresTableView];
					
					//_myChoresTableView.hidden = NO;
					//_emptyListImgView.hidden = YES;
				}
				
				//[choreList sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO]]];
			}
			
			_sponsorshipsDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Sponsorships.php"]] retain];
			[_sponsorshipsDataRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
			[_sponsorshipsDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
			[_sponsorshipsDataRequest setDelegate:self];
			[_sponsorshipsDataRequest startAsynchronous];
		}
	
	} else if ([request isEqual:_sponsorshipsDataRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			NSArray *parsedSponsorships = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			if (error != nil) {
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			} else {
				NSMutableArray *sponsorshipList = [NSMutableArray array];
				
				int ind = 0;
				for (NSDictionary *serverSponsorship in parsedSponsorships) {
					DISponsorship *sponsorship = [DISponsorship sponsorshipWithDictionary:serverSponsorship];
					
					DISponsorshipItemButton *sponsorshipButton = [[[DISponsorshipItemButton alloc] initWithSponsorship:sponsorship AtIndex:ind] autorelease];
					CGRect frame = sponsorshipButton.frame;
					frame.origin.x = 10 + (ind * 154);
					sponsorshipButton.frame = frame;
					[_sponsorshipsScrollView addSubview:sponsorshipButton];
					
					if (sponsorship != nil)
						[sponsorshipList addObject:sponsorship];
					
					ind++;
				}
				
				_sponsorships = [sponsorshipList retain];
				[_myChoresTableView reloadData];
				_paginationView = [[DIPaginationView alloc] initWithTotal:[_sponsorships count] / 2 coords:CGPointMake(160, 120)];
				_sponsorshipsScrollView.contentSize = CGSizeMake([_sponsorships count] * 154, 120.0);
				[_sponsorshipHolderView addSubview:_paginationView];
				
				[_emptyScrollView removeFromSuperview];
				[_holderView addSubview:_myChoresTableView];
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
				[[_choreStatsView ptsBtn] setTitle:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle] forState:UIControlStateNormal];
				[[_choreStatsView totBtn] setTitle:[NSString stringWithFormat:@"%d", [DIAppDelegate userTotalFinished]] forState:UIControlStateNormal];
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
				[[_choreStatsView ptsBtn] setTitle:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle] forState:UIControlStateNormal];
				[[_choreStatsView totBtn] setTitle:[NSString stringWithFormat:@"%d", [DIAppDelegate userTotalFinished]] forState:UIControlStateNormal];
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
