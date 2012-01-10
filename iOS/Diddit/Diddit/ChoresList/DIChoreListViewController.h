//
//  DIChoreListViewController.h
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface DIChoreListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate> {
	
	UILabel *_headerLabel;
	UILabel *_emptyLabel;
	
	UITableView *_myChoresTableView;
	
	NSMutableArray *_chores;
	NSMutableArray *_finishedChores;
	NSMutableArray *_achievements;
	
	ASIFormDataRequest *_activeChoresRequest;
	ASIFormDataRequest *_achievementsRequest;
	
	//UIView *_footerView;
	//UIButton *_addChoreButton;
	//UIButton *_settingsButton;
	
	UIButton *_addBtn;
}

@end
