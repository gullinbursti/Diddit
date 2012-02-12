//
//  DIMyWalletViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 02.04.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIMyWalletViewController.h"

#import "ASIFormDataRequest.h"
#import "DIAppDelegate.h"
#import "DIHistoryViewCell.h"

#import "DINavTitleView.h"
#import "DINavBackBtnView.h"

#import "DITableHeaderView.h"

#import "DIOfferListViewController.h"

@implementation DIMyWalletViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"wallet"] autorelease];
		
		DINavBackBtnView *backBtnView = [[[DINavBackBtnView alloc] init] autorelease];
		[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
		
		
		_loadOverlay = [[DILoadOverlay alloc] init];
		_historyDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kServerPath, @"Rewards.php"]]] retain];
		[_historyDataRequest setPostValue:[NSString stringWithFormat:@"%d", 9] forKey:@"action"];
		[_historyDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[_historyDataRequest setDelegate:self];
		[_historyDataRequest startAsynchronous];
		
		_offersDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kServerPath, @"Rewards.php"]]] retain];
		[_offersDataRequest setPostValue:[NSString stringWithFormat:@"%d", 9] forKey:@"action"];
		[_offersDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[_offersDataRequest setDelegate:self];
		
		_storeDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kServerPath, @"Store.php"]]] retain];
		[_storeDataRequest setPostValue:[NSString stringWithFormat:@"%d", 4] forKey:@"action"];
		[_storeDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[_storeDataRequest setDelegate:self];
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]] autorelease];
	[self.view addSubview:bgImgView];
	
	_historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 30) style:UITableViewStylePlain];
	_historyTableView.rowHeight = 70;
	_historyTableView.backgroundColor = [UIColor clearColor];
	_historyTableView.separatorColor = [UIColor clearColor];
	_historyTableView.dataSource = self;
	_historyTableView.delegate = self;
	[self.view addSubview:_historyTableView];
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidUnload {
    [super viewDidUnload];
}

-(void)dealloc {
	[super dealloc];
}


#pragma mark - Navigation
-(void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)_goEarn {
	[self.navigationController pushViewController:[[[DIOfferListViewController alloc] init] autorelease] animated:YES];
}

#pragma mark - TableView Data Source Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([_history count] + 1);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	if (indexPath.row == 0) {
		UITableViewCell *cell = nil;
		
		cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
		if (cell == nil)
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
		
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		UILabel *ptsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 34, 300, 80)];
		ptsLabel.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:64];
		ptsLabel.backgroundColor = [UIColor clearColor];
		ptsLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
		ptsLabel.textAlignment = UITextAlignmentCenter;
		ptsLabel.text = [NSString stringWithFormat:@"%d", [DIAppDelegate userPoints]];
		[cell addSubview:ptsLabel];
		
		UIImageView *dividerImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"walletBG.png"]] autorelease];
		CGRect frame = CGRectMake(32, 116, 264, 84);
		dividerImgView.frame = frame;
		[cell addSubview:dividerImgView];
		
		
		UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 141, 260, 40)];
		infoLabel.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:12];
		infoLabel.backgroundColor = [UIColor clearColor];
		infoLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
		infoLabel.textAlignment = UITextAlignmentCenter;
		infoLabel.numberOfLines = 0;
		infoLabel.text = [NSString stringWithFormat:@"you have %d didds available to redeem for gidt cards and apps", [DIAppDelegate userPoints]];
		[cell addSubview:infoLabel];
		
		UIButton *_earnMoreButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		_earnMoreButton.frame = CGRectMake(85, 217, 154, 34);
		[_earnMoreButton setBackgroundImage:[[UIImage imageNamed:@"greenCommonButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[_earnMoreButton setBackgroundImage:[[UIImage imageNamed:@"greenCommonButton_active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		_earnMoreButton.titleLabel.font = [[DIAppDelegate diOpenSansFontSemibold] fontWithSize:11];
		_earnMoreButton.titleLabel.shadowColor = [UIColor blackColor];
		_earnMoreButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		_earnMoreButton.titleEdgeInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
		[_earnMoreButton setTitle:@"Tap here to earn more" forState:UIControlStateNormal];
		[_earnMoreButton addTarget:self action:@selector(_goEarn) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:_earnMoreButton];
		
		UIView *historyHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 275, 320, 35)] autorelease];
		historyHeaderView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.05];
		[cell addSubview:historyHeaderView];
		
		UILabel *historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 10, 300.0, 16)];
		historyLabel.font = [[DIAppDelegate diOpenSansFontBold] fontWithSize:10.0];
		historyLabel.backgroundColor = [UIColor clearColor];
		historyLabel.textColor = [DIAppDelegate diColor5D5D5D];
		historyLabel.text = @"History";
		[historyHeaderView addSubview:historyLabel];
		
		
		return (cell);
	
	} else {
		DIHistoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIHistoryViewCell cellReuseIdentifier]];
		
		if (cell == nil)
			cell = [[[DIHistoryViewCell alloc] initWithIndex:indexPath.row - 1] autorelease];
		
		cell.chore = [_history objectAtIndex:indexPath.row - 1];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		return (cell);
	}
}

#pragma mark - TableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0)
		return;
	
	DIHistoryViewCell *cell = (DIHistoryViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	[cell toggleSelected];
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	/*
	 [UIView animateWithDuration:0.2 animations:^(void) {
	 cell.alpha = 0.5;
	 } completion:^(BOOL finished) {
	 [UIView animateWithDuration:0.15 animations:^(void) {
	 cell.alpha = 1.0;
	 
	 [self.navigationController pushViewController:[[[DIChoreDetailsViewController alloc] initWithChore:[_chores objectAtIndex:indexPath.row]] autorelease] animated:YES];	
	 [tableView deselectRowAtIndexPath:indexPath animated:YES];
	 }];
	 }];
	 */
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0)
		return (310);
	
	else
		return (70);
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	//	cell.textLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12.0];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	NSLog(@"ChoreListViewController [_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
		
	if ([request isEqual:_historyDataRequest]) {	
		@autoreleasepool {
			NSError *error = nil;
			NSArray *parsedList = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				NSMutableArray *historyList = [NSMutableArray array];
				
				for (NSDictionary *dict in parsedList) {
					DIChore *chore = [DIChore choreWithDictionary:dict];
					
					NSLog(@"HISTORY \"%@\" (%d)", chore.title, chore.type_id);
					[historyList addObject:chore];
				}
				
				_history = [historyList retain];
				[_historyTableView reloadData];
				[_storeDataRequest startAsynchronous];
			}			
		}
	
	} else if ([request isEqual:_storeDataRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			NSArray *parsedList = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				NSMutableArray *storeList = [NSMutableArray array];
				
				for (NSDictionary *dict in parsedList) {
					DIChore *chore = [DIChore choreWithDictionary:dict];
					
					NSLog(@"STORE \"%@\" (%d)", chore.title, chore.type_id);
					[storeList addObject:chore];
				}
				
				[_history addObjectsFromArray:storeList];
				//_history = [storeList retain];
				[_historyTableView reloadData];
			}			
		}
		
		//[_offersDataRequest startAsynchronous];
	}
		
	[_loadOverlay remove];
}


-(void)requestFailed:(ASIHTTPRequest *)request {
	
	//[_delegates perform:@selector(jobList:didFailLoadWithError:) withObject:self withObject:request.error];
	//MBL_RELEASE_SAFELY(_jobListRequest);
	
	[_loadOverlay remove];
}


@end
