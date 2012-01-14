//
//  DIChoreCompleteViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIChoreCompleteViewController.h"
#import "DIAppDelegate.h"
#import "DINavTitleView.h"
#import "DINavRightBtnView.h"
#import "DIChoreStatsView.h"
#import "DIOfferListViewController.h"

@implementation DIChoreCompleteViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {		
		self.navigationItem.titleView = [[DINavTitleView alloc] initWithTitle:@"job complete"];
		
		DINavRightBtnView *doneBtnView = [[DINavRightBtnView alloc] initWithLabel:@"Done"];
		[[doneBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:doneBtnView] autorelease];
	}
	
	return (self);
}

-(id)initWithChore:(DIChore *)chore {
	if ((self = [self init])) {
		_chore = chore;
		
		_loadOverlay = [[DILoadOverlay alloc] init];
		
		_userUpdRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
		[_userUpdRequest setPostValue:[NSString stringWithFormat:@"%d", 4] forKey:@"action"];
		[_userUpdRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[_userUpdRequest setPostValue:[NSString stringWithFormat:@"%d", _chore.points] forKey:@"points"];
		[_userUpdRequest setDelegate:self];
		[_userUpdRequest startAsynchronous];
		
		_choreUpdRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
		[_choreUpdRequest setPostValue:[NSString stringWithFormat:@"%d", 6] forKey:@"action"];
		[_choreUpdRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[_choreUpdRequest setPostValue:[NSString stringWithFormat:@"%d", _chore.chore_id] forKey:@"choreID"];
		[_choreUpdRequest setDelegate:self];
		
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
	[self.view addSubview:bgImgView];
	
	DIChoreStatsView *choreStatsView = [[DIChoreStatsView alloc] initWithFrame:CGRectMake(10, 13, 300, 34)];
	[self.view addSubview:choreStatsView];
	
	UIButton *offersBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	offersBtn.frame = CGRectMake(228, 15, 84, 34);
	offersBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
	[offersBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[offersBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[offersBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	offersBtn.titleLabel.shadowColor = [UIColor blackColor];
	offersBtn.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	[offersBtn setTitle:@"Earn Didds" forState:UIControlStateNormal];
	[offersBtn addTarget:self action:@selector(_goOffers) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:offersBtn];
	
	UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
	CGRect frame = dividerImgView.frame;
	frame.origin.y = 54;
	dividerImgView.frame = frame;
	[self.view addSubview:dividerImgView];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 74, 160, 32)];
	titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:26];
	titleLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.shadowColor = [UIColor whiteColor];
	titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	titleLabel.text = @"Great Work!";
	[self.view addSubview:titleLabel];
	
	UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 116, 300, 40)];
	infoLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	infoLabel.textColor = [UIColor colorWithWhite:0.33 alpha:1.0];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.numberOfLines = 0;
	infoLabel.text = @"Claritas est etiam processus dynamicus qui sequitur et quinta decima mutationem. Decima typi qui.";
	[self.view addSubview:infoLabel];
	
	
	
	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 348, 320, 72)];
	footerView.backgroundColor = [UIColor colorWithRed:0.2706 green:0.7804 blue:0.4549 alpha:1.0];
	[self.view addSubview:footerView];
	
	UIButton *storeBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	storeBtn.frame = CGRectMake(0, 352, 320, 59);
	storeBtn.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	storeBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[storeBtn setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[storeBtn setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[storeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[storeBtn setTitle:@"go to the store" forState:UIControlStateNormal];
	[storeBtn addTarget:self action:@selector(_goStore) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:storeBtn];
	
	UIImageView *overlayImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]];
	frame = overlayImgView.frame;
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
	[self dismissModalViewControllerAnimated:YES];
}

-(void)_goOffers {
	//[self dismissModalViewControllerAnimated:YES];
	
	[self.navigationController pushViewController:[[[DIOfferListViewController alloc] init] autorelease] animated:YES];
}

-(void)_goStore {
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	
	if ([request isEqual:_userUpdRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			NSDictionary *parsedUser = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
		
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
		
			else {
				[DIAppDelegate setUserProfile:parsedUser];
				[_pointsButton setTitle:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle] forState:UIControlStateNormal];
				[_choreUpdRequest startAsynchronous];
			}
		}
		
		
		
	} else if ([request isEqual:_choreUpdRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			//NSDictionary *parsedTotal = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				[_finishedButton setTitle:[NSString stringWithFormat:@"%d", [DIAppDelegate userTotalFinished]] forState:UIControlStateNormal];
				[[NSUserDefaults standardUserDefaults] setObject:nil forKey:_chore.imgPath];
			}
		}
	}
	
//	@autoreleasepool {
//		NSError *error = nil;
//		NSArray *parsedRewards = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
//		
//		if (error != nil)
//			NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
//		
//		else {
//			NSMutableArray *rewardList = [NSMutableArray array];
//			
//			for (NSDictionary *serverReward in parsedRewards) {
//				DIReward *reward = [DIReward rewardWithDictionary:serverReward];
//				
//				if (reward != nil)
//					[rewardList addObject:reward];
//			}
//			
//			_rewards = [rewardList retain];
//			[_rewardTableView reloadData];
//		}
//	}
	
	[_loadOverlay remove];
}

-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
}


@end
