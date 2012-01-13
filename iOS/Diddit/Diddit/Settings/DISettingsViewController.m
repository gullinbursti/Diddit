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

#import "DINavTitleView.h"
#import "DINavHomeIcoBtnView.h"
#import "DISupportViewController.h"
#import "DIStoreCreditsViewController.h"
#import "DIPinSettingsViewController.h"

@implementation DISettingsViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		self.navigationItem.titleView = [[DINavTitleView alloc] initWithTitle:@"settings"];
		
		DINavHomeIcoBtnView *homeBtnView = [[DINavHomeIcoBtnView alloc] init];
		[[homeBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:homeBtnView] autorelease];
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
	[self.view addSubview:bgImgView];
	
	_settingsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 4, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
	_settingsTableView.rowHeight = 55;
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
	[super viewDidAppear:animated];
}

-(void)viewDidUnload {
	[super viewDidUnload];
}

-(void)dealloc {
	[super dealloc];
}


#pragma mark - navigation
-(void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
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
				cell.textLabel.text = @"credits";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
				
			case 1:
				cell.textLabel.text = @"passcode";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
				
			case 2:
				cell.textLabel.text = @"notifications";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
				
			case 3:
				cell.textLabel.text = @"support";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
		}
		
		
		if (indexPath.row == 1 || indexPath.row == 2) {
			UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
			switchView.on = YES;
			cell.accessoryView = switchView;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			if (indexPath.row == 2) {
				if (![DIAppDelegate notificationsEnabled])
					switchView.on = NO;
				
				[switchView addTarget:self action:@selector(_goNotificationsToggle:) forControlEvents:UIControlEventValueChanged];
			}
			[switchView release];
			
		} else {
			 UIImageView *chevronView = [[UIImageView alloc] initWithFrame:CGRectMake(295.0, 23.0, 14, 14)];		
			 chevronView.image = [UIImage imageNamed:@"mainListChevron.png"];
			 [cell addSubview:chevronView];
		}
		
		UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
		CGRect frame = dividerImgView.frame;
		frame.origin.y = 54;
		dividerImgView.frame = frame;
		[cell addSubview:dividerImgView];
	}
	
	return cell;
}


-(void)_goNotificationsToggle:(UISwitch *)switchView {

	//UITableViewCell *cell = (UITableViewCell *)[switchView superview];
	//UITableView *table = (UITableView *)[cell superview];
	//NSIndexPath *switchViewIndexPath = [table indexPathForCell:cell];
	
	[DIAppDelegate notificationsToggle:switchView.on];
}

#pragma mark - TableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
	
	if (indexPath.row == 1 || indexPath.row == 2)
		return;
	
	//	UINavigationController *navigationController;
	//	DISupportViewController *supportViewController = [[[DISupportViewController alloc] initWithTitle:@"support" header:@"diddit help" backBtn:@"Done"] autorelease];
	// DIStoreCreditsViewController *storeCreditsViewController = [[[DIStoreCreditsViewController alloc] init] autorelease];
	//DIPinSettingsViewController *pinViewController = [[[DIPinSettingsViewController alloc] init] autorelease];
	
	switch (indexPath.row) {
		case 0:
			[self.navigationController pushViewController:[[[DIStoreCreditsViewController alloc] init] autorelease] animated:YES];
			//navigationController = [[[UINavigationController alloc] initWithRootViewController:storeCreditsViewController] autorelease];
			break;
			
		case 2:
			[DIAppDelegate notificationsToggle:![DIAppDelegate notificationsEnabled]];
			break;
			
		case 3:
			[self.navigationController pushViewController:[[[DISupportViewController alloc] initWithTitle:@"support" header:@"diddit help" backBtn:@"Done"] autorelease] animated:YES];
			//navigationController = [[[UINavigationController alloc] initWithRootViewController:supportViewController] autorelease];
			break;
	}
	
	//if (navigationController)
	//	[self.navigationController pushViewController:navigationController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 55;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	cell.textLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:16.0];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	cell.textLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	cell.textLabel.shadowOffset = CGSizeMake(1.0, 1.0);
}

@end
