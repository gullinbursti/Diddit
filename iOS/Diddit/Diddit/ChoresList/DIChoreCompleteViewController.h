//
//  DIChoreCompleteViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIFormDataRequest.h"
#import "DIChore.h"

@class DILoadOverlayView;

@interface DIChoreCompleteViewController : UIViewController <ASIHTTPRequestDelegate> {
	DIChore *_chore;
	
	ASIFormDataRequest *_choreUpdRequest;
	ASIFormDataRequest *_userUpdRequest;
	
	UIButton *_pointsButton;
	UIButton *_finishedButton;
	
	DILoadOverlayView *_loadOverlayView;
}

-(id)initWithChore:(DIChore *)chore;
@end
