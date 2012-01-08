//
//  DIChorePriceViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIAppDelegate.h"
#import "DIChorePriceViewController.h"

#import "DIReward.h"
#import "DIRewardViewCell.h"
#import "DIHowDiddsWorkViewController.h"
#import "DIConfirmChoreViewController.h"

@implementation DIChorePriceViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super initWithTitle:@"add chore" header:@"how much is the chore worth?" backBtn:@"Back"])) {
		
		UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
		nextButton.frame = CGRectMake(0, 0, 59.0, 34);
		[nextButton setBackgroundImage:[[UIImage imageNamed:@"headerButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[nextButton setBackgroundImage:[[UIImage imageNamed:@"headerButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		nextButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		nextButton.titleLabel.shadowColor = [UIColor blackColor];
		nextButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		[nextButton setTitle:@"Next" forState:UIControlStateNormal];
		[nextButton addTarget:self action:@selector(_goNext) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:nextButton] autorelease];
		
		ASIFormDataRequest *rewardsRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Rewards.php"]] retain];
		[rewardsRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
		[rewardsRequest setDelegate:self];
		[rewardsRequest startAsynchronous];
		
		_cells = [[NSMutableArray alloc] init];
	}
	
	return (self);
}

-(id)initWithChore:(DIChore *)chore {
	if ((self = [self init])) {
		_chore = chore;
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	_rewardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, self.view.bounds.size.width, self.view.bounds.size.height - 80) style:UITableViewStylePlain];
	_rewardTableView.rowHeight = 80;
	_rewardTableView.backgroundColor = [UIColor clearColor];
	_rewardTableView.separatorColor = [UIColor clearColor];
	_rewardTableView.rowHeight = 95;
	_rewardTableView.delegate = self;
	_rewardTableView.dataSource = self;
	[self.view addSubview:_rewardTableView];
	
	_howBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_howBtn.frame = CGRectMake(84, 30, 150, 28);
	_howBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
	[_howBtn setBackgroundImage:[[UIImage imageNamed:@"genericButton_nonActive.png"] stretchableImageWithLeftCapWidth:17 topCapHeight:0] forState:UIControlStateNormal];
	[_howBtn setBackgroundImage:[[UIImage imageNamed:@"genericButton_Active.png"] stretchableImageWithLeftCapWidth:17 topCapHeight:0] forState:UIControlStateHighlighted];
	[_howBtn setTitleColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateNormal];
	[_howBtn setTitle:@"How do didds work?" forState:UIControlStateNormal];
	[_howBtn addTarget:self action:@selector(_goHow) forControlEvents:UIControlEventTouchUpInside];
	
	UIImageView *overlayImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]];
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
	[super dealloc];
}


#pragma mark - Navigation
-(void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)_goNext {
	[self.navigationController pushViewController:[[[DIConfirmChoreViewController alloc] initWithChore:_chore] autorelease] animated:YES];
}


-(void)_goHow {
	DIHowDiddsWorkViewController *howDiddsWorkViewController = [[[DIHowDiddsWorkViewController alloc] initWithTitle:@"what are dids?" header:@"didds are app currency for kids" closeLabel:@"Done"] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:howDiddsWorkViewController] autorelease];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}



#pragma mark - TableView Data Source Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([_rewards count] + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row < [_rewards count]) {
		DIRewardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIRewardViewCell cellReuseIdentifier]];
		
		if (cell == nil)
			cell = [[[DIRewardViewCell alloc] init] autorelease];
		
		cell.reward = [_rewards objectAtIndex:indexPath.row];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
		[_cells addObject:cell];
			
		return (cell);
		
	} else {
		UITableViewCell *cell = nil;
		
		cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
		
		if (cell == nil) {			
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
			[cell addSubview:_howBtn];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
		
		return (cell);
	}
}

#pragma mark - TableView Delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row < [_rewards count]) {
	
		DIRewardViewCell *cell;
		for (int i=0; i<[_cells count]; i++) {
			cell = (DIRewardViewCell *)[_cells objectAtIndex:i];
			[cell toggleSelect:NO];
		}
	
		cell = (DIRewardViewCell *)[_cells objectAtIndex:indexPath.row];
		[cell toggleSelect:YES];
		
		_chore.points = ((DIReward *)[_rewards objectAtIndex:indexPath.row]).points;
		_chore.cost = ((DIReward *)[_rewards objectAtIndex:indexPath.row]).cost;
	}
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (95);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	//	cell.textLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12.0];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	//NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	@autoreleasepool {
		NSError *error = nil;
		NSArray *parsedRewards = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
		
		if (error != nil)
			NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
		
		else {
			NSMutableArray *rewardList = [NSMutableArray array];
			
			for (NSDictionary *serverReward in parsedRewards) {
				DIReward *reward = [DIReward rewardWithDictionary:serverReward];
				
				if (reward != nil)
					[rewardList addObject:reward];
			}
			
			_rewards = [rewardList retain];
			[_rewardTableView reloadData];
		}
	}
}

-(void)requestFailed:(ASIHTTPRequest *)request {
}



@end
