//
//  DIAppStatsView.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.12.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIApp.h"

@interface DIAppStatsView : UIView {
	DIApp *_app;
	UILabel *_ptsLbl;
}

@property (nonatomic, retain)UILabel *ptsLbl;

-(id)initWithCoords:(CGPoint)pos appVO:(DIApp *)app;
@end
