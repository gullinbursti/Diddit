//
//  DIChoreListViewController.h
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIChoreListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	
	UITableView *_myChoresTableView;
	NSMutableArray *_chores;
	
	UILabel *_headerLabel;
	
	
	UIButton *_activeChoresButton;
	UIButton *_takenChoresButton;
	
	UIView *_footerView;
	UIButton *_myChoresButton;
	UIButton *_addChoreButton;
	UIButton *_settingsButton;
}


-(id)initWithChores:(NSMutableArray *)chores;



@end
