//
//  DIChoreListViewController.m
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIChoreListViewController.h"

#import "DIChoreDetailsViewController.h"
#import "DIAddChoreViewController.h"
#import "DICreditsViewController.h"
#import "DISettingsViewController.h"
#import "DIAchievementsViewController.h"
#import "DIMyChoresViewCell.h"

@implementation DIChoreListViewController

#pragma mark - View lifecycle

-(id)init {
	if ((self = [super init])) {
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_addChore:) name:@"ADD_CHORE" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_removeAvailChore:) name:@"REMOVE_AVAIL_CHORE" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_finishChore:) name:@"FINISH_CHORE" object:nil];
		
		_chores = [[NSMutableArray alloc] init];
		_availChores = [[NSMutableArray alloc] init];
		_finishedChores = [[NSMutableArray alloc] init];
		
		NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_choreTypes" ofType:@"plist"]] options:NSPropertyListImmutable format:nil error:nil];
		for (NSDictionary *dict in plist)
			[_availChores addObject:[DIChore choreWithDictionary:dict]];
		
		_headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 39)];
		_headerLabel.textAlignment = UITextAlignmentCenter;
		_headerLabel.backgroundColor = [UIColor clearColor];
		_headerLabel.textColor = [UIColor whiteColor];
		_headerLabel.shadowColor = [UIColor colorWithWhite:0.25 alpha:1.0];
		_headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		_headerLabel.text = @"My Chores";
		[_headerLabel sizeToFit];
		self.navigationItem.titleView = _headerLabel;
		
		
		UIButton *achievementsButton = [UIButton buttonWithType:UIButtonTypeCustom];
		achievementsButton.frame = CGRectMake(0, 0, 60.0, 30);
		[achievementsButton setBackgroundImage:[[UIImage imageNamed:@"non_Active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateNormal];
		[achievementsButton setBackgroundImage:[[UIImage imageNamed:@"active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateHighlighted];
		achievementsButton.titleEdgeInsets = UIEdgeInsetsMake(-1.0, 1.0, 1.0, -1.0);
		//achievementsButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
		[achievementsButton setTitle:@"Achievements" forState:UIControlStateNormal];
		[achievementsButton addTarget:self action:@selector(_goAchievements) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:achievementsButton] autorelease];
		
		
		UIButton *allowanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
		allowanceButton.frame = CGRectMake(0, 0, 60.0, 30);
		[allowanceButton setBackgroundImage:[[UIImage imageNamed:@"non_Active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateNormal];
		[allowanceButton setBackgroundImage:[[UIImage imageNamed:@"active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateHighlighted];
		allowanceButton.titleEdgeInsets = UIEdgeInsetsMake(-1.0, 1.0, 1.0, -1.0);
		//allowanceButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
		[allowanceButton setTitle:@"$$" forState:UIControlStateNormal];
		[allowanceButton addTarget:self action:@selector(_goAllowance) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:allowanceButton] autorelease];
	}
	
	return (self);
}


-(id)initWithChores:(NSMutableArray *)chores {
	if ((self = [self init])) {
		_chores = chores;
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
	
	[self.view setBackgroundColor:[UIColor colorWithWhite:0.75 alpha:1.0]];
	
	_myChoresTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_myChoresTableView.rowHeight = 54;
	_myChoresTableView.delegate = self;
	_myChoresTableView.dataSource = self;
	_myChoresTableView.layer.borderColor = [[UIColor colorWithWhite:0.75 alpha:1.0] CGColor];
	_myChoresTableView.layer.borderWidth = 1.0;
	[self.view addSubview:_myChoresTableView];
	_myChoresTableView.hidden = YES;
	
	if ([_chores count] == 0) {
		_emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 22, 260, 20)];
		//_emptyLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12];
		_emptyLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
		_emptyLabel.backgroundColor = [UIColor clearColor];
		_emptyLabel.textAlignment = UITextAlignmentCenter;
		_emptyLabel.text = @"You don't have any chores yet!";
		[self.view addSubview:_emptyLabel];
	
	} else {
		_myChoresTableView.hidden = NO;
	}
	
	_footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 366, 320, 50)];
	_footerView.backgroundColor = [UIColor colorWithWhite:0.33 alpha:1.0];
	_footerView.layer.borderColor = [[UIColor colorWithWhite:0.0 alpha:1.0] CGColor];
	[self.view addSubview:_footerView];
	
	_myChoresButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_myChoresButton.frame = CGRectMake(32, 375, 32, 32);
	//_myChoresButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
	_myChoresButton.titleEdgeInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
	[_myChoresButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButton.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[_myChoresButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButtonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:7] forState:UIControlStateHighlighted];
	[_myChoresButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_myChoresButton setTitle:@"My Chores" forState:UIControlStateNormal];
	[_myChoresButton addTarget:self action:@selector(_goMyChores) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_myChoresButton];
	
	_settingsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_settingsButton.frame = CGRectMake(256, 375, 32, 32);
	//_settingsButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
	_settingsButton.titleEdgeInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
	[_settingsButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButton.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[_settingsButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButtonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:7] forState:UIControlStateHighlighted];
	[_settingsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_settingsButton setTitle:@"*" forState:UIControlStateNormal];
	[_settingsButton addTarget:self action:@selector(_goSettings) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_settingsButton];
	
	_addChoreButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_addChoreButton.frame = CGRectMake(128, 340.0, 64, 64);
	//_activeChoresButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
	_addChoreButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	[_addChoreButton setBackgroundImage:[[UIImage imageNamed:@"non_Active_headerButton.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[_addChoreButton setBackgroundImage:[[UIImage imageNamed:@"active_headerButton.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:7] forState:UIControlStateHighlighted];
	[_addChoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_addChoreButton setTitle:@"+" forState:UIControlStateNormal];
	[_addChoreButton addTarget:self action:@selector(_goAddChore) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_addChoreButton];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


-(void)dealloc {
	[super dealloc];
}



#pragma mark - Button Handlers
-(void)_goAchievements {
	NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_chores" ofType:@"plist"]] options:NSPropertyListImmutable format:nil error:nil];
	
	NSMutableArray *chores = [[NSMutableArray alloc] init];
	for (NSDictionary *dict in plist)
		[chores addObject:[DIChore choreWithDictionary:dict]];
	
	[self.navigationController pushViewController:[[[DIAchievementsViewController alloc] initWithChores:_finishedChores] autorelease] animated:YES];
}

-(void)_goSettings {
	[self.navigationController pushViewController:[[[DISettingsViewController alloc] init] autorelease] animated:YES];
}

-(void)_goAddChore {
	DIAddChoreViewController *addChoreViewController = [[[DIAddChoreViewController alloc] initWithChores:_availChores] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:addChoreViewController] autorelease];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}

-(void)_goMyChores {
	
}

-(void)_goAllowance {
	NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_chores" ofType:@"plist"]] options:NSPropertyListImmutable format:nil error:nil];
	
	NSMutableArray *chores = [[NSMutableArray alloc] init];
	for (NSDictionary *dict in plist)
		[chores addObject:[DIChore choreWithDictionary:dict]];
	
	[self.navigationController pushViewController:[[[DICreditsViewController alloc] initWithPoints:((arc4random() % 10000) + (arc4random() % 5000)) * (int)([_finishedChores count] > 0)] autorelease] animated:YES];
}


#pragma mark - Notification Handlers
-(void)_addChore:(NSNotification *)notification {
	[_chores addObject:(DIChore *)[notification object]];
	
	_emptyLabel.hidden = YES;
	_myChoresTableView.hidden = NO;
	
	//NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[_chores count] - 1 inSection:0]];
	//[_myChoresTableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationAutomatic];
	[_myChoresTableView reloadData];	
}


-(void)_removeAvailChore:(NSNotification *)notification {
	[_availChores removeObjectIdenticalTo:(DIChore *)[notification object]];
}

-(void)_finishChore:(NSNotification *)notification {
	DIChore *chore = (DIChore *)[notification object];
	[_finishedChores addObject:chore];
	
	[_chores removeObjectIdenticalTo:chore];
	[_myChoresTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
	
	[_myChoresTableView reloadData];
}

#pragma mark - TableView Data Source Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([_chores count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//if (indexPath.row < [_chores count] - 1 && [_chores count] > 0) {
		DIMyChoresViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIMyChoresViewCell cellReuseIdentifier]];
		
		if (cell == nil)
			cell = [[[DIMyChoresViewCell alloc] init] autorelease];
		
	cell.chore = [_chores objectAtIndex:indexPath.row];
	cell.shouldDrawSeparator = (indexPath.row == ([_chores count] - 1));
	
		//} else {
		//	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];;
		//	return cell;
		//}
	
	return cell;
}

#pragma mark - TableView Delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[self.navigationController pushViewController:[[[DIChoreDetailsViewController alloc] initWithChore:[_chores objectAtIndex:indexPath.row]] autorelease] animated:YES];	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 55;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	//	cell.textLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12.0];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
}

@end