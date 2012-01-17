//
//  DIOfferVideoViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "ASIFormDataRequest.h"
#import "DIOffer.h"
#import "DILoadOverlay.h"

@interface DIOfferVideoViewController : UIViewController <ASIHTTPRequestDelegate> {
	
	DIOffer *_offer;
	DILoadOverlay *_loadOverlay;
	
	NSString *_url;
	UIButton *_closeBtn;
	
	MPMoviePlayerController *_playerController;
}

-(id)initWithOffer:(DIOffer *)offer;
@end
