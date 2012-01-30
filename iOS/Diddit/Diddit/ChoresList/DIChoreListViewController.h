//
//  DIChoreListViewController.h
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@class DILoadOverlay;

@interface DIChoreListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate, UIScrollViewDelegate> {
	
	ASIFormDataRequest *_activeChoresRequest;
	ASIFormDataRequest *_choreUpdRequest;
	ASIFormDataRequest *_userUpdRequest;
	
	DILoadOverlay *_loadOverlay;
	
	UITableView *_myChoresTableView;
	UITableView *_myRewardsTableView;
	
	NSMutableArray *_activeDisplay;
	NSMutableArray *_chores;
	NSMutableArray *_rewards;
	NSMutableArray *_finishedChores;
	
	UIImageView *_emptyListImgView;
	UIImageView *_footerImgView;
	UIButton *_addBtn;
	
	UIView *_holderView;
	UIScrollView *_emptyScrollView;
	
	UIImageView *_badgesImgView;
	
	UIButton *_ptsButton;
	UIButton *_rewardsToggleButton;
	UIButton *_choresToggleButton;
	
	
	BOOL _isRewardList;
}

@end
