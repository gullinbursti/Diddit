//
//  DISubListViewController.m
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DISubListViewController.h"

#import "DIAppDelegate.h"
#import "DIChoreStatsView.h"
#import "DIAddChoreTypeViewController.h"
#import "DIAppListViewController.h"
#import "DIAppDetailsViewController.h"
#import "DIOfferListViewController.h"
#import "DIOfferDetailsViewController.h"
#import "DISettingsViewController.h"
#import "DIMyChoresViewCell.h"
#import "DIMyWalletViewController.h"
#import "DISponsorshipItemButton.h"
#import "DISponsorship.h"
#import "DIRewardItemViewController.h"

#import "MBProgressHUD.h"

@implementation DISubListViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadData:) name:@"REFRESH_REWARDS_LIST" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_addChore:) name:@"ADD_CHORE" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_finishChore:) name:@"FINISH_CHORE" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_addComment:) name:@"ADD_CHORE_COMMENT" object:nil];
		
		//_activeDisplay = [[NSMutableArray alloc] init];
		_chores = [[NSMutableArray alloc] init];
		_rewards = [[NSMutableArray alloc] init];
		
		_finishedChores = [[NSMutableArray alloc] init];
		_isRewardList = YES;
		_itemOffset = 0;
		_viewControllerOffset = -1;
		
		_rewardsToggleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		_rewardsToggleButton.frame = CGRectMake(0.0, 3.0, 69.0, 39.0);
		[_rewardsToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleLeft_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
		[_rewardsToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleLeft_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
		[_rewardsToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleLeft_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateSelected];
		_rewardsToggleButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		_rewardsToggleButton.titleLabel.shadowColor = [UIColor blackColor];
		_rewardsToggleButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		_rewardsToggleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
		[_rewardsToggleButton setTitle:@"Rewards" forState:UIControlStateNormal];
		[_rewardsToggleButton addTarget:self action:@selector(_goRewards) forControlEvents:UIControlEventTouchUpInside];
		
		_choresToggleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		_choresToggleButton.frame = CGRectMake(69.0, 3.0, 69.0, 39.0);
		[_choresToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleRight_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
		[_choresToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleRight_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
		[_choresToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleRight_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateSelected];
		_choresToggleButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		_choresToggleButton.titleLabel.shadowColor = [UIColor blackColor];
		_choresToggleButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		_choresToggleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 3);
		[_choresToggleButton setTitle:@"Chores" forState:UIControlStateNormal];
		[_choresToggleButton addTarget:self action:@selector(_goChores) forControlEvents:UIControlEventTouchUpInside];
		
		UIView *ltBtnView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 138.0, 39.0)] autorelease];
		[ltBtnView addSubview:_rewardsToggleButton];
		[ltBtnView addSubview:_choresToggleButton];
		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:ltBtnView] autorelease];
		
		_ptsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		//_ptsButton.frame = CGRectMake(-4.0, 3.0, 69.0, 40.0);
		_ptsButton.frame = CGRectMake(-14.0, 3.0, 85.0, 40.0);
		[_ptsButton setBackgroundImage:[[UIImage imageNamed:@"diddBG_nonActive.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
		[_ptsButton setBackgroundImage:[[UIImage imageNamed:@"diddBG_Active.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateHighlighted];
		_ptsButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		[_ptsButton addTarget:self action:@selector(_goChores) forControlEvents:UIControlEventTouchUpInside];
		
		UIView *ptsHolderView = [[[UIView alloc] initWithFrame:CGRectMake(-5, 8, 40, 30)] autorelease];
		ptsHolderView.backgroundColor = [UIColor clearColor];
		ptsHolderView.clipsToBounds = YES;
		
		_pts1Label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)] autorelease];
		_pts1Label.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:11];
		_pts1Label.textColor = [UIColor colorWithRed:0.243 green:0.259 blue:0.247 alpha:1.0];
		_pts1Label.backgroundColor = [UIColor clearColor];
		_pts1Label.textAlignment = UITextAlignmentCenter;
		_pts1Label.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle];
		[ptsHolderView addSubview:_pts1Label];
		
		_pts2Label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 33, 40, 30)] autorelease];
		_pts2Label.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:11];
		_pts2Label.textColor = [UIColor colorWithRed:0.243 green:0.259 blue:0.247 alpha:1.0];
		_pts2Label.backgroundColor = [UIColor clearColor];
		_pts2Label.textAlignment = UITextAlignmentCenter;
		_pts2Label.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle];
		[ptsHolderView addSubview:_pts2Label];
		
		UIView *rtBtnView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 69.0, 40.0)] autorelease];		
		[rtBtnView addSubview:_ptsButton];
		[rtBtnView addSubview:ptsHolderView];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rtBtnView] autorelease];
		
		_loadOverlay = [[DILoadOverlay alloc] init];
		_activeChoresRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Rewards.php"]] retain];
		[_activeChoresRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
		[_activeChoresRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[_activeChoresRequest setDelegate:self];
		[_activeChoresRequest startAsynchronous];
	}
	
	return (self);
}
	
-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

-(void)viewDidLoad {
	[super viewDidLoad];
	
	CGRect frame;
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]] autorelease];
	[self.view addSubview:bgImgView];
	
	_emptyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 361.0)];
	_emptyScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_emptyScrollView.contentSize = CGSizeMake(320, 362.0);
	_emptyScrollView.opaque = NO;
	_emptyScrollView.scrollsToTop = NO;
	_emptyScrollView.showsHorizontalScrollIndicator = NO;
	_emptyScrollView.showsVerticalScrollIndicator = NO;
	_emptyScrollView.alwaysBounceVertical = NO;
	
	_holderView = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
	frame = _holderView.frame;
	frame.origin.y = 5.0;
	_holderView.frame = frame;
	[self.view addSubview:_holderView];
	[_holderView addSubview:_emptyScrollView];
	
	_rewardsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 361.0)];
	_rewardsScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_rewardsScrollView.contentSize = CGSizeMake(320, 362.0);
	_rewardsScrollView.opaque = NO;
	_rewardsScrollView.scrollsToTop = NO;
	_rewardsScrollView.showsHorizontalScrollIndicator = NO;
	_rewardsScrollView.showsVerticalScrollIndicator = NO;
	_rewardsScrollView.alwaysBounceVertical = NO;
	_rewardsScrollView.hidden = !_isRewardList;
	[_holderView addSubview:_rewardsScrollView];
	
	_choresScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 361.0)];
	_choresScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_choresScrollView.contentSize = CGSizeMake(320, 362.0);
	_choresScrollView.opaque = NO;
	_choresScrollView.scrollsToTop = NO;
	_choresScrollView.showsHorizontalScrollIndicator = NO;
	_choresScrollView.showsVerticalScrollIndicator = NO;
	_choresScrollView.alwaysBounceVertical = NO;
	_choresScrollView.hidden = _isRewardList;
	[_holderView addSubview:_choresScrollView];
	
	_emptyListImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emptyChoreListBG.jpg"]];
	frame = _emptyListImgView.frame;
	frame.origin.x = 0.0;
	frame.origin.y = -45.0;
	_emptyListImgView.frame = frame;
	[_emptyScrollView addSubview:_emptyListImgView];
	
	_footerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"footerBG.png"]];
	frame = _footerImgView.frame;
	frame.origin.y = 420 - (frame.size.height + 4);
	_footerImgView.frame = frame;
	[self.view addSubview:_footerImgView];
	
	_addCommentView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 280, 150)];
	_addCommentView.backgroundColor = [UIColor whiteColor];
	_addCommentView.layer.cornerRadius = 8.0;
	_addCommentView.clipsToBounds = YES;
	_addCommentView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
	_addCommentView.layer.borderWidth = 1.0;
	_addCommentView.hidden = YES;
	[self.view addSubview:_addCommentView];
	
	_addCommentTxtView = [[[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 160)] autorelease];
	[_addCommentTxtView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_addCommentTxtView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_addCommentTxtView setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_addCommentTxtView setBackgroundColor:[UIColor clearColor]];
	[_addCommentTxtView setTextColor:[UIColor colorWithWhite:0.67 alpha:1.0]];
	_addCommentTxtView.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	_addCommentTxtView.keyboardType = UIKeyboardTypeDefault;
	_addCommentTxtView.delegate = self;
	[_addCommentTxtView setReturnKeyType:UIReturnKeyDone];
	[_addCommentView addSubview:_addCommentTxtView];
			
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
	
	UIButton *shopBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain]; 
	shopBtn.frame = CGRectMake(15, 357, 79, 54);
	[shopBtn setBackgroundImage:[[UIImage imageNamed:@"rewardsIcon_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[shopBtn setBackgroundImage:[[UIImage imageNamed:@"rewardsIcon_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[shopBtn addTarget:self action:@selector(_goApps) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:shopBtn];
	
	UIButton *offersButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	offersButton.frame = CGRectMake(120, 357, 79, 54);
	[offersButton setBackgroundImage:[[UIImage imageNamed:@"earnIcon_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[offersButton setBackgroundImage:[[UIImage imageNamed:@"earnIcon_active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[offersButton addTarget:self action:@selector(_goOffers) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:offersButton];
	
	UIButton *walletButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	walletButton.frame = CGRectMake(220, 357, 79, 54);
	[walletButton setBackgroundImage:[[UIImage imageNamed:@"walletIcon_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[walletButton setBackgroundImage:[[UIImage imageNamed:@"walletIcon_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[walletButton addTarget:self action:@selector(_goWallet) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:walletButton];
}

-(void)viewDidUnload {
    [super viewDidUnload];
}


-(void)dealloc {
	[_activeChoresRequest release];
	[_loadOverlay release];
	[_rewardsScrollView release];
	[_choresScrollView release];
	[_chores release];
	[_finishedChores release];
	[_emptyListImgView release];
	[_footerImgView release];
	
	[super dealloc];
}

#pragma mark - Button Handlers
-(void)_goRewards {
	_isRewardList = YES;
	
	
	[_rewardsToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleLeft_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
	[_rewardsToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleLeft_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	
	[_choresToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleRight_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	
	_choresScrollView.hidden = _isRewardList;
	_rewardsScrollView.hidden = !_isRewardList;
	
	//_activeDisplay = [_rewards retain];
	//[_myRewardsTableView reloadData];
	
	//[_myChoresTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	//[_myRewardsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)_goChores {
	_isRewardList = NO;
	
	[_choresToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleRight_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
	[_choresToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleRight_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	
	[_rewardsToggleButton setBackgroundImage:[[UIImage imageNamed:@"toggleLeft_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	
	_choresScrollView.hidden = _isRewardList;
	_rewardsScrollView.hidden = !_isRewardList;
	
	//_activeDisplay = [_chores retain];
	//[_myChoresTableView reloadData];
	
	//[_myChoresTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	//[_myRewardsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)_goWallet {
	[self.navigationController pushViewController:[[[DIMyWalletViewController alloc] init] autorelease] animated:YES];
}

-(void)_goSettings {
	[self.navigationController pushViewController:[[[DISettingsViewController alloc] init] autorelease] animated:YES];
}

-(void)_goFooterAnimation {
	
	/*
	[UIView animateWithDuration:0.15 animations:^{
		_footer1ImgView.hidden = YES;
		_footer2ImgView.hidden = NO;
	
	} completion:^(BOOL finished){
		[UIView animateWithDuration:0.15 animations:^{
			_footer2ImgView.hidden = YES;
			_footer3ImgView.hidden = NO;
		}];
	}];
	*/
}

-(void)_goApps {
	[self.navigationController pushViewController:[[[DIAppListViewController alloc] init] autorelease] animated:YES];
}

-(void)_goOffers {
	[self.navigationController pushViewController:[[[DIOfferListViewController alloc] init] autorelease] animated:YES];
}

-(void)_goAchievements {
	
}


#pragma mark - Notification Handlers
-(void)_loadData:(NSNotification *)notification {
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	_activeChoresRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Rewards.php"]] retain];
	[_activeChoresRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
	[_activeChoresRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[_activeChoresRequest setDelegate:self];
	[_activeChoresRequest startAsynchronous];
	
	//_achievementsRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Achievements.php"]] retain];
	//[_achievementsRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
	//[_achievementsRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	//[_achievementsRequest setDelegate:self];
	//[_achievementsRequest startAsynchronous];
}

-(void)_addChore:(NSNotification *)notification {
	
	if (_isRewardList) {
		[_rewards insertObject:(DIChore *)[notification object] atIndex:0];	
		//[_myRewardsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
		
	} else {
		[_chores insertObject:(DIChore *)[notification object] atIndex:0];	
		//[_myChoresTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
	}
	
	//[_activeDisplay insertObject:(DIChore *)[notification object] atIndex:0];
	
	NSLog(@"ChoreListViewController - addChore:[]");
	
	//[_emptyScrollView removeFromSuperview];
	//[_holderView addSubview:_myChoresTableView];
	//[_holderView addSubview:_myRewardsTableView];
	
	//_emptyListImgView.hidden = YES;
	//_myChoresTableView.hidden = NO;
	//[_myChoresTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	//[_myRewardsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

	//[_myChoresTableView reloadData];
	//[_myRewardsTableView reloadData];
	
}


-(void)_finishChore:(NSNotification *)notification {
	DIChore *chore = (DIChore *)[notification object];
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	
	_userUpdRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
	[_userUpdRequest setPostValue:[NSString stringWithFormat:@"%d", 4] forKey:@"action"];
	[_userUpdRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[_userUpdRequest setPostValue:[NSString stringWithFormat:@"%d", chore.points] forKey:@"points"];
	[_userUpdRequest setDelegate:self];
	[_userUpdRequest startAsynchronous];
	
	_choreUpdRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Rewards.php"]] retain];
	[_choreUpdRequest setPostValue:[NSString stringWithFormat:@"%d", 6] forKey:@"action"];
	[_choreUpdRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[_choreUpdRequest setPostValue:[NSString stringWithFormat:@"%d", chore.chore_id] forKey:@"choreID"];
	
	[_finishedChores addObject:chore];
	
	if ([[NSUserDefaults standardUserDefaults] valueForKey:chore.imgPath]) {
		[[NSUserDefaults standardUserDefaults] setObject:nil forKey:chore.imgPath];
	}
	
	if (_isRewardList) {
		[_rewards removeObjectIdenticalTo:chore];
		//[_myRewardsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
		
	} else {
		[_chores removeObjectIdenticalTo:chore];
		//[_myChoresTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
	}
	
	//[_activeDisplay removeObjectIdenticalTo:chore];
	
	//[_myChoresTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	//[_myRewardsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
	//[_myChoresTableView reloadData];
	//[_myRewardsTableView reloadData];
	
	//if ([_activeDisplay count] == 0) {
		//[_myChoresTableView removeFromSuperview];
		//[_holderView addSubview:_emptyScrollView];
		//}
	
	//DIChoreCompleteViewController *choreCompleteViewController = [[[DIChoreCompleteViewController alloc] initWithChore:chore] autorelease];
	//UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:choreCompleteViewController] autorelease];
	//[self.navigationController presentModalViewController:navigationController animated:YES];
}


-(void)_addComment:(NSNotification *)notification {
	
	//DIChore *chore = ;
	
	int ind = 0;
	for (DIRewardItemViewController *viewController in _viewControllers) {
		if ([viewController.chore isEqual:(DIChore *)[notification object]]) {
			_viewControllerOffset = ind;
		}
		ind++;
	}
	
	NSLog(@"FOUND INDEX:[%d]", _viewControllerOffset);
	
	_rewardsScrollView.hidden = YES;
	_addCommentView.hidden = NO;
	
	_addCommentTxtView.text = @"";
	[_addCommentTxtView becomeFirstResponder];
}

#pragma mark - ScrollView Delegates
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	//int page = _sponsorshipsScrollView.contentOffset.x / 154;
	
	//[_paginationView updToPage:page];
	//NSLog(@"SCROLL PAGE:[(%f) %d]", _sponsorshipsScrollView.contentOffset.x, page);
}


#pragma mark - TextView Delegates
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	if([text isEqualToString:@"\n"]){
		[textView resignFirstResponder];
		_addCommentView.hidden = YES;
		_rewardsScrollView.hidden = NO;
		
		
		if ([textView.text length] > 0) {
			_itemOffset += 50;
			
			for (int i=_viewControllerOffset + 1; i<[_viewControllers count]; i++) {
				DIRewardItemViewController *viewController = [_viewControllers objectAtIndex:i];
				
				[UIView animateWithDuration:0.33 animations:^(void) {
					CGRect frame = viewController.view.frame;
					frame.origin.y += 50;
					viewController.view.frame = frame;	
				}];
			}
			
			_rewardsScrollView.contentSize = CGSizeMake(320, ([_viewControllers count] * 290) + _itemOffset);
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"ADDED_CHORE_COMMENT" object:textView.text];
		}
		return (NO);
	
	} else
		return (YES);
}

-(void)textViewDidEndEditing:(UITextView *)textView {
	//if ([textView.text length] == 0)
		//_commentInputLabel.hidden = NO;
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	NSLog(@"ChoreListViewController [_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	if ([request isEqual:_activeChoresRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			NSArray *parsedList = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				NSMutableArray *list = [NSMutableArray array];
				_viewControllers = [NSMutableArray new];
				
				for (NSDictionary *dict in parsedList) {
					DIChore *chore = [DIChore choreWithDictionary:dict];
					if (chore != nil) {
						NSLog(@"CHORE \"%@\" (%d)", chore.title, chore.type_id);
						
						[list addObject:chore];
						
						DIRewardItemViewController *rewardItemViewController = [[[DIRewardItemViewController alloc] initWithChore:chore] autorelease];
						[_viewControllers addObject:rewardItemViewController];
					}
				}
				
				int page = 0;
				if (_isRewardList) {
					for (DIRewardItemViewController *rewardViewController in _viewControllers) {
						rewardViewController.view.frame = CGRectMake(0.0, page * 290, 320, 290);
						[_rewardsScrollView addSubview:rewardViewController.view];
						page++;
					}
					
					_rewardsScrollView.contentSize = CGSizeMake(320, page * 290);
				
				} else {
				}
				
				if ([_viewControllers count] > 0) {
					[_emptyScrollView removeFromSuperview];
				}
			}			
		}
		
		[_loadOverlay remove];
	
	} else if ([request isEqual:_userUpdRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			NSDictionary *parsedUser = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				[DIAppDelegate setUserProfile:parsedUser];
				_pts2Label.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle];
				
				[UIView animateWithDuration:0.33 animations:^(void) {
					CGRect pts1Frame = _pts1Label.frame;
					pts1Frame.origin.y = -33;
					_pts1Label.frame = pts1Frame;
					
					CGRect pts2Frame = _pts2Label.frame;
					pts2Frame.origin.y = 0;
					_pts2Label.frame = pts2Frame;
					
				} completion:^(BOOL finished) {
					_pts1Label.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle];
					CGRect pts1Frame = _pts1Label.frame;
					pts1Frame.origin.y = 0;
					_pts1Label.frame = pts1Frame;
					
					CGRect pts2Frame = _pts2Label.frame;
					pts2Frame.origin.y = 33;
					_pts2Label.frame = pts2Frame;
				}];
				
				[_choreUpdRequest startAsynchronous];
			}
		}
		
		[_loadOverlay remove];
		
	} else if ([request isEqual:_choreUpdRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			//NSDictionary *parsedTotal = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				[_ptsButton setTitle:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle] forState:UIControlStateNormal];
			}
		}
		
		[_loadOverlay remove];
	}
	
	
	
	/*else if ([request isEqual:_achievementsRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			NSArray *parsedAchievements = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				NSMutableArray *achievementList = [NSMutableArray array];
				
				for (NSDictionary *serverAchievement in parsedAchievements) {
					DIChore *achievement = [DIChore choreWithDictionary:serverAchievement];
					
					if (achievement != nil)
						[achievementList addObject:achievement];
				}
				
				_achievements = [achievementList retain];
			}
		}
	}*/
}


-(void)requestFailed:(ASIHTTPRequest *)request {

	if (request == _activeChoresRequest) {
		//[_delegates perform:@selector(jobList:didFailLoadWithError:) withObject:self withObject:request.error];
		//MBL_RELEASE_SAFELY(_jobListRequest);
	}
	
	[_loadOverlay remove];
}

@end
