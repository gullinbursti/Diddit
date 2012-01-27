//
//  DIChoreListViewController.h
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "DIChoreStatsView.h"
#import "DIPaginationView.h"

@class DILoadOverlay;

@interface DIChoreListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate, UIScrollViewDelegate> {
	
	ASIFormDataRequest *_activeChoresRequest;
	ASIFormDataRequest *_sponsorshipsDataRequest;
	
	ASIFormDataRequest *_choreUpdRequest;
	ASIFormDataRequest *_userUpdRequest;
	
	DILoadOverlay *_loadOverlay;
	DIChoreStatsView *_choreStatsView;
	DIPaginationView *_paginationView;
	
	UITableView *_myChoresTableView;
	
	NSMutableArray *_chores;
	NSMutableArray *_finishedChores;
	NSMutableArray *_sponsorships;
	
	UIImageView *_emptyListImgView;
	UIImageView *_footerImgView;
	UIButton *_addBtn;
	
	UIView *_holderView;
	UIScrollView *_emptyScrollView;
	
	UIImageView *_badgesImgView;
	
	UIView *_sponsorshipHolderView;
	UIScrollView *_sponsorshipsScrollView;
}

@end
