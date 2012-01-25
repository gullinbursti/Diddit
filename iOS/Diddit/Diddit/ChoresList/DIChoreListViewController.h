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
#import "EGOImageView.h"

@class DILoadOverlay;

@interface DIChoreListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate> {
	
	ASIFormDataRequest *_activeChoresRequest;
	ASIFormDataRequest *_sponsorshipsDataRequest;
	
	ASIFormDataRequest *_choreUpdRequest;
	ASIFormDataRequest *_userUpdRequest;
	
	DILoadOverlay *_loadOverlay;
	DIChoreStatsView *_choreStatsView;
	
	UITableView *_myChoresTableView;
	
	NSMutableArray *_chores;
	NSMutableArray *_finishedChores;
	
	EGOImageView *_sponsorshipImgView;
	NSMutableArray *_sponsorships;
	
	UIImageView *_emptyListImgView;
	UIImageView *_footerImgView;
	UIButton *_addBtn;
	
	UIView *_holderView;
	UIScrollView *_emptyScrollView;
	
	UIImageView *_badgesImgView;
}

@end
