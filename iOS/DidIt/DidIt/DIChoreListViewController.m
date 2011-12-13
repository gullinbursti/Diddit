//
//  DIChoreListViewController.m
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIChoreListViewController.h"

#import "DIAddChoreViewController.h"
#import "DISettingsViewController.h"
#import "DIMyChoresViewCell.h"

@implementation DIChoreListViewController

#pragma mark - View lifecycle

-(id)init {
	if ((self = [super init])) {
		
		_chores = [[NSMutableArray alloc] init];
		
		_headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 39)];
		_headerLabel.textAlignment = UITextAlignmentCenter;
		_headerLabel.backgroundColor = [UIColor clearColor];
		_headerLabel.textColor = [UIColor whiteColor];
		_headerLabel.shadowColor = [UIColor colorWithWhite:0.25 alpha:1.0];
		_headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		_headerLabel.text = @"My Chores";
		[_headerLabel sizeToFit];
		self.navigationItem.titleView = _headerLabel;
		
		
		UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		backButton.frame = CGRectMake(0, 0, 60.0, 30);
		[backButton setBackgroundImage:[[UIImage imageNamed:@"non_Active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateNormal];
		[backButton setBackgroundImage:[[UIImage imageNamed:@"active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateHighlighted];
		backButton.titleEdgeInsets = UIEdgeInsetsMake(-1.0, 1.0, 1.0, -1.0);
		//backButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
		[backButton setTitle:@"" forState:UIControlStateNormal];
		//[backButton addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
		
		
		UIButton *allowanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
		allowanceButton.frame = CGRectMake(0, 0, 60.0, 30);
		[allowanceButton setBackgroundImage:[[UIImage imageNamed:@"non_Active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateNormal];
		[allowanceButton setBackgroundImage:[[UIImage imageNamed:@"active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateHighlighted];
		allowanceButton.titleEdgeInsets = UIEdgeInsetsMake(-1.0, 1.0, 1.0, -1.0);
		//allowanceButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
		[allowanceButton setTitle:@"$$" forState:UIControlStateNormal];
		//[allowanceButton addTarget:self action:@selector(_goShare) forControlEvents:UIControlEventTouchUpInside];
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
	
	if ([_chores count] == 0) {
		UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 22, 260, 20)];
		//emptyLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12];
		emptyLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
		emptyLabel.backgroundColor = [UIColor clearColor];
		emptyLabel.textAlignment = UITextAlignmentCenter;
		emptyLabel.text = @"You don't have any chores yet!";
		[self.view addSubview:emptyLabel];
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
	
	
	_activeChoresButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_activeChoresButton.frame = CGRectMake(32, 16.0, 128, 32);
	//_activeChoresButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
	_activeChoresButton.titleEdgeInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
	[_activeChoresButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButton.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[_activeChoresButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButtonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:7] forState:UIControlStateHighlighted];
	[_activeChoresButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_activeChoresButton setTitle:@"Active" forState:UIControlStateNormal];
	[_activeChoresButton addTarget:self action:@selector(_goActiveChores) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_activeChoresButton];
	
	_takenChoresButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_takenChoresButton.frame = CGRectMake(160, 16.0, 128, 32);
	//_takenChoresButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
	_takenChoresButton.titleEdgeInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
	[_takenChoresButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButton.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[_takenChoresButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButtonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:7] forState:UIControlStateHighlighted];
	[_takenChoresButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_takenChoresButton setTitle:@"Completed" forState:UIControlStateNormal];
	[_takenChoresButton addTarget:self action:@selector(_goTakenChores) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_takenChoresButton];
	
	
	_myChoresTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 64, 300, 270) style:UITableViewStylePlain];
	_myChoresTableView.rowHeight = 54;
	_myChoresTableView.delegate = self;
	_myChoresTableView.dataSource = self;
	
	_myChoresTableView.layer.borderColor = [[UIColor colorWithWhite:0.75 alpha:1.0] CGColor];
	_myChoresTableView.layer.borderWidth = 1.0;
	
	[self.view addSubview:_myChoresTableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



-(void)_goActiveChores {
	
}

-(void)_goTakenChores {
	
}


-(void)_goSettings {
	[self.navigationController pushViewController:[[[DISettingsViewController alloc] init] autorelease] animated:YES];
}

-(void)_goAddChore {
	
	DIAddChoreViewController *addChoreViewController = [[[DIAddChoreViewController alloc] init] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:addChoreViewController] autorelease];
	[self.navigationController presentModalViewController:navigationController animated:YES];
	
	
	//[self.navigationController pushViewController:[[[DIAddChoreViewController alloc] init] autorelease] animated:YES];
}

-(void)_goMyChores {
	
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return ([_chores count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	/*
	UITableViewCell *cell = nil;
	
	cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
		
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = @"Notifications";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
				
			case 1:
				cell.textLabel.text = @"Email Alerts";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
				
			case 2:
				cell.textLabel.text = @"Sign Out";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
				
			case 3:
				cell.textLabel.text = @"Need Help";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
				
			case 4:
				cell.textLabel.text = @"About Odd Job";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
		}
		
		
		UIImageView *chevronView = [[UIImageView alloc] initWithFrame:CGRectMake(280.0, 23.0, 7, 10)];		
		chevronView.image = [UIImage imageNamed:@"smallChevron.png"];
		[cell addSubview:chevronView];
	}
	*/
	
	DIMyChoresViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIMyChoresViewCell cellReuseIdentifier]];
	if (cell == nil)
		cell = [[[DIMyChoresViewCell alloc] init] autorelease];
	
	cell.chore = [_chores objectAtIndex:indexPath.row];
	cell.shouldDrawSeparator = (indexPath.row == ([_chores count] - 1));
	
	return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Navigation logic may go here. Create and push another view controller.
	
	//	OJCheckinViewController *checkinJobController = [[[OJCheckinViewController alloc] initWithJob:[_jobs objectAtIndex:indexPath.row] fromMyJobs:YES] autorelease];
	//	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:checkinJobController] autorelease];
	//	[self.navigationController presentModalViewController:navigationController animated:YES];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 55;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	//	cell.textLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12.0];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
}


-(void)dealloc {
	[super dealloc];
}

@end
