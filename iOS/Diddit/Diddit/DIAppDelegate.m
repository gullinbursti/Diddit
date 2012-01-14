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
#import "DISettingsViewController.h"
#import "DIWelcomeViewController.h"

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


+(BOOL)validateEmail:(NSString *)address {
	NSString *regex = @"[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?"; 
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex]; 
	
	return [predicate evaluateWithObject:address];
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

+(NSString *)md5:(NSString *)input {
	
	const char *cStr = [input UTF8String];
	unsigned char digest[16];
	
	CC_MD5(cStr, strlen(cStr), digest);
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	
	for(int i=0; i<CC_MD5_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", digest[i]];
	
	return (output);
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
	
	_choreListViewController = [[DIChoreListViewController alloc] init];
	UINavigationController *rootNavigationController = [[[UINavigationController alloc] initWithRootViewController:_choreListViewController] autorelease];
	[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"headerBG.png"] forBarMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[[UIImage imageNamed:@"headerButton_nonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:14] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackButtonBackgroundImage:[[UIImage imageNamed:@"headerBackButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[[UIImage imageNamed:@"headerButton_Active.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:14] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackButtonBackgroundImage:[[UIImage imageNamed:@"headerBackButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0], UITextAttributeFont, nil] forState:UIControlStateNormal];
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0], UITextAttributeFont, nil] forState:UIControlStateSelected];
	
	[self.window setRootViewController:rootNavigationController];
	[self.window makeKeyAndVisible];
	
	
	// show welcome screen
	if (![DIAppDelegate profileForUser]) {
		DIWelcomeViewController *splash = [[[DIWelcomeViewController alloc] init] autorelease];
		UINavigationController *splashNavigation = [[[UINavigationController alloc] initWithRootViewController:splash] autorelease];
		[splashNavigation setNavigationBarHidden:YES animated:NO];
		[rootNavigationController presentModalViewController:splashNavigation animated:NO];
	
	} else {
		_loadOverlay = [[DILoadOverlay alloc] init];
		
		_userRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
		[_userRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
		[_userRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[_userRequest setDelegate:self];
		[_userRequest startAsynchronous];
	}
	
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
				//[[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISS_WELCOME_SCREEN" object:nil];
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
}



@end
