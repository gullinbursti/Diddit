//
//  DISponsorshipItemButton.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.26.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "DISponsorship.h"
#import "EGOImageView.h"

@interface DISponsorshipItemButton : UIButton {
	DISponsorship *_sponsorship;
	EGOImageView *_imgView;
	int _ind;
}

-(id)initWithSponsorship:(DISponsorship *)sponsorship AtIndex:(int)ind;

@end
