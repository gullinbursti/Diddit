//
//  DIAchievementsViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIAchievementsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	
	NSMutableArray *_chores;
	UITableView *_achievementTable;
	
}


-(id)initWithChores:(NSMutableArray *)chores;

@end
