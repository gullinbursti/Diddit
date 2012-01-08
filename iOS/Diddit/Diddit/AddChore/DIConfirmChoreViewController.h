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

@interface DIConfirmChoreViewController : DIBasePushHeaderViewController <ASIHTTPRequestDelegate> {
	
	DIChore *_chore;
	UIButton *_submitButton;
}

-(id)initWithChore:(DIChore *)chore;

@end
