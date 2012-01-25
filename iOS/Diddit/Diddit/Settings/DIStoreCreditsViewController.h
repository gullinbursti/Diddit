//
//  DIStoreCreditsViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.09.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIFormDataRequest.h"

@interface DIStoreCreditsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate> {
	UITableView *_creditsTableView;
	NSMutableArray *_credits;
	
	int _type_id;
}

-(id)initAsCredits;
-(id)initAsInAppGoods;

@end
