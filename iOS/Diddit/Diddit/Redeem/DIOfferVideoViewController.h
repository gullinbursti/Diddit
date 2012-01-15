//
//  DIOfferVideoViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "DIOffer.h"

@interface DIOfferVideoViewController : UIViewController {
	
	DIOffer *_offer;
	
	NSString *_url;
	UIButton *_closeBtn;
	
	MPMoviePlayerController *_playerController;
}

-(id)initWithOffer:(DIOffer *)offer;
@end
