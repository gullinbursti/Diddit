//
//  DIAppDetailsViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIApp.h"
#import "DIPaginationView.h"

@interface DIAppDetailsViewController : UIViewController <UIScrollViewDelegate> {
	
	DIApp *_app;
	DIPaginationView *_paginationView;
	UIScrollView *_imgScrollView;
}

-(id)initWithApp:(DIApp *)app;

@end
