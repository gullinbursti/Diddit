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

@implementation DIAppDelegate

@synthesize window = _window;

#pragma mark - App Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	
	NSString *testChoresPath = [[NSBundle mainBundle] pathForResource:@"test_chores" ofType:@"plist"];
	NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:testChoresPath] options:NSPropertyListImmutable format:nil error:nil];
	
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
	[pool release];
} 



@end
