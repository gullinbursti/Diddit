//
//  DIOfferStatsView.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.21.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIOffer.h"

@interface DIOfferStatsView : UIView {
	DIOffer *_offer;
	UIView *_ptsView;
	UILabel *_ptsLbl;
}

-(id)initWithCoords:(CGPoint)pos offerVO:(DIOffer *)offer;

@end
