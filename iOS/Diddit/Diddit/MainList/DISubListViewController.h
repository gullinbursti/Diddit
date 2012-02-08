//
//  DISubListViewController.h
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@class DILoadOverlay;

@interface DISubListViewController : UIViewController <ASIHTTPRequestDelegate, UIScrollViewDelegate, UITextViewDelegate> {
	
	ASIFormDataRequest *_activeChoresRequest;
	ASIFormDataRequest *_choreUpdRequest;
	ASIFormDataRequest *_userUpdRequest;
	
	DILoadOverlay *_loadOverlay;
	
	NSMutableArray *_viewControllers;
	NSMutableArray *_chores;
	NSMutableArray *_rewards;
	NSMutableArray *_finishedChores;
	
	UIImageView *_emptyListImgView;
	UIImageView *_footerImgView;
	
	UIView *_holderView;
	UIScrollView *_emptyScrollView;
	UIScrollView *_rewardsScrollView;
	UIScrollView *_choresScrollView;
	
	UIButton *_ptsButton;
	UIButton *_rewardsToggleButton;
	UIButton *_choresToggleButton;
	
	UILabel *_pts1Label;
	UILabel *_pts2Label;
	
	UIView *_addCommentView;
	UITextView *_addCommentTxtView;
	
	BOOL _isRewardList;
	int _itemOffset;
	int _viewControllerOffset;
}

@end
