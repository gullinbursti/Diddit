//
//  DIOfferVideoViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIOfferVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "DIAppDelegate.h"

@implementation DIOfferVideoViewController

#pragma mark - View lifecycle
-(id)initWithOffer:(DIOffer *)offer {
	if ((self = [super init])) {
		_offer = offer;
		_url = _offer.video_url;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieStartedCallback:) name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:nil];
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

	//UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	//[self.view addSubview:overlayImgView];
}

-(void)viewDidLoad {	
	[super viewDidLoad];
}

-(void)viewDidUnload {
	[super viewDidUnload];
}

-(void)dealloc {
	[_url release];
	
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
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	ASIFormDataRequest *offerRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Offers.php"]] retain];
	[offerRequest setPostValue:[NSString stringWithFormat:@"%d", 2] forKey:@"action"];
	[offerRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[offerRequest setPostValue:[NSString stringWithFormat:@"%d", _offer.offer_id] forKey:@"offerID"];
	[offerRequest setDelegate:self];
	[offerRequest startAsynchronous];
}

-(void)movieStartedCallback:(NSNotification *)notification {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:nil];    
	
	[UIView animateWithDuration:1.0 animations:^{
		_closeBtn.alpha = 1.0;
	}];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	
	@autoreleasepool {
		NSError *error = nil;
		NSDictionary *parsedUser = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
		
		if (error != nil)
			NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
		
		else {
			[DIAppDelegate setUserProfile:parsedUser];
			[self dismissViewControllerAnimated:YES completion:^(void) {
				[[NSNotificationCenter defaultCenter] postNotificationName:@"OFFER_VIDEO_COMPLETE" object:_offer];
			}];
		}
	}
	
	[_loadOverlay remove];
}

-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
}


@end
