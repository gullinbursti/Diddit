//
//  DIOfferVideoViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface DIOfferVideoViewController : UIViewController {
	
	NSString *_url;
	UIButton *_closeBtn;
	
	MPMoviePlayerController *_playerController;
}

-(id)initWithURL:(NSString *)url;
@end
