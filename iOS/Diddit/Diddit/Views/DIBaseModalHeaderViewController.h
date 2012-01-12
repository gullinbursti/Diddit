//
//  DIBaseModalHeaderViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIBaseHeaderViewController.h"

@interface DIBaseModalHeaderViewController : DIBaseHeaderViewController {
	NSString *_closeLbl;
}

-(id)initWithTitle:(NSString *)titleTxt header:(NSString *)headerTxt closeLabel:(NSString *)closeLbl;
-(void)loadBaseView;
@end
