//
//  DIAddChoreDeviceViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.28.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAddChoreDeviceViewController.h"
#import "DINavTitleView.h"
#import "DINavBackBtnView.h"
#import "DIAppDelegate.h"
#import "DITableHeaderView.h"
#import "DINavRightBtnView.h"
#import "DIChorePriceViewController.h"
#import "DIDeviceViewCell.h"

@implementation DIAddChoreDeviceViewController

#pragma mark - View lifecycle
-(id)initWithChore:(DIChore *)chore {
	_chore = chore;
	if ((self = [super init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"devices"] autorelease];
		
		DINavBackBtnView *backBtnView = [[[DINavBackBtnView alloc] init] autorelease];
		[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
		
		DINavRightBtnView *nextBtnView = [[[DINavRightBtnView alloc] initWithLabel:@"Next"] autorelease];
		[[nextBtnView btn] addTarget:self action:@selector(_goNext) forControlEvents:UIControlEventTouchUpInside];		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:nextBtnView] autorelease];
		
		_devicesSelected = [[NSMutableString alloc] initWithCapacity:0];
		_devices = [[NSMutableArray alloc] init];
		
		_loadOverlay = [[DILoadOverlay alloc] init];
		_devicesDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
		[_devicesDataRequest setPostValue:[NSString stringWithFormat:@"%d", 7] forKey:@"action"];
		[_devicesDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[_devicesDataRequest setDelegate:self];
		[_devicesDataRequest startAsynchronous];
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]] autorelease];
	[self.view addSubview:bgImgView];
	
	
	_devicesTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_devicesTableView.rowHeight = 90;
	_devicesTableView.backgroundColor = [UIColor clearColor];
	_devicesTableView.separatorColor = [UIColor clearColor];
	_devicesTableView.delegate = self;
	_devicesTableView.dataSource = self;
	[self.view addSubview:_devicesTableView];
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	CGRect frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];

}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidUnload {
    [super viewDidUnload];
}


#pragma mark - Navigation
-(void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)_goNext {
	NSLog(@"SELECTED DEVICES [%@]", [_devicesSelected substringToIndex:[_devicesSelected length] - 1]);
	
	[[NSUserDefaults standardUserDefaults] setObject:[_devicesSelected substringToIndex:[_devicesSelected length] - 1] forKey:@"devices"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	_chore.subIDs = [_devicesSelected substringToIndex:[_devicesSelected length] - 1];
	
	[self.navigationController pushViewController:[[[DIChorePriceViewController alloc] initWithChore:_chore] autorelease] animated:YES];
}


#pragma mark - TableView Data Source Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([_devices count]);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	DIDeviceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIDeviceViewCell cellReuseIdentifier]];
	
	if (cell == nil)
		cell = [[[DIDeviceViewCell alloc] init] autorelease];
	
	cell.device = [_devices objectAtIndex:indexPath.row];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	return (cell);		
}



#pragma mark - TableView Delegates
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return (35);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return ([[[DITableHeaderView alloc] initWithTitle:@"select which devices you want to reward"] autorelease]);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DIDeviceViewCell *cell = (DIDeviceViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	
	[cell toggleSelected];
	
	if (cell.isSelected) {
		[_devicesSelected appendFormat:@"%d|", cell.device.device_id];
		
	} else {
		[_devicesSelected replaceOccurrencesOfString:[NSString stringWithFormat:@"%d|", cell.device.device_id] withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [_devicesSelected length])];
	}
	
	//	if (indexPath.row > 0) {
	//		DIAppViewCell *cell = (DIAppViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	//		[cell toggleSelected];
	//	
	//DIAddChoreTypeViewController *addChoreViewController = [[[DIAddChoreTypeViewController alloc] init] autorelease];
	//UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:addChoreViewController] autorelease];
	//[self.navigationController presentModalViewController:navigationController animated:YES];
	//	}	
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// UITableViewCell *cell = (UITableViewCell *)[_cells objectAtIndex:indexPath.row];
	// cell.alpha = 1.0;
	// 
	// DIApp *app = (DIApp *)[_apps objectAtIndex:indexPath.row];
	// 
	// [self.navigationController pushViewController:[[[DIAppDetailsViewController alloc] initWithApp:app] autorelease] animated:YES];
	// [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (90);
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	//NSLog(@"SubDevicesViewController [_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	
	@autoreleasepool {
		NSError *error = nil;
		NSArray *parsedDevices = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
		if (error != nil)
			NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
		
		else {
			NSMutableArray *deviceList = [NSMutableArray array];
			
			for (NSDictionary *serverDevice in parsedDevices) {
				DIDevice *device = [DIDevice deviceWithDictionary:serverDevice];
				
				//NSLog(@"APP \"%@\"", app.title);
				
				if (device != nil)
					[deviceList addObject:device];
			}
			
			_devices = [deviceList retain];
			[_devicesTableView reloadData];
		}			
	}
	
	[_loadOverlay remove];
}


-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
}


@end
