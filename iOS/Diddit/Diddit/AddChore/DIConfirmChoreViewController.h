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

@class DILoadOverlayView;

@interface DIConfirmChoreViewController : DIBasePushHeaderViewController <ASIHTTPRequestDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	
	DIChore *_chore;
	UIButton *_submitButton;
	EGOImageView *_imgView;
	UIButton *_choreThumbBtn;
	
	DILoadOverlayView *_loadOverlayView;
}

-(id)initWithChore:(DIChore *)chore;

@end
