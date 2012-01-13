//
//  DIConfirmChoreViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIBasePushHeaderViewController.h"

#import "DIChore.h"
#import "ASIFormDataRequest.h"
#import "EGOImageView.h"

@class DILoadOverlay;

@interface DIConfirmChoreViewController : DIBasePushHeaderViewController <ASIHTTPRequestDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	
	BOOL _isCameraPic;
	DIChore *_chore;
	UIButton *_submitButton;
	EGOImageView *_imgView;
	UIButton *_choreThumbBtn;
	UIScrollView *_scrollView;
	CGSize _textSize;
	
	DILoadOverlay *_loadOverlay;
}

-(id)initWithChore:(DIChore *)chore;

@end
