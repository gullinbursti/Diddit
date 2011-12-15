//
//  DIChoreListViewController.h
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIChoreListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	
	UILabel *_headerLabel;
	UILabel *_emptyLabel;
	
	UIButton *_activeChoresButton;
	UITableView *_myChoresTableView;
	
	NSMutableArray *_chores;
	NSMutableArray *_availChores;
	NSMutableArray *_finishedChores;
	
	UIButton *_takenChoresButton;
	
	UIView *_footerView;
	UIButton *_myChoresButton;
	UIButton *_addChoreButton;
	UIButton *_settingsButton;
}


-(id)initWithChores:(NSMutableArray *)chores;



@end
