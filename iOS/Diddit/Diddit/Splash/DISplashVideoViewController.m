//
//  DISplashVideoViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.06.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DISplashVideoViewController.h"

@implementation DISplashVideoViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[self.navigationController setNavigationBarHidden:YES animated:NO];
		
		[[MPMusicPlayerController applicationMusicPlayer] setVolume:1.0];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieStartedCallback:) name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:nil];
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor blackColor]];
	
	_player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Jurassic Park - Dodson & Nedry" ofType:@"mp4"]]];
	_player.controlStyle = MPMovieControlStyleNone;
	_player.view.frame = self.view.bounds;
	_player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_player.shouldAutoplay = YES;
	[_player setFullscreen:YES];
	[_player play];
	[self.view addSubview:_player.view];
	
	
	_closeBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_closeBtn.frame = CGRectMake(280, 10, 34, 34);
	[_closeBtn setBackgroundImage:[[UIImage imageNamed:@"videoButton_nonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[_closeBtn setBackgroundImage:[[UIImage imageNamed:@"videoButton_Active.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateHighlighted];
	[_closeBtn addTarget:self action:@selector(_goClose) forControlEvents:UIControlEventTouchUpInside];
	_closeBtn.alpha = 0.0;
	[self.view addSubview:_closeBtn];
	
	//[player setOrientation:UIDeviceOrientationPortrait animated:NO];
	//[self.view addSubview:player.view];
	[_player play];
	
	UIImageView *overlayImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]];
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

#pragma mark - Navigation
- (void)_goClose {
	_closeBtn.alpha = 0.0;
	[_player autorelease];
	
	[self dismissViewControllerAnimated:YES completion:nil];	
}


#pragma mark - Notification handlers
-(void)movieFinishedCallback:(NSNotification *)notification {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];    
	[_player autorelease];
	
	_closeBtn.alpha = 0.0;
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)movieStartedCallback:(NSNotification *)notification {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:nil];    
	
	[UIView animateWithDuration:1.0 animations:^{
		_closeBtn.alpha = 1.0;
	}];
}

@end
