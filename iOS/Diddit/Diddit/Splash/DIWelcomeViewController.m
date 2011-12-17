//
//  DIWelcomeViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.16.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import "DIWelcomeViewController.h"

#import "DISignupViewController.h"

@implementation DIWelcomeViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_dismissMe:) name:@"DISMISS_WELCOME_SCREEN" object:nil];
		
		_totSlides = 3;
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
	
	_scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_scrollView.delegate = self;
	_scrollView.opaque = NO;
	_scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * _totSlides, self.view.bounds.size.height);
	_scrollView.pagingEnabled = YES;
	_scrollView.scrollsToTop = NO;
	_scrollView.showsHorizontalScrollIndicator = YES;
	_scrollView.showsVerticalScrollIndicator = NO;
	_scrollView.alwaysBounceVertical = NO;
	[self.view addSubview:_scrollView];
	
	
	for (int i=1; i<=_totSlides; i++) {
		NSLog(@"IMAGE:[%@]", [NSString stringWithFormat:@"welcome%02d.jpg", i]);
		UIImageView *imgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"welcome%02d.jpg", i]]] autorelease];
		CGRect frame = imgView.frame;
		frame.origin.x = 24 + (self.view.bounds.size.width * (i - 1));
		frame.origin.y = 120.0;
		imgView.frame = frame;
		[_scrollView addSubview:imgView];
	}
	
	_closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_closeButton.frame = CGRectMake(32, 375, 256, 32);
	//_closeButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
	_closeButton.titleEdgeInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
	[_closeButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButton.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[_closeButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButtonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:7] forState:UIControlStateHighlighted];
	[_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_closeButton setTitle:@"Sign Me Up!" forState:UIControlStateNormal];
	[_closeButton addTarget:self action:@selector(_goSignup) forControlEvents:UIControlEventTouchUpInside];
	_closeButton.hidden = YES;
	[self.view addSubview:_closeButton];
}

-(void)viewDidLoad {
	[super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

-(void)viewDidUnload {
	[super viewDidUnload];
}

-(void)dealloc {
	[super dealloc];
}


#pragma mark - Navigation
- (void)_goBack {
	[self dismissViewControllerAnimated:YES completion:nil];	
}

- (void)_goSignup {
	//[self dismissViewControllerAnimated:YES completion:nil];
	
	DISignupViewController *signupViewController = [[[DISignupViewController alloc] init] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:signupViewController] autorelease];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}


#pragma mark - Notification Handlers
-(void)_dismissMe:(NSNotification *)notification {
	[self _goBack];
}



#pragma mark - ScrollView Delegates
- (void)scrollViewDidScroll:(UIScrollView *)sender {	
	_curSlide = (_scrollView.contentOffset.x / _scrollView.bounds.size.width) + 1;
	_closeButton.hidden = YES;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	NSLog(@"CURRENT SLIDE:%d", _curSlide);
	
	_closeButton.hidden = !(_curSlide == _totSlides);
}

@end
