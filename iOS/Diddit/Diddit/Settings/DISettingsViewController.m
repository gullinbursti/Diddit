//
//  DISettingsViewController.m
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DISettingsViewController.h"

#import "DIAppDelegate.h"

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
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
	[self.view addSubview:bgImgView];
	
	_settingsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, self.view.bounds.size.width, 200) style:UITableViewStylePlain];
	_settingsTableView.rowHeight = 54;
	_settingsTableView.delegate = self;
	_settingsTableView.dataSource = self;
	_settingsTableView.backgroundColor = [UIColor clearColor];
	_settingsTableView.separatorColor = [UIColor clearColor];
	[self.view addSubview:_settingsTableView];
	
	UIImageView *overlayImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]];
	CGRect frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
	
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
				cell.textLabel.text = @"iTunes Credits";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
				
			case 1:
				cell.textLabel.text = @"Passcode";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
				
			case 2:
				cell.textLabel.text = @"Notifications";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
				
			case 3:
				cell.textLabel.text = @"Support";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
		}
		
		
		if (indexPath.row == 1 || indexPath.row == 2) {
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
	
	if (indexPath.row == 1 || indexPath.row == 2)
		return;
	
	UINavigationController *navigationController;
	DIAboutViewController *aboutViewController = [[[DIAboutViewController alloc] init] autorelease];
	DIEmailSettingsViewController *emailViewController = [[[DIEmailSettingsViewController alloc] init] autorelease];
	//DIPinSettingsViewController *pinViewController = [[[DIPinSettingsViewController alloc] init] autorelease];
	
	switch (indexPath.row) {
		case 0:
			navigationController = [[[UINavigationController alloc] initWithRootViewController:emailViewController] autorelease];
			break;
						
		case 3:
			navigationController = [[[UINavigationController alloc] initWithRootViewController:aboutViewController] autorelease];
			break;
	}
	
	if (navigationController)
		[self.navigationController presentModalViewController:navigationController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 55;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	cell.textLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:12.0];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
}

@end
