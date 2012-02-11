//
//  DIStartupViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 02.02.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIStartupViewController.h"

#import "DIMasterListViewController.h"
#import "DISubListViewController.h"

@implementation DIStartupViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_goMasterList:) name:@"PRESENT_MASTER_LIST" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_goSubList:) name:@"PRESENT_SUB_LIST" object:nil];
	}
	
	return (self);
}


-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]] autorelease];
	[self.view addSubview:bgImgView];
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	[self.view addSubview:overlayImgView];
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidUnload {
    [super viewDidUnload];
}

-(void)dealloc {
	[super dealloc];
}

#pragma mark - Notifications
-(void)_goMasterList:(NSNotification *)notification {
	DIMasterListViewController *masterListViewController = [[[DIMasterListViewController alloc] init] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:masterListViewController] autorelease];
	[self.navigationController presentViewController:navigationController animated:NO completion:nil];	
}

-(void)_goSubList:(NSNotification *)notification {
	DISubListViewController *subListViewController = [[[DISubListViewController alloc] init] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:subListViewController] autorelease];
	[self.navigationController setNavigationBarHidden:NO];
	[self.navigationController presentViewController:navigationController animated:NO completion:nil];	
}
@end
