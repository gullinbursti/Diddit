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
#import "DINavBackBtnView.h"
#import "DIStoreCreditsViewController.h"
#import "DIPinSettingsViewController.h"

@implementation DISettingsViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"settings"] autorelease];
		
		DINavBackBtnView *backBtnView = [[[DINavBackBtnView alloc] init] autorelease];
		[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]] autorelease];
	[self.view addSubview:bgImgView];
	
	_settingsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 4, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
	_settingsTableView.rowHeight = 60;
	_settingsTableView.delegate = self;
	_settingsTableView.dataSource = self;
	_settingsTableView.backgroundColor = [UIColor clearColor];
	_settingsTableView.separatorColor = [UIColor clearColor];
	[self.view addSubview:_settingsTableView];
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
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
	[_settingsTableView release];
	
	[super dealloc];
}


#pragma mark - navigation
-(void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Data Source Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (5);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
		
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = @"iTunes credits";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
				
			case 1:
				cell.textLabel.text = @"in-app goods";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
				
			case 2:
				cell.textLabel.text = @"passcode";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
				
			case 3:
				cell.textLabel.text = @"notifications";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
				
			case 4:
				cell.textLabel.text = @"support";//[NSString stringWithFormat:@"%d", indexPath.row];
				break;
		}
		
		
		if (indexPath.row == 2 || indexPath.row == 3) {
			UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
			switchView.on = YES;
			cell.accessoryView = switchView;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			if (indexPath.row == 3) {
				if (![DIAppDelegate notificationsEnabled])
					switchView.on = NO;
				
				[switchView addTarget:self action:@selector(_goNotificationsToggle:) forControlEvents:UIControlEventValueChanged];
			}
			[switchView release];
			
		} else {
			UIImageView *chevronView = [[UIImageView alloc] initWithFrame:CGRectMake(295.0, 23.0, 14, 14)];		
			chevronView.image = [UIImage imageNamed:@"mainListChevron.png"];
			[cell addSubview:chevronView];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			[chevronView release];
		}
		
		UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
		CGRect frame = dividerImgView.frame;
		frame.origin.y = 60;
		dividerImgView.frame = frame;
		[cell addSubview:dividerImgView];
		[dividerImgView release];
	}
	
	return cell;
}

#pragma mark - Navigation
-(void)_goNotificationsToggle:(UISwitch *)switchView {

	//UITableViewCell *cell = (UITableViewCell *)[switchView superview];
	//UITableView *table = (UITableView *)[cell superview];
	//NSIndexPath *switchViewIndexPath = [table indexPathForCell:cell];
	
	[DIAppDelegate notificationsToggle:switchView.on];
}

-(void)_goSupport {
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
		mfViewController.mailComposeDelegate = self;
		[mfViewController setSubject:[NSString stringWithFormat:@"Support Ticket - diddit %@", @""]];
		[mfViewController setMessageBody:@"Mirum est notare quam littera gothica quam nunc putamus parum claram anteposuerit litterarum formas humanitatis. Ex ea commodo consequat duis autem vel eum iriure dolor in." isHTML:NO];
		
		[self presentViewController:mfViewController animated:YES completion:nil];
		[mfViewController release];
		
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"Your phone is not currently configured to send mail." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
		
		[alert show];
		[alert release];
	}
}

#pragma mark - TableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
	
	if (indexPath.row == 2 || indexPath.row == 3)
		return;
	
	//	UINavigationController *navigationController;
	//	DISupportViewController *supportViewController = [[[DISupportViewController alloc] initWithTitle:@"support" header:@"diddit help" backBtn:@"Done"] autorelease];
	// DIStoreCreditsViewController *storeCreditsViewController = [[[DIStoreCreditsViewController alloc] init] autorelease];
	//DIPinSettingsViewController *pinViewController = [[[DIPinSettingsViewController alloc] init] autorelease];
	
	switch (indexPath.row) {
		case 0:
			[UIView animateWithDuration:0.25 animations:^(void) {
				[[tableView cellForRowAtIndexPath:indexPath] setAlpha:0.5];
				
			} completion:^(BOOL finished) {
				[UIView animateWithDuration:0.125 animations:^(void) {
					[[tableView cellForRowAtIndexPath:indexPath] setAlpha:1.0];	
				}];
			}];
			
			[self.navigationController pushViewController:[[[DIStoreCreditsViewController alloc] initAsCredits] autorelease] animated:YES];
			//navigationController = [[[UINavigationController alloc] initWithRootViewController:storeCreditsViewController] autorelease];
			break;
			
		case 1:
			[UIView animateWithDuration:0.25 animations:^(void) {
				[[tableView cellForRowAtIndexPath:indexPath] setAlpha:0.5];
				
			} completion:^(BOOL finished) {
				[UIView animateWithDuration:0.125 animations:^(void) {
					[[tableView cellForRowAtIndexPath:indexPath] setAlpha:1.0];	
				}];
			}];
			
			[self.navigationController pushViewController:[[[DIStoreCreditsViewController alloc] initAsInAppGoods] autorelease] animated:YES];
			//navigationController = [[[UINavigationController alloc] initWithRootViewController:storeCreditsViewController] autorelease];
			break;
		
		case 2:
			break;
			
		case 3:
			[DIAppDelegate notificationsToggle:![DIAppDelegate notificationsEnabled]];
			break;
			
		case 4:
			[UIView animateWithDuration:0.25 animations:^(void) {
				[[tableView cellForRowAtIndexPath:indexPath] setAlpha:0.5];
				
			} completion:^(BOOL finished) {
				[UIView animateWithDuration:0.125 animations:^(void) {
					[[tableView cellForRowAtIndexPath:indexPath] setAlpha:1.0];	
				}];
			}];
			
			[self _goSupport];
			break;
	}
	
	//if (navigationController)
	//	[self.navigationController pushViewController:navigationController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	cell.textLabel.font = [[DIAppDelegate diAdelleFontRegular] fontWithSize:16.0];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
	cell.textLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	cell.textLabel.shadowOffset = CGSizeMake(1.0, 1.0);
}



#pragma mark MailComposeViewController Delegates
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
	
	switch (result) {
		case MFMailComposeResultCancelled:
			alert.message = @"Message Canceled";
			break;
			
		case MFMailComposeResultSaved:
			alert.message = @"Message Saved";
			[alert show];
			break;
			
		case MFMailComposeResultSent:
			alert.message = @"Message Sent";
			break;
			
		case MFMailComposeResultFailed:
			alert.message = @"Message Failed";
			[alert show];
			break;
			
		default:
			alert.message = @"Message Not Sent";
			[alert show];
			break;
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
	
	
	[alert release];
}
@end
