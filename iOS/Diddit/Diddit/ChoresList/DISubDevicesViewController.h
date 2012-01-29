//
//  DISubDevicesViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.28.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "DILoadOverlay.h"

@interface DISubDevicesViewController : UIViewController <ASIHTTPRequestDelegate, UITableViewDataSource, UITableViewDelegate> {
	
	UITableView *_devicesTableView;
	NSMutableArray *_devices;
	DILoadOverlay *_loadOverlay;
	
	ASIFormDataRequest *_devicesDataRequest;
}

@end
