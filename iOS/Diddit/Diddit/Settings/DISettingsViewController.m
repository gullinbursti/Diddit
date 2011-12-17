//
//  DISettingsViewController.m
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DISettingsViewController.h"

#import "DIAboutViewController.h"
#import "DIEmailSettingsViewController.h"
#import "DIPinSettingsViewController.h"

@implementation DISettingsViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 39)] autorelease];
		//headerLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:18.0];
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor];
		headerLabel.textColor = [UIColor whiteColor];
		headerLabel.shadowColor = [UIColor colorWithWhite:0.25 alpha:1.0];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		headerLabel.text = @"Settings";
		[headerLabel sizeToFit];
		self.navigationItem.titleView = headerLabel;
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]] autorelease];
	[self.view addSubview:bgImgView];
	
	_settingsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_settingsTableView.rowHeight = 54;
	_settingsTableView.delegate = self;
	_settingsTableView.dataSource = self;
	_settingsTableView.layer.borderColor = [[UIColor colorWithWhite:0.75 alpha:1.0] CGColor];
	_settingsTableView.layer.borderWidth = 1.0;
	[self.view addSubview:_settingsTableView];
	
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

-(void)viewDidUnload {
    [super viewDidUnload];
}

-(void)dealloc {
	[super dealloc];
}


#pragma mark - TableView Data Source Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (4);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
		
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = @"Notifications";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
				
			case 1:
				cell.textLabel.text = @"Email Address";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
				
			case 2:
				cell.textLabel.text = @"Pincode";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
				
			case 3:
				cell.textLabel.text = @"About Diddit";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
		}
		
		
		if (indexPath.row == 0) {
			UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
			switchview.on = YES;
			cell.accessoryView = switchview;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			[switchview release];
			
		/*} else {
			UIImageView *chevronView = [[UIImageView alloc] initWithFrame:CGRectMake(280.0, 23.0, 7, 10)];		
			chevronView.image = [UIImage imageNamed:@"smallChevron.png"];
			[cell addSubview:chevronView];*/
		}
	}
	
	return cell;
}

#pragma mark - TableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
	
	UINavigationController *navigationController;
	DIAboutViewController *aboutViewController = [[[DIAboutViewController alloc] init] autorelease];
	DIEmailSettingsViewController *emailViewController = [[[DIEmailSettingsViewController alloc] init] autorelease];
	DIPinSettingsViewController *pinViewController = [[[DIPinSettingsViewController alloc] init] autorelease];
	
	switch (indexPath.row) {
		case 1:
			navigationController = [[[UINavigationController alloc] initWithRootViewController:emailViewController] autorelease];
			break;
			
		case 2:
			navigationController = [[[UINavigationController alloc] initWithRootViewController:pinViewController] autorelease];
			break;
			
		case 3:
			navigationController = [[[UINavigationController alloc] initWithRootViewController:aboutViewController] autorelease];
			break;
	}
	
	
	[self.navigationController presentModalViewController:navigationController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 55;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	//	cell.textLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12.0];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
}

@end
