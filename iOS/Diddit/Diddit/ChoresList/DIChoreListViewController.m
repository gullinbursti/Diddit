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
#import "DIChoreDetailsViewController.h"
#import "DIAddChoreViewController.h"
#import "DIChoreCompleteViewController.h"
#import "DIAppListViewController.h"
#import "DIOfferListViewController.h"
#import "DISettingsViewController.h"
#import "DIMyChoresViewCell.h"

@implementation DIChoreListViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadData:) name:@"DISMISS_WELCOME_SCREEN" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_addChore:) name:@"ADD_CHORE" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_finishChore:) name:@"FINISH_CHORE" object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_pushOffers:) name:@"PUSH_OFFERS_SCREEN" object:nil];
		
		_chores = [[NSMutableArray alloc] init];
		_finishedChores = [[NSMutableArray alloc] init];
		_achievements = [[NSMutableArray alloc] init];
		
		_activeChoresRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
		[_activeChoresRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
		[_activeChoresRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[_activeChoresRequest setDelegate:self];
		[_activeChoresRequest startAsynchronous];
		
		//_achievementsRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Achievements.php"]] retain];
		//[_achievementsRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
		//[_achievementsRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		//[_achievementsRequest setDelegate:self];
		//[_achievementsRequest startAsynchronous];
		
		UIButton *offersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		offersBtn.frame = CGRectMake(-4.0, 3.0, 84.0, 34.0);
		[offersBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
		[offersBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
		offersBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		offersBtn.titleLabel.shadowColor = [UIColor blackColor];
		offersBtn.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		[offersBtn setTitle:@"Earn Didds" forState:UIControlStateNormal];
		[offersBtn addTarget:self action:@selector(_goOffers) forControlEvents:UIControlEventTouchUpInside];
		
		UIView *rtBtnView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 84.0, 34.0)];
		[rtBtnView addSubview:offersBtn];
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rtBtnView] autorelease];
	}
	
	return (self);
}
	
-(void)viewDidAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

-(void)viewDidLoad {
	[super viewDidLoad];
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
	[self.view addSubview:bgImgView];
	
	_myChoresTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_myChoresTableView.rowHeight = 80;
	_myChoresTableView.backgroundColor = [UIColor clearColor];
	_myChoresTableView.separatorColor = [UIColor clearColor];
	_myChoresTableView.delegate = self;
	_myChoresTableView.dataSource = self;
	_myChoresTableView.layer.borderColor = [[UIColor clearColor] CGColor];
	_myChoresTableView.layer.borderWidth = 1.0;
	[self.view addSubview:_myChoresTableView];
	_myChoresTableView.hidden = YES;
	
	_emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 22, 260, 20)];
	_emptyLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:12];
	_emptyLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	_emptyLabel.backgroundColor = [UIColor clearColor];
	_emptyLabel.textAlignment = UITextAlignmentCenter;
	_emptyLabel.text = @"You don't have any chores!";
	[self.view addSubview:_emptyLabel];
	
	CGRect frame;
	UIImageView *footerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hudFooterBG.png"]];
	frame = footerImgView.frame;
	frame.origin.y = 420 - (frame.size.height + 4);
	footerImgView.frame = frame;
	[self.view addSubview:footerImgView];
	
	UIImageView *overlayImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]];
	frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
	
	UIButton *appBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain]; 
	appBtn.frame = CGRectMake(26, 362, 54, 54);
	[appBtn setBackgroundImage:[[UIImage imageNamed:@"appStoreIcon.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[appBtn setBackgroundImage:[[UIImage imageNamed:@"appStoreIcon_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[appBtn addTarget:self action:@selector(_goApps) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:appBtn];
	
	UIButton *settingsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	settingsButton.frame = CGRectMake(235, 363, 54, 54);
	[settingsButton setBackgroundImage:[[UIImage imageNamed:@"optionsIcon.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[settingsButton setBackgroundImage:[[UIImage imageNamed:@"optionsIcon_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[settingsButton addTarget:self action:@selector(_goSettings) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:settingsButton];
	
	UIButton *addChoreButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	addChoreButton.frame = CGRectMake(138, 350.0, 44, 44);
	addChoreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	[addChoreButton setBackgroundImage:[[UIImage imageNamed:@"addButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[addChoreButton setBackgroundImage:[[UIImage imageNamed:@"addButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[addChoreButton addTarget:self action:@selector(_goAddChore) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:addChoreButton];
	
	UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 395, 160, 20)];
	addLabel.font = [UIFont fontWithName:@"Adelle-Bold" size:10]; //[[DIAppDelegate diAdelleFontBold] fontWithSize:12];
	addLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
	addLabel.backgroundColor = [UIColor clearColor];
	addLabel.textAlignment = UITextAlignmentCenter;
	//addLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
	//addLabel.shadowOffset = CGSizeMake(1.0, 1.0);
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
}

-(void)viewDidUnload {
    [super viewDidUnload];
}


-(void)dealloc {
	[super dealloc];
}

#pragma mark - Button Handlers
-(void)_goSettings {
	[self.navigationController pushViewController:[[[DISettingsViewController alloc] init] autorelease] animated:YES];
}

-(void)_goAddChore {
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
	_activeChoresRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
	[_activeChoresRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
	[_activeChoresRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[_activeChoresRequest setDelegate:self];
	[_activeChoresRequest startAsynchronous];
	
	
	//_achievementsRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Achievements.php"]] retain];
	//[_achievementsRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
	//[_achievementsRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	//[_achievementsRequest setDelegate:self];
	//[_achievementsRequest startAsynchronous];
}

-(void)_addChore:(NSNotification *)notification {
	[_chores addObject:(DIChore *)[notification object]];
	
	NSLog(@"ChoreListViewController - addChore:[]");
	
	_emptyLabel.hidden = YES;
	_myChoresTableView.hidden = NO;
	
	//NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[_chores count] - 1 inSection:0]];
	//[_myChoresTableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
	[_myChoresTableView reloadData];	
}


-(void)_finishChore:(NSNotification *)notification {
	DIChore *chore = (DIChore *)[notification object];
	[_finishedChores addObject:chore];
	
	[_chores removeObjectIdenticalTo:chore];
	[_myChoresTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
	
	[_myChoresTableView reloadData];
	
	if ([_chores count] == 0) {
		_emptyLabel.hidden = NO;
		_myChoresTableView.hidden = YES;
	}
	
	DIChoreCompleteViewController *choreCompleteViewController = [[[DIChoreCompleteViewController alloc] initWithChore:chore] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:choreCompleteViewController] autorelease];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}

-(void)_pushOffers:(NSNotification *)notification {
	[self.navigationController pushViewController:[[[DIOfferListViewController alloc] init] autorelease] animated:YES];
}

#pragma mark - TableView Data Source Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([_chores count] + 2);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row < [_chores count]) {
		DIMyChoresViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIMyChoresViewCell cellReuseIdentifier]];
		
		if (cell == nil)
			cell = [[[DIMyChoresViewCell alloc] init] autorelease];
		
		cell.chore = [_chores objectAtIndex:indexPath.row];
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
		
		if (cell == nil)	
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
		
		return (cell);
	}
}

#pragma mark - TableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[self.navigationController pushViewController:[[[DIChoreDetailsViewController alloc] initWithChore:[_chores objectAtIndex:indexPath.row]] autorelease] animated:YES];	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < [_chores count])
		return (95);
	
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
			}
			else {
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
					_myChoresTableView.hidden = NO;
					_emptyLabel.hidden = YES;
				}
				
				//[choreList sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO]]];
			}
		}
	
	} else if ([request isEqual:_achievementsRequest]) {
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
	}
}


-(void)requestFailed:(ASIHTTPRequest *)request {
	if (request == _activeChoresRequest) {
		//[_delegates perform:@selector(jobList:didFailLoadWithError:) withObject:self withObject:request.error];
		//MBL_RELEASE_SAFELY(_jobListRequest);
	}
}

@end
