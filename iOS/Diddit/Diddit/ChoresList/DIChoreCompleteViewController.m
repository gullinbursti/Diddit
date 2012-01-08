//
//  DIChoreCompleteViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIChoreCompleteViewController.h"
#import "DIAppDelegate.h"

@implementation DIChoreCompleteViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 195, 40)];
		UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(44, 7, 195, 40)] autorelease];
		headerLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor];
		headerLabel.textColor = [UIColor colorWithRed:0.184313725490196 green:0.537254901960784 blue:0.298039215686275 alpha:1.0];
		headerLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		headerLabel.text = @"job complete";
		[headerLabel sizeToFit];
		[headerView addSubview:headerLabel];
		self.navigationItem.titleView = headerView;
		
		UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
		doneButton.frame = CGRectMake(0, 0, 59.0, 34);
		[doneButton setBackgroundImage:[[UIImage imageNamed:@"headerButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[doneButton setBackgroundImage:[[UIImage imageNamed:@"headerButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		doneButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		doneButton.titleLabel.shadowColor = [UIColor blackColor];
		doneButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		[doneButton setTitle:@"Done" forState:UIControlStateNormal];
		[doneButton addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:doneButton] autorelease];
	}
	
	return (self);
}

-(id)initWithChore:(DIChore *)chore {
	if ((self = [self init])) {
		_chore = chore;
		
		ASIFormDataRequest *rewardsRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
		[rewardsRequest setPostValue:[NSString stringWithFormat:@"%d", 4] forKey:@"action"];
		[rewardsRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[rewardsRequest setPostValue:[NSString stringWithFormat:@"%d", _chore.points] forKey:@"points"];
		[rewardsRequest setDelegate:self];
		[rewardsRequest startAsynchronous];
		
		[DIAppDelegate setUserPoints:[DIAppDelegate userPoints] + _chore.points];
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
	[self.view addSubview:bgImgView];
	
	UILabel *diddsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 60, 26)];
	diddsLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10];
	diddsLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
	diddsLabel.backgroundColor = [UIColor clearColor];
	diddsLabel.text = @"DIDDS";
	[self.view addSubview:diddsLabel];
	
	UIButton *diddsBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	diddsBtn.frame = CGRectMake(50, 15, 59, 34);
	diddsBtn.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10.0];
	//diddsBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[diddsBtn setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[diddsBtn setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateSelected];
	[diddsBtn setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
	[diddsBtn setTitle:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle] forState:UIControlStateNormal];
	[self.view addSubview:diddsBtn];
	
	UILabel *choresLabel = [[UILabel alloc] initWithFrame:CGRectMake(122, 20, 60, 26)];
	choresLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10];
	choresLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
	choresLabel.backgroundColor = [UIColor clearColor];
	choresLabel.text = @"CHORES";
	[self.view addSubview:choresLabel];
	
	UIButton *choresBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	choresBtn.frame = CGRectMake(170, 15, 38, 34);
	choresBtn.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10.0];
	[choresBtn setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[choresBtn setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateSelected];
	[choresBtn setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
	[choresBtn setTitle:@"5" forState:UIControlStateNormal];
	[self.view addSubview:choresBtn];
	
	UIButton *offersBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	offersBtn.frame = CGRectMake(228, 15, 84, 34);
	offersBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
	[offersBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_nonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[offersBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_Active.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateSelected];
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
	storeBtn.frame = CGRectMake(0, 350, 320, 60);
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
	[self dismissModalViewControllerAnimated:YES];
}

-(void)_goStore {
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
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
}

-(void)requestFailed:(ASIHTTPRequest *)request {
}


@end
