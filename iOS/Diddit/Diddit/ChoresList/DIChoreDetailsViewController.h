//
//  DIChoreDetailsViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIFormDataRequest.h"
#import "DIChore.h"

@interface DIChoreDetailsViewController : UIViewController <ASIHTTPRequestDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

	UITableView *_appsTableView;
	UIImageView *_imgView;
	UIButton *_completeButton;
	
	UIScrollView *_scrollView;
	CGSize _textSize;
	
	ASIFormDataRequest *_updUserRequest;
	
	DIChore *_chore;
	BOOL _isCameraPic;
}

-(id)initWithChore:(DIChore *)chore;

@end
