//
//  DIChoreListViewController.h
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@class DILoadOverlayView;

@interface DIChoreListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate> {
	
	UILabel *_headerLabel;
	UILabel *_emptyLabel;
	
	UITableView *_myChoresTableView;
	
	NSMutableArray *_chores;
	NSMutableArray *_finishedChores;
	NSMutableArray *_achievements;
	
	ASIFormDataRequest *_activeChoresRequest;
	ASIFormDataRequest *_achievementsRequest;
	
	UIImageView *_footer1ImgView;
	UIImageView *_footer2ImgView;
	UIImageView *_footer3ImgView;

	
	//UIView *_footerView;
	//UIButton *_addChoreButton;
	//UIButton *_settingsButton;
	
	UIButton *_addBtn;
	
	DILoadOverlayView *_loadOverlayView;
}

@end
