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
	
	UIButton *_activeChoresButton;
	UITableView *_myChoresTableView;
	
	int _myPoints;
	
	NSMutableArray *_chores;
	NSMutableArray *_availChores;
	NSMutableArray *_finishedChores;
	NSMutableArray *_achievements;
	
	ASIFormDataRequest *_userRequest;
	ASIFormDataRequest *_availChoresRequest;
	ASIFormDataRequest *_achievementsRequest;
	
	UIButton *_takenChoresButton;
	
	UIView *_footerView;
	UIButton *_myChoresButton;
	UIButton *_addChoreButton;
	UIButton *_settingsButton;
}


-(id)initWithChores:(NSMutableArray *)chores;



@end
