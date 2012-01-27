//
//  DIAppTypeViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.24.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface DIAppTypeViewController : UIViewController <GKSessionDelegate, GKPeerPickerControllerDelegate> {
	GKSession *_syncSession;
	GKPeerPickerController *_syncPickerController;
	NSMutableArray *_syncClients;
}

@end
