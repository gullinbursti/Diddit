//
//  DIOfferVideoViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIOfferVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation DIOfferVideoViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[MPMusicPlayerController applicationMusicPlayer] setVolume:1.0];
		[self.navigationController setNavigationBarHidden:YES animated:NO];
		
		//[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
		
		/*
		[[self view] setBounds:CGRectMake(0, 0, 480, 320)];
		[[self view] setCenter:CGPointMake(160, 240)];
		[[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
		*/
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieStartedCallback:) name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:nil];
	}
	
	return (self);
}

-(id)initWithURL:(NSString *)url {
	if ((self = [self init])) {
		_url = url;
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor blackColor]];

	_playerController = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:_url]];
	_playerController.controlStyle = MPMovieControlStyleNone;
	_playerController.view.frame = self.view.bounds;
	_playerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_playerController.shouldAutoplay = YES;
	[_playerController setFullscreen:YES];
	[_playerController play];
	[self.view addSubview:_playerController.view];
	
	_closeBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_closeBtn.frame = CGRectMake(440, 10, 34, 34);
	[_closeBtn setBackgroundImage:[[UIImage imageNamed:@"closeButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[_closeBtn setBackgroundImage:[[UIImage imageNamed:@"closeButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[_closeBtn addTarget:self action:@selector(_goClose) forControlEvents:UIControlEventTouchUpInside];
	_closeBtn.alpha = 0.0;
	[self.view addSubview:_closeBtn];

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
	[_playerController autorelease];
	
	[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Notification handlers
-(void)movieFinishedCallback:(NSNotification *)notification {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];    
	[_playerController autorelease];
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)movieStartedCallback:(NSNotification *)notification {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:nil];    
	
	[UIView animateWithDuration:1.0 animations:^{
		_closeBtn.alpha = 1.0;
	}];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}



@end
