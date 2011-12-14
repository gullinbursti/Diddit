//
//  DIAchievementsViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIAchievementsViewController.h"

#import "DIMyChoresViewCell.h"

@implementation DIAchievementsViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		_chores = [[NSMutableArray alloc] init];
		
		UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 39)] autorelease];
		//headerLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:18.0];
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor];
		headerLabel.textColor = [UIColor whiteColor];
		headerLabel.shadowColor = [UIColor colorWithWhite:0.25 alpha:1.0];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		headerLabel.text = @"My Achivements";
		[headerLabel sizeToFit];
		self.navigationItem.titleView = headerLabel;
	}
	
	return (self);
}


-(id)initWithChores:(NSMutableArray *)chores {
	if ((self = [self init])) {
		_chores = chores;
	}
	
	return (self);
}


- (void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor colorWithWhite:0.75 alpha:1.0]];
	
	if ([_chores count] == 0) {
		UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 22, 260, 20)];
		//emptyLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12];
		emptyLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
		emptyLabel.backgroundColor = [UIColor clearColor];
		emptyLabel.textAlignment = UITextAlignmentCenter;
		emptyLabel.text = @"No achievements yet!";
		[self.view addSubview:emptyLabel];
	
	} else {
		_achievementTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
		_achievementTable.rowHeight = 54;
		_achievementTable.delegate = self;
		_achievementTable.dataSource = self;
		_achievementTable.layer.borderColor = [[UIColor colorWithWhite:0.75 alpha:1.0] CGColor];
		_achievementTable.layer.borderWidth = 1.0;
		[self.view addSubview:_achievementTable];
	}
}


- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)dealloc {
	[super dealloc];
}


#pragma mark - TableView Data Source Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([_chores count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DIMyChoresViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIMyChoresViewCell cellReuseIdentifier]];
		
	if (cell == nil)
		cell = [[[DIMyChoresViewCell alloc] init] autorelease];
		
	cell.chore = [_chores objectAtIndex:indexPath.row];
	cell.shouldDrawSeparator = (indexPath.row == ([_chores count] - 1));
		
	return cell;
}

#pragma mark - TableView Delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
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
@end
