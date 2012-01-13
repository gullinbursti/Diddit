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
}

-(id)initWithCoords:(CGPoint)pos appVO:(DIApp *)app;
@end