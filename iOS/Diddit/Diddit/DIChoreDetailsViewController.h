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

@interface DIChoreDetailsViewController : UIViewController <ASIHTTPRequestDelegate> {//<UITableViewDelegate, UITableViewDataSource> {

	UITableView *_appsTableView;
	UIImageView *_choreImgView;
	UIButton *_completeButton;
	
	DIChore *_chore;
}

-(id)initWithChore:(DIChore *)chore;

@end
