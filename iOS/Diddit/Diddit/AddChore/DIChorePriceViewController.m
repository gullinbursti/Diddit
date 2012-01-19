//
//  DIChorePriceViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIAppDelegate.h"
#import "DINavRightBtnView.h"
#import "DIChorePriceViewController.h"

#import "DIReward.h"
#import "DIRewardViewCell.h"
#import "DIHowDiddsWorkViewController.h"
#import "DIConfirmChoreViewController.h"

@implementation DIChorePriceViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super initWithTitle:@"add chore" header:@"how much is the chore worth?" backBtn:@"Back"])) {
		
		DINavRightBtnView *nextBtnView = [[[DINavRightBtnView alloc] initWithLabel:@"Next"] autorelease];
		[[nextBtnView btn] addTarget:self action:@selector(_goNext) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:nextBtnView] autorelease];
		
		
		_selIndex = -1;
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
	_howBtn.hidden = YES;
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	CGRect frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
	
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	
	ASIFormDataRequest *iapPakRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/AppStore.php"]] retain];
	[iapPakRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
	[iapPakRequest setDelegate:self];
	[iapPakRequest startAsynchronous];
}

-(void)viewDidLoad {
	[super viewDidLoad];
}

-(void)viewDidUnload {
	[super viewDidUnload];
}

-(void)dealloc {
	[_rewardTableView release];
	[_iapPaks release];
	[_howBtn release];
	[_loadOverlay release];
	
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
	DIHowDiddsWorkViewController *howDiddsWorkViewController = [[[DIHowDiddsWorkViewController alloc] initWithTitle:@"what are didds?" header:@"didds are app currency for kids" closeLabel:@"Done"] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:howDiddsWorkViewController] autorelease];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}



#pragma mark - TableView Data Source Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([_iapPaks count] + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row < [_iapPaks count]) {
		DIRewardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIRewardViewCell cellReuseIdentifier]];
		
		if (cell == nil)
			cell = [[[DIRewardViewCell alloc] init] autorelease];
		
		cell.reward = [_iapPaks objectAtIndex:indexPath.row];
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
	
	_selIndex = indexPath.row;
	if (indexPath.row < [_iapPaks count]) {
	
		DIRewardViewCell *cell;
		for (int i=0; i<[_cells count]; i++) {
			cell = (DIRewardViewCell *)[_cells objectAtIndex:i];
			[cell toggleSelect:NO];
		}
	
		cell = (DIRewardViewCell *)[_cells objectAtIndex:indexPath.row];
		[cell toggleSelect:YES];
		
		_chore.points = ((DIReward *)[_iapPaks objectAtIndex:indexPath.row]).points;
		_chore.cost = ((DIReward *)[_iapPaks objectAtIndex:indexPath.row]).cost;
		_chore.icoPath = ((DIReward *)[_iapPaks objectAtIndex:indexPath.row]).ico_url;
		_chore.itunes_id = ((DIReward *)[_iapPaks objectAtIndex:indexPath.row]).itunes_id;
	}
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (95);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	
	if (indexPath.row != _selIndex && _selIndex > -1 && indexPath.row < [_iapPaks count])
		[(DIRewardViewCell *) cell toggleSelect:NO];
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	//NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	@autoreleasepool {
		NSError *error = nil;
		NSArray *parsedPaks = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
		
		if (error != nil)
			NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
		
		else {
			NSMutableArray *iapList = [NSMutableArray array];
			
			for (NSDictionary *serverIAP in parsedPaks) {
				DIReward *reward = [DIReward rewardWithDictionary:serverIAP];
				
				if (reward != nil)
					[iapList addObject:reward];
			}
			
			_iapPaks = [iapList retain];
			[_rewardTableView reloadData];
			_howBtn.hidden = NO;
			
		}
	}
	
	[_loadOverlay remove];
}

-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
}



@end
