//
//  DIConfirmChoreViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIChoreType.h"

@interface DIConfirmChoreViewController : UIViewController {
	
	DIChoreType *_choreType;
	UIButton *_assignButton;
}

-(id)initWithChoreType:(DIChoreType *)choreType;

@end
