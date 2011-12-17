//
//  DIWelcomeViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.16.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIWelcomeViewController : UIViewController <UIScrollViewDelegate> {
	
	UIScrollView *_scrollView;
	UIButton *_closeButton;
	
	int _totSlides;
	int _curSlide;
	NSMutableArray *_splashImages;
}

@end
