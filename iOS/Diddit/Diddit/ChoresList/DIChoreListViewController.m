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
#import "DICreditsViewController.h"
#import "DISettingsViewController.h"
#import "DIMyChoresViewCell.h"

@implementation DIChoreListViewController

#pragma mark - View lifecycle

-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadData:) name:@"DISMISS_WELCOME_SCREEN" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_addChore:) name:@"ADD_CHORE" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_finishChore:) name:@"FINISH_CHORE" object:nil];
		
		_chores = [[NSMutableArray alloc] init];
		_availChores = [[NSMutableArray alloc] init];
		_finishedChores = [[NSMutableArray alloc] init];
		_achievements = [[NSMutableArray alloc] init];
		_myPoints = [DIAppDelegate userPoints];
		
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
		
		
		//NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_choreTypes" ofType:@"plist"]] options:NSPropertyListImmutable format:nil error:nil];
		//for (NSDictionary *dict in plist)
		//	[_availChores addObject:[DIChore choreWithDictionary:dict]];
		
		/*
		_headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 39)];
		_headerLabel.textAlignment = UITextAlignmentCenter;
		_headerLabel.backgroundColor = [UIColor clearColor];
		_headerLabel.textColor = [UIColor whiteColor];
		_headerLabel.shadowColor = [UIColor colorWithWhite:0.25 alpha:1.0];
		_headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		_headerLabel.text = @"My Chores";
		[_headerLabel sizeToFit];
		self.navigationItem.titleView = _headerLabel;
		*/
		
		UIButton *offersButton = [UIButton buttonWithType:UIButtonTypeCustom];
		offersButton.frame = CGRectMake(0, 0, 84.0, 34);
		[offersButton setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[offersButton setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		offersButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		offersButton.titleLabel.shadowColor = [UIColor blackColor];
		offersButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		[offersButton setTitle:@"Earn Didds" forState:UIControlStateNormal];
		[offersButton addTarget:self action:@selector(_goOffers) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:offersButton] autorelease];
	}
	
	return (self);
}
	
- (void)viewDidAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
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
	//_emptyLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12];
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
	appBtn.frame = CGRectMake(32, 375, 34, 34);
	appBtn.titleEdgeInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
	[appBtn setBackgroundImage:[[UIImage imageNamed:@"appStoreIcon.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[appBtn setBackgroundImage:[[UIImage imageNamed:@"appStoreIcon.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[appBtn addTarget:self action:@selector(_goApps) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:appBtn];
	
	_settingsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_settingsButton.frame = CGRectMake(240, 385, 44, 14);
	_settingsButton.titleEdgeInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
	[_settingsButton setBackgroundImage:[[UIImage imageNamed:@"optionsIcon.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[_settingsButton setBackgroundImage:[[UIImage imageNamed:@"optionsIcon.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[_settingsButton addTarget:self action:@selector(_goSettings) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_settingsButton];
	
	_addChoreButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_addChoreButton.frame = CGRectMake(138, 350.0, 44, 44);
	_addChoreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	[_addChoreButton setBackgroundImage:[[UIImage imageNamed:@"addButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[_addChoreButton setBackgroundImage:[[UIImage imageNamed:@"addButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[_addChoreButton addTarget:self action:@selector(_goAddChore) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_addChoreButton];
	
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

- (void)viewDidUnload {
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
	NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_chores" ofType:@"plist"]] options:NSPropertyListImmutable format:nil error:nil];
	
	NSMutableArray *chores = [[NSMutableArray alloc] init];
	for (NSDictionary *dict in plist)
		[chores addObject:[DIChore choreWithDictionary:dict]];
	
	[self.navigationController pushViewController:[[[DICreditsViewController alloc] initWithPoints:_myPoints] autorelease] animated:YES];
}

-(void)_goOffers {
	NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_chores" ofType:@"plist"]] options:NSPropertyListImmutable format:nil error:nil];
	
	NSMutableArray *chores = [[NSMutableArray alloc] init];
	for (NSDictionary *dict in plist)
		[chores addObject:[DIChore choreWithDictionary:dict]];
	
	[self.navigationController pushViewController:[[[DICreditsViewController alloc] initWithPoints:_myPoints] autorelease] animated:YES];
}


#pragma mark - Notification Handlers
-(void)_loadData:(NSNotification *)notification {
	_myPoints = [DIAppDelegate userPoints];
	
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
	
	_myPoints += (chore.cost * 100);
	[DIAppDelegate setUserPoints:_myPoints];
	
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

#pragma mark - TableView Data Source Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([_chores count] + 2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[self.navigationController pushViewController:[[[DIChoreDetailsViewController alloc] initWithChore:[_chores objectAtIndex:indexPath.row]] autorelease] animated:YES];	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < [_chores count])
		return (95);
	
	else
		return (100);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
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
	if (request == _availChoresRequest) {
		//[_delegates perform:@selector(jobList:didFailLoadWithError:) withObject:self withObject:request.error];
		//MBL_RELEASE_SAFELY(_jobListRequest);
	}
}

@end
