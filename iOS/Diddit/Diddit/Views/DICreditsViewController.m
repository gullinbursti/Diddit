//
//  DICreditsViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DICreditsViewController.h"
#import "DICreditsViewCell.h"
#import "DIApp.h"

@implementation DICreditsViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		
		_chores = [[NSMutableArray alloc] init];
		_apps = [[NSMutableArray alloc] init];
		
		
		ASIFormDataRequest *appsRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Apps.php"]] retain];
		[appsRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
		[appsRequest setDelegate:self];
		[appsRequest startAsynchronous];
		
		/*
		NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_apps" ofType:@"plist"]] options:NSPropertyListImmutable format:nil error:nil];
		
		NSArray *freeAppsArray = [[NSArray alloc] initWithArray:[plist objectForKey:@"free"]];
		NSArray *paidAppsArray = [[NSArray alloc] initWithArray:[plist objectForKey:@"paid"]];
		
		NSMutableArray *freeApps = [[NSMutableArray alloc] initWithCapacity:[freeAppsArray count]];
		for (NSDictionary *dict in freeAppsArray)
			[freeApps addObject:[DIApp appWithDictionary:dict]];
		
		NSMutableArray *paidApps = [[NSMutableArray alloc] initWithCapacity:[paidAppsArray count]];
		for (NSDictionary *dict in paidAppsArray)
			[paidApps addObject:[DIApp appWithDictionary:dict]];
		
		
		[_apps addObject:freeApps];
		[_apps addObject:paidApps];
		*/
		
		
		UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 39)] autorelease];
		//headerLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:18.0];
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor];
		headerLabel.textColor = [UIColor whiteColor];
		headerLabel.shadowColor = [UIColor colorWithWhite:0.25 alpha:1.0];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		headerLabel.text = @"My Credits";
		[headerLabel sizeToFit];
		self.navigationItem.titleView = headerLabel;
		
		_sectionTitles = [[NSArray alloc] initWithObjects:@"Free", @"Paid", nil];
	}
	
	return (self);
}


-(id)initWithPoints:(int)points {
	if ((self = [self init])) {
		_points = points;
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]] autorelease];
	[self.view addSubview:bgImgView];
	
	_creditsLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 22, 260, 20)];
	//_creditsLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12];
	_creditsLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	_creditsLabel.backgroundColor = [UIColor clearColor];
	_creditsLabel.textAlignment = UITextAlignmentCenter;
	_creditsLabel.text = [NSString stringWithFormat:@"You have %d credits!", _points];
	[self.view addSubview:_creditsLabel];
	
	[self.view setBackgroundColor:[UIColor colorWithWhite:0.75 alpha:1.0]];
	
	_creditsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height - 94) style:UITableViewStylePlain];
	_creditsTableView.rowHeight = 54;
	_creditsTableView.delegate = self;
	_creditsTableView.dataSource = nil;
	_creditsTableView.layer.borderColor = [[UIColor colorWithWhite:0.75 alpha:1.0] CGColor];
	_creditsTableView.layer.borderWidth = 1.0;
	[self.view addSubview:_creditsTableView];
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - TableView Data Source Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return (2);
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return ([_sectionTitles objectAtIndex:section]);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([[_apps objectAtIndex:section] count]);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	DICreditsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DICreditsViewCell cellReuseIdentifier]];
		
	if (cell == nil)
		cell = [[[DICreditsViewCell alloc] init] autorelease];
	
	NSArray *array = [_apps objectAtIndex:indexPath.section];
	
	cell.app = [array objectAtIndex:indexPath.row];
	cell.shouldDrawSeparator = (indexPath.row == ([array count] - 1));
	
	return cell;
}

#pragma mark - TableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//DIConfirmChoreViewController *confirmChoreType = [[[DIConfirmChoreViewController alloc] initWithChoreType:[_choreTypes objectAtIndex:indexPath.row]] autorelease];
	//UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:confirmChoreType] autorelease];
	//[self.navigationController presentViewController:navigationController animated:YES completion:nil];
	//[self.navigationController presentModalViewController:navigationController animated:YES];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 55;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	//	cell.textLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12.0];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	@autoreleasepool {
		NSError *error = nil;
		NSArray *parsedApps = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
		
		if (error != nil)
			NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
		
		else {
			NSMutableArray *appList = [NSMutableArray array];
			
			NSArray *freeList = [[NSArray alloc] initWithArray:[[parsedApps objectAtIndex:0] objectForKey:@"free"]];
			NSArray *paidList = [[NSArray alloc] initWithArray:[[parsedApps objectAtIndex:1] objectForKey:@"paid"]];
			
			NSMutableArray *freeApps = [[NSMutableArray alloc] init];
			NSMutableArray *paidApps = [[NSMutableArray alloc] init];
			
			for (NSDictionary *dict in freeList) {
				DIApp *app = [DIApp appWithDictionary:dict];
				
				if (app != nil)
					[freeApps addObject:app];
			}
			
			for (NSDictionary *dict in paidList) {
				DIApp *app = [DIApp appWithDictionary:dict];
				
				if (app != nil)
					[paidApps addObject:app];
			}
						
			[appList addObject:freeApps];
			[appList addObject:paidApps];

			_apps = [appList retain];
			_creditsTableView.dataSource = self;
			[_creditsTableView reloadData];
		}
	}
} 

@end
