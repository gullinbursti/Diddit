//
//  DIAppDelegate.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import "DIAppDelegate.h"

#import "DIChore.h"
#import "DISettingsViewController.h"

#import "UAirship.h"
#import "UAPush.h"

@implementation DIAppDelegate

@synthesize window = _window;

+ (DIAppDelegate *)sharedInstance {
	return ((DIAppDelegate *)[UIApplication sharedApplication].delegate);
}

#pragma mark - App Lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	//Init Airship launch options
	NSMutableDictionary *takeOffOptions = [[[NSMutableDictionary alloc] init] autorelease];
	[takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
	
	// Create Airship singleton that's used to talk to Urban Airhship servers.
	// Please populate AirshipConfig.plist with your info from http://go.urbanairship.com
	[UAirship takeOff:takeOffOptions];	
	[[UAPush shared] resetBadge];//zero badge on startup
	[[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
																		  UIRemoteNotificationTypeSound |
																		  UIRemoteNotificationTypeAlert)];
	
	//NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test_chores" ofType:@"plist"]] options:NSPropertyListImmutable format:nil error:nil];
	_chores = [[NSMutableArray alloc] init];
	
	ASIFormDataRequest *activeChoresRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
	[activeChoresRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
	[activeChoresRequest setPostValue:[NSString stringWithFormat:@"%d", 2] forKey:@"userID"];
	[activeChoresRequest setDelegate:self];
	[activeChoresRequest startAsynchronous];
	
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	[self.window makeKeyAndVisible];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}


-(void)dealloc {
	[super dealloc];
}


#pragma mark - Subviews

-(void)showSettingsScreen {
	DISettingsViewController *settingsViewController = [[[DISettingsViewController alloc] init] autorelease];
	UINavigationController *settingsNavigationController = [[[UINavigationController alloc] initWithRootViewController:settingsViewController] autorelease];
	
	[settingsNavigationController pushViewController:settingsViewController animated:YES];
}


#pragma mark - ASI Delegates
- (void)requestFinished:(ASIHTTPRequest *)request { 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	@autoreleasepool {
		NSError *error = nil;
		NSArray *parsedChores = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
		if (error != nil) {
			NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
		}
		else {
			NSMutableArray *choreList = [NSMutableArray array];
			
			for (NSDictionary *serverChore in parsedChores) {
				DIChore *chore = [DIChore choreWithDictionary:serverChore];
				
				if (chore != nil)
					[choreList addObject:chore];
			}
			
			_chores = [choreList retain];
			
			_choreListViewController = [[DIChoreListViewController alloc] initWithChores:_chores];
			UINavigationController *rootNavigationController = [[[UINavigationController alloc] initWithRootViewController:_choreListViewController] autorelease];
			[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
			
			[self.window setRootViewController:rootNavigationController];
			
			//[choreList sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO]]];
			
		}
	}
	
	[pool release];
}


- (void)requestFailed:(ASIHTTPRequest *)request {
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	UALOG(@"APN device token: %@", deviceToken);
	// Updates the device token and registers the token with UA
	[[UAPush shared] registerDeviceToken:deviceToken];
	
	
	/*
	 * Some example cases where user notifcation may be warranted
	 *
	 * This code will alert users who try to enable notifications
	 * from the settings screen, but cannot do so because
	 * notications are disabled in some capacity through the settings
	 * app.
	 * 
	 */
	
	/*
    
    //Do something when notifications are disabled altogther
    if ([application enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) {
	 UALOG(@"iOS Registered a device token, but nothing is enabled!");
	 
	 //only alert if this is the first registration, or if push has just been
	 //re-enabled
	 if ([UAirship shared].deviceToken != nil) { //already been set this session
	 NSString* okStr = @"OK";
	 NSString* errorMessage =
	 @"Unable to turn on notifications. Use the \"Settings\" app to enable notifications.";
	 NSString *errorTitle = @"Error";
	 UIAlertView *someError = [[UIAlertView alloc] initWithTitle:errorTitle
	 message:errorMessage
	 delegate:nil
	 cancelButtonTitle:okStr
	 otherButtonTitles:nil];
	 
	 [someError show];
	 [someError release];
	 }
	 
    //Do something when some notification types are disabled
    } else if ([application enabledRemoteNotificationTypes] != [UAPush shared].notificationTypes) {
	 
	 UALOG(@"Failed to register a device token with the requested services. Your notifications may be turned off.");
	 
	 //only alert if this is the first registration, or if push has just been
	 //re-enabled
	 if ([UAirship shared].deviceToken != nil) { //already been set this session
	 
	 UIRemoteNotificationType disabledTypes = [application enabledRemoteNotificationTypes] ^ [UAPush shared].notificationTypes;
	 
	 
	 
	 NSString* okStr = @"OK";
	 NSString* errorMessage = [NSString stringWithFormat:@"Unable to turn on %@. Use the \"Settings\" app to enable these notifications.", [UAPush pushTypeString:disabledTypes]];
	 NSString *errorTitle = @"Error";
	 UIAlertView *someError = [[UIAlertView alloc] initWithTitle:errorTitle
	 message:errorMessage
	 delegate:nil
	 cancelButtonTitle:okStr
	 otherButtonTitles:nil];
	 
	 [someError show];
	 [someError release];
	 }
    }
	 
	 */
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
	UALOG(@"Failed To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	UALOG(@"Received remote notification: %@", userInfo);
	
	// Get application state for iOS4.x+ devices, otherwise assume active
	UIApplicationState appState = UIApplicationStateActive;
	if ([application respondsToSelector:@selector(applicationState)]) {
		appState = application.applicationState;
	}
	
	[[UAPush shared] handleNotification:userInfo applicationState:appState];
	[[UAPush shared] resetBadge]; // zero badge after push received
}



@end
