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
#import "DISponsorship.h"

#import "MBProgressHUD.h"

@implementation DIChoreListViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadData:) name:@"DISMISS_WELCOME_SCREEN" object:nil];
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
	_emptyScrollView.showsVerticalScrollIndicator = YES;
	_emptyScrollView.alwaysBounceVertical = NO;
	
	_holderView = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
	frame = _holderView.frame;
	frame.origin.y = 5.0;
	_holderView.frame = frame;
	[self.view addSubview:_holderView];
	[_holderView addSubview:_emptyScrollView];
	
	_sponsorshipImgView = [[EGOImageView alloc] initWithFrame:CGRectMake(10.0, 15.0, 300.0, 80.0)];
	_sponsorshipImgView.backgroundColor = [UIColor colorWithRed:0.98034 green:0.9922 blue:0.7843 alpha:1.0];
	_sponsorshipImgView.layer.cornerRadius = 8.0;
	_sponsorshipImgView.clipsToBounds = YES;
	_sponsorshipImgView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
	_sponsorshipImgView.layer.borderWidth = 1.0;
	
	_myChoresTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_myChoresTableView.rowHeight = 80;
	_myChoresTableView.backgroundColor = [UIColor clearColor];
	_myChoresTableView.separatorColor = [UIColor clearColor];
	_myChoresTableView.delegate = self;
	_myChoresTableView.dataSource = self;
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
	
	_footerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choreFooterBG_001.png"]];
	frame = _footerImgView.frame;
	frame.origin.y = 420 - (frame.size.height + 4);
	_footerImgView.frame = frame;
	[self.view addSubview:_footerImgView];
	
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
	
	UIButton *appBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain]; 
	appBtn.frame = CGRectMake(15, 357, 79, 54);
	[appBtn setBackgroundImage:[[UIImage imageNamed:@"appStoreIcon_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[appBtn setBackgroundImage:[[UIImage imageNamed:@"appStoreIcon_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[appBtn addTarget:self action:@selector(_goApps) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:appBtn];
	
	UIButton *settingsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	settingsButton.frame = CGRectMake(220, 357, 79, 54);
	[settingsButton setBackgroundImage:[[UIImage imageNamed:@"settingsIcon_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[settingsButton setBackgroundImage:[[UIImage imageNamed:@"settingsIcon_active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[settingsButton addTarget:self action:@selector(_goSettings) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:settingsButton];
	
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

-(void)_goApps {
	[self.navigationController pushViewController:[[[DIAppListViewController alloc] init] autorelease] animated:YES];
}

-(void)_goOffers {
	[self.navigationController pushViewController:[[[DIOfferListViewController alloc] init] autorelease] animated:YES];
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
	
	if ([[[DIAppDelegate profileForUser] objectForKey:@"app_type"] isEqualToString:@"master"])
		appTypeLabel.text = @"PARENT";
	
	else
		appTypeLabel.text = @"CHILD";
	[self.view addSubview:appTypeLabel];
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


#pragma mark - TableView Data Source Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([_chores count] + 1 + [_sponsorships count]);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) {
		UITableViewCell *cell = nil;
		cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
		
		if (cell == nil) {			
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
			[cell addSubview:_sponsorshipImgView];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
		
		return (cell);
		
	} else if (indexPath.row < [_chores count]) {
		DIMyChoresViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIMyChoresViewCell cellReuseIdentifier]];
		
		if (cell == nil)
			cell = [[[DIMyChoresViewCell alloc] init] autorelease];
		
		cell.chore = [_chores objectAtIndex:indexPath.row - [_sponsorships count]];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		return (cell);
	
	} else if (indexPath.row == [_chores count]) {
		UITableViewCell *cell = nil;
		cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
		
		if (cell == nil) {			
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
			[cell addSubview:_addBtn];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
		
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
	
	if (indexPath.row >= [_chores count])
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
		return (91);
	
	else if (indexPath.row < [_chores count])
		return (96);
	
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
				[_myChoresTableView reloadData];
				
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
				
				for (NSDictionary *serverSponsorship in parsedSponsorships) {
					DISponsorship *sponsorship = [DISponsorship sponsorshipWithDictionary:serverSponsorship];
					_sponsorshipImgView.imageURL = [NSURL URLWithString:sponsorship.img_url];
					
					NSLog(@"SPONSORSHIP \"%@\"", sponsorship.offer.title);
					
					if (sponsorship != nil)
						[sponsorshipList addObject:sponsorship];
				}
				
				_sponsorships = [sponsorshipList retain];
				[_myChoresTableView reloadData];
				
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
