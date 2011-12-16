//
//  DIChorePriceViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIFormDataRequest.h"
#import "DIChore.h"


@interface DIChorePriceViewController : UIViewController <UIAlertViewDelegate, ASIHTTPRequestDelegate> {
	DIChore *_chore;
	UIButton *_purchaseButton;
	
	UILabel *_label;
	UISlider *_slider;
}

-(id)initWithChore:(DIChore *)chore;

@end
