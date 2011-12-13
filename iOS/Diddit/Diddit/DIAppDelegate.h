//
//  DIAppDelegate.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIChoreListViewController.h"
#import "ASIFormDataRequest.h"

@interface DIAppDelegate : UIResponder <UIApplicationDelegate, ASIHTTPRequestDelegate> {
	
	DIChoreListViewController *_choreListViewController;
}

@property (strong, nonatomic) UIWindow *window;


-(void)showSettingsScreen;

@end
