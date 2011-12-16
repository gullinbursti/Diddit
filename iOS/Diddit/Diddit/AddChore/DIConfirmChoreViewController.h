//
//  DIConfirmChoreViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIChore.h"
#import "EGOImageView.h"

@interface DIConfirmChoreViewController : UIViewController {
	
	DIChore *_chore;
	EGOImageView *_imgView;
	UIButton *_assignButton;
}

-(id)initWithChore:(DIChore *)chore;

@end
