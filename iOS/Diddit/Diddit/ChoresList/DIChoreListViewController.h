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

@class DILoadOverlay;

@interface DIChoreListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate> {
	
	ASIFormDataRequest *_activeChoresRequest;
	DILoadOverlay *_loadOverlay;
	DIChoreStatsView *_choreStatsView;
	
	UITableView *_myChoresTableView;
	
	NSMutableArray *_chores;
	NSMutableArray *_finishedChores;
	
	UIImageView *_emptyListImgView;
	UIImageView *_footerImgView;
	UIButton *_addBtn;
	
}

@end
