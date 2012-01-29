//
//  DIAddChoreDeviceViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.28.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIChore.h"
#import "ASIFormDataRequest.h"
#import "DILoadOverlay.h"

@interface DIAddChoreDeviceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate> {
	UITableView *_devicesTableView;
	NSMutableArray *_devices;
	DILoadOverlay *_loadOverlay;
	
	ASIFormDataRequest *_devicesDataRequest;
	DIChore *_chore;
	
	NSMutableString *_devicesSelected;
}

-(id)initWithChore:(DIChore *)chore;

@end
