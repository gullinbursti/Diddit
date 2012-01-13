//
//  DIAppRatingStarsView.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.12.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIAppRatingStarsView : UIView {
	int _score;
}

-(id)initWithCoords:(CGPoint)pos appScore:(int)score;
-(id)initWithScore:(int)score;

@end
