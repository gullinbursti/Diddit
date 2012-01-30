//
//  DIStoreCreditsViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.09.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIStoreCreditsViewController.h"

#import "DIAppDelegate.h"
#import "DINavBackBtnView.h"
#import "DINavTitleView.h"
#import "DIStoreCreditsViewCell.h"

@implementation DIStoreCreditsViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		
	}
	
	return (self);
}

-(id)initAsCredits {
	_type_id = 5;
	
	if ((self = [self init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"credits"] autorelease];
		
		DINavBackBtnView *backBtnView = [[[DINavBackBtnView alloc] init] autorelease];
		[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
		
		_credits = [[NSMutableArray alloc] init];
		
		ASIFormDataRequest *appRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Store.php"]] retain];
		[appRequest setPostValue:[NSString stringWithFormat:@"%d", 4] forKey:@"action"];
		[appRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[appRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"sub_id"] forKey:@"subID"];
		[appRequest setDelegate:self];
		[appRequest startAsynchronous];
	}
	
	return (self);
}

-(id)initAsInAppGoods {
	_type_id = 6;
	
	if ((self = [self init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"goods"] autorelease];
		
		DINavBackBtnView *backBtnView = [[[DINavBackBtnView alloc] init] autorelease];
		[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
		
		_credits = [[NSMutableArray alloc] init];
		
		ASIFormDataRequest *appRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Store.php"]] retain];
		[appRequest setPostValue:[NSString stringWithFormat:@"%d", 4] forKey:@"action"];
		[appRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[appRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"sub_id"] forKey:@"subID"];
		[appRequest setDelegate:self];
		[appRequest startAsynchronous];	
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]] autorelease];
	[self.view addSubview:bgImgView];
	
	_creditsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_creditsTableView.rowHeight = 70;
	_creditsTableView.backgroundColor = [UIColor clearColor];
	_creditsTableView.separatorColor = [UIColor clearColor];
	_creditsTableView.delegate = self;
	_creditsTableView.dataSource = self;
	[self.view addSubview:_creditsTableView];
	
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

-(void)dealloc {
	[_creditsTableView release];
	
	[super dealloc];
}


#pragma mark - Navigation
-(void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Data Source Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([_credits count]);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//if (indexPath.row < [_credits count]) {
		DIStoreCreditsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIStoreCreditsViewCell cellReuseIdentifier]];
		
		if (cell == nil)
			cell = [[[DIStoreCreditsViewCell alloc] init] autorelease];
		
		cell.app = [_credits objectAtIndex:indexPath.row];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		//[_cells addObject:cell];
		return (cell);
	//}
}

#pragma mark - TableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (70);
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
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
			
			for (NSDictionary *serverApp in parsedApps) {
				DIApp *app = [DIApp appWithDictionary:serverApp];
				
				if (app != nil)
					[appList addObject:app];
			}
			
			_credits = [appList retain];
			[_creditsTableView reloadData];
		}
	}
}


-(void)requestFailed:(ASIHTTPRequest *)request {
	//[_loadOverlayView toggle:NO];
}

@end
