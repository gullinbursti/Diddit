//
//  DIAppDelegate.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DIAppDelegate.h"

#import "DIChore.h"
#import "DISettingsViewController.h"

@implementation DIAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	
	NSString *testJobsPath = [[NSBundle mainBundle] pathForResource:@"chores" ofType:@"plist"];
	NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:testJobsPath] options:NSPropertyListImmutable format:nil error:nil];
	
	NSMutableArray *chores = [[NSMutableArray alloc] init];
	for (NSDictionary *dict in plist)
		[chores addObject:[DIChore choreWithDictionary:dict]];
	
	
	ASIFormDataRequest *asiFormRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/oddjob/services/Jobs.php"]] retain];
	[asiFormRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
	[asiFormRequest setPostValue:[NSString stringWithFormat:@"%d", 660042243] forKey:@"fbid"];
	[asiFormRequest setDelegate:self];
	[asiFormRequest startAsynchronous];
	
	
	_choreListViewController = [[DIChoreListViewController alloc] initWithChores:chores];
	UINavigationController *rootNavigationController = [[[UINavigationController alloc] initWithRootViewController:_choreListViewController] autorelease];
	[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
	
	[self.window setRootViewController:rootNavigationController];
	[self.window makeKeyAndVisible];
	
	
	// Override point for customization after application launch.
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

-(void)showSettingsScreen {
	DISettingsViewController *settingsViewController = [[[DISettingsViewController alloc] init] autorelease];
	UINavigationController *settingsNavigationController = [[[UINavigationController alloc] initWithRootViewController:settingsViewController] autorelease];
	
	[settingsNavigationController pushViewController:settingsViewController animated:YES];
}


#pragma mark ASI Result
- (void)requestFinished:(ASIHTTPRequest *)request { 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	[pool release];
} 


-(void)dealloc {
	[super dealloc];
}

@end
