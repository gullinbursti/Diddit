//
//  DIBaseHeaderViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIBaseHeaderViewController : UIViewController {
	NSString *_titleTxt;
	NSString *_headerTxt;
}

-(id)initWithTitle:(NSString *)titleTxt header:(NSString *)headerTxt;
@end
