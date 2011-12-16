//
//  DIAddChoreViewController.h
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface DIAddChoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate> {
	
	NSMutableArray *_chores;
	UITableView *_myChoresTableView;
	
	ASIFormDataRequest *_availChoresDataRequest;
}

-(id)initWithChores:(NSMutableArray *)chores;

@end
