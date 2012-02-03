//
//  DIAppDelegate.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "DIAppDelegate.h"
#import "DIChore.h"
#import "DIMasterListViewController.h"
#import "DIAppTypeViewController.h"

#import "DIStoreObserver.h"
#import "UAirship.h"
#import "UAPush.h"

#import "MBProgressHUD.h"

@implementation DIAppDelegate

@synthesize window = _window;

+(DIAppDelegate *)sharedInstance {
	return ((DIAppDelegate *)[UIApplication sharedApplication].delegate);
}

//+(NSString *)deviceToken {
//	return ([[DIAppDelegate profileForUser] objectForKey:@"device_id"]);
//}

+(NSString *)deviceUUID {
	return ([UIDevice currentDevice].uniqueIdentifier);
}

+(BOOL)validateEmail:(NSString *)address {
	NSString *regex = @"[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?"; 
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex]; 
	
	return [predicate evaluateWithObject:address];
}

+(NSString *)md5:(NSString *)input {
	
	const char *cStr = [input UTF8String];
	unsigned char digest[16];
	
	CC_MD5(cStr, strlen(cStr), digest);
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	
	for(int i=0; i<CC_MD5_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", digest[i]];
	
	return (output);
}

+(NSString *)rndChars:(int)len {
	NSString *code = [[DIAppDelegate md5:[NSString stringWithFormat:@"%d", arc4random()]] uppercaseString];
	return ([code substringToIndex:[code length] - (32 - len)]);
}

+(void)setUserProfile:(NSDictionary *)userInfo {
	[[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"user_info"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDictionary *)profileForUser {
	return ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"]);
}

+(void)setUserPoints:(int)points {
	[[DIAppDelegate profileForUser] setValue:[NSNumber numberWithInt:points] forKey:@"points"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)userPoints {
	return ([[[DIAppDelegate profileForUser] objectForKey:@"points"] intValue]);
}

+(void)setUserTotalFinshed:(int)total {
	[[DIAppDelegate profileForUser] setValue:[NSNumber numberWithInt:total] forKey:@"finished"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)userTotalFinished {
	return ([[[DIAppDelegate profileForUser] objectForKey:@"finished"] intValue]);
}

+(void)setCompletedOffers:(NSDictionary *)offers {
	
}

+(NSDictionary *)completedOffers {
	return (nil);
}



+(void)notificationsToggle:(BOOL)isOn {
	NSString *bool_str;
	if (isOn)
		bool_str = [NSString stringWithString:@"YES"];
	
	else
		bool_str = [NSString stringWithString:@"NO"];
	
	[[NSUserDefaults standardUserDefaults] setObject:bool_str forKey:@"notifications"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)notificationsEnabled {
	return ([[[NSUserDefaults standardUserDefaults] objectForKey:@"notifications"] isEqualToString:@"YES"]);
}

+(void)setDeviceToken:(NSString *)token {
	[[NSUserDefaults standardUserDefaults] setObject:token forKey:@"device_token"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)deviceToken {
	return ([[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"]);
}

+(BOOL)isParentApp {
	return ([[[DIAppDelegate profileForUser] objectForKey:@"app_type"] isEqualToString:@"master"]);
}

+(NSArray *)childDevices {
	return ([[DIAppDelegate profileForUser] objectForKey:@"devices"]);
}


+(UIFont *)diAdelleFontRegular {
	return [UIFont fontWithName:@"Adelle" size:12.0];
}

+(UIFont *)diAdelleFontLight {
	return [UIFont fontWithName:@"Adelle-Light" size:12.0];
}

+(UIFont *)diAdelleFontSemibold {
	return [UIFont fontWithName:@"Adelle-SemiBold" size:12.0];
}

+(UIFont *)diAdelleFontBold {
	return [UIFont fontWithName:@"Adelle-Bold" size:12.0];
}

+(UIFont *)diAdelleFontBoldItalic {
	return [UIFont fontWithName:@"Adelle-BoldItalic" size:12.0];
}

+(UIFont *)diHelveticaNeueFontBold {
	return [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0];
}


//+(NSString *)userPinCode {
//	return ([[DIAppDelegate profileForUser] objectForKey:@"pin"]);
//}

#pragma mark - App Lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	//[DIAppDelegate setUserProfile:nil];
	
	
	if (![[NSUserDefaults standardUserDefaults] objectForKey:@"notifications"] || [DIAppDelegate notificationsEnabled]) {
		[DIAppDelegate notificationsToggle:YES];
		
		// init Airship launch options
		NSMutableDictionary *takeOffOptions = [[[NSMutableDictionary alloc] init] autorelease];
		[takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
		
		// create Airship singleton that's used to talk to Urban Airhship servers, populate AirshipConfig.plist with your info from http://go.urbanairship.com
		[UAirship takeOff:takeOffOptions];	
		[[UAPush shared] resetBadge];//zero badge on startup
		[[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
	}
	
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	[[SKPaymentQueue defaultQueue] addTransactionObserver:[[DIStoreObserver alloc] init]];
	
	_startupViewController = [[DIStartupViewController alloc] init];
	
	[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"headerBG.png"] forBarMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[[UIImage imageNamed:@"headerButton_nonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:14] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackButtonBackgroundImage:[[UIImage imageNamed:@"headerBackButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[[UIImage imageNamed:@"headerButton_Active.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:14] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackButtonBackgroundImage:[[UIImage imageNamed:@"headerBackButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0], UITextAttributeFont, nil] forState:UIControlStateSelected];
	
	UINavigationController *rootNavigationController = [[[UINavigationController alloc] initWithRootViewController:_startupViewController] autorelease];
	[rootNavigationController setNavigationBarHidden:YES];
	
	[self.window setRootViewController:rootNavigationController];
	[self.window makeKeyAndVisible];
	
	// show welcome screen
	if (![DIAppDelegate profileForUser]) {
		DIAppTypeViewController *splash = [[[DIAppTypeViewController alloc] init] autorelease];
		UINavigationController *splashNavigation = [[[UINavigationController alloc] initWithRootViewController:splash] autorelease];
		[splashNavigation setNavigationBarHidden:NO animated:YES];
		[rootNavigationController presentModalViewController:splashNavigation animated:NO];
		
	} else {
		_loadOverlay = [[DILoadOverlay alloc] init];
		
		_userRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
		[_userRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
		[_userRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[_userRequest setPostValue:[DIAppDelegate deviceToken] forKey:@"uaID"];
		[_userRequest setDelegate:self];
		[_userRequest startAsynchronous];
	}
	
	/*
	 NSLog(@"DEVICE ID:[%@]", [[DIAppDelegate profileForUser] objectForKey:@"device_id"]);
	 NSLog(@"DEVICE NAME:[%@]", [UIDevice currentDevice].name);
	 NSLog(@"DEVICE MODEL:[%@]", [UIDevice currentDevice].model);
	 NSLog(@"SYS NAME:[%@]", [UIDevice currentDevice].systemName);
	 NSLog(@"SYS VER:[%@]", [UIDevice currentDevice].systemVersion);
	 NSLog(@"UUID:[%@]", [UIDevice currentDevice].uniqueIdentifier);
	 */
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	/*
	 // Schedule a test notification
	 UILocalNotification *localNotification = [[[UILocalNotification alloc] init] autorelease];
	 localNotification.fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:5];
	 localNotification.alertBody = @"BACKGROUNDED!";
	 localNotification.soundName = UILocalNotificationDefaultSoundName;
	 localNotification.applicationIconBadgeNumber = 1;
	 
	 NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Object 1", @"Key 1", @"Object 2", @"Key 2", nil];
	 localNotification.userInfo = infoDict;
	 
	 [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
	 */
	
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


#pragma mark - ASI Delegates
- (void)requestFinished:(ASIHTTPRequest *)request { 
	
	NSLog(@"AppDelegate [_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	if ([request isEqual:_userRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			NSDictionary *parsedUser = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				[DIAppDelegate setUserProfile:parsedUser];
				[_startupViewController.navigationController setNavigationBarHidden:NO];
				
				if ([DIAppDelegate isParentApp])
					[_startupViewController.navigationController pushViewController:[[[DIMasterListViewController alloc] init] autorelease] animated:NO];
				
				else
					[_startupViewController.navigationController pushViewController:[[[DISubListViewController alloc] init] autorelease] animated:NO];
				//[[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_CHORE_LIST" object:nil];
			}
		}
	}
	
	[_loadOverlay remove];
}


- (void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	UALOG(@"APN device token: %@", deviceToken);
	// Updates the device token and registers the token with UA
	[[UAPush shared] registerDeviceToken:deviceToken];
	
	NSString *deviceID = [[deviceToken description] substringFromIndex:1];
	deviceID = [deviceID substringToIndex:[deviceID length] - 1];
	deviceID = [deviceID stringByReplacingOccurrencesOfString:@" " withString:@""];
	[DIAppDelegate setDeviceToken:deviceID];
	
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
	
	//[UAPush shared].delegate = self;
	
	int type_id = [[userInfo objectForKey:@"type"] intValue];
	NSLog(@"TYPE: [%d]", type_id);
	
	switch (type_id) {
		case 1:
			[[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_CHORE_LIST" object:nil];
			break;
			
		case 2:
			[[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_CHORE_LIST" object:nil];
			break;
	}
	/*
	 if (type_id == 2) {
	 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Leaving diddit" message:@"Your iTunes gift card number has been copied" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:@"Visit iTunes", nil];
	 [alert show];
	 [alert release];
	 
	 NSString *redeemCode = [[DIAppDelegate md5:[NSString stringWithFormat:@"%d", arc4random()]] uppercaseString];
	 redeemCode = [redeemCode substringToIndex:[redeemCode length] - 12];
	 
	 UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	 [pasteboard setValue:redeemCode forPasteboardType:@"public.utf8-plain-text"];
	 }
	 
	 UILocalNotification *localNotification = [[[UILocalNotification alloc] init] autorelease];
	 localNotification.fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:5];
	 localNotification.alertBody = [NSString stringWithFormat:@"%d", [[userInfo objectForKey:@"type"] intValue]];;
	 localNotification.soundName = UILocalNotificationDefaultSoundName;
	 localNotification.applicationIconBadgeNumber = 3;
	 
	 NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Object 1", @"Key 1", @"Object 2", @"Key 2", nil];
	 localNotification.userInfo = infoDict;
	 
	 [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
	 */
}

-(void)displayNotificationAlert:(NSString *)alertMessage {
	
}



@end
