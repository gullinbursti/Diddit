//
//  DISplashVideoViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.06.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface DISplashVideoViewController : UIViewController {
	MPMoviePlayerController *_player;
	UIButton *_closeBtn;
}

@end
