//
//  DIAppDetailsViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIApp.h"

@interface DIAppDetailsViewController : UIViewController {
	DIApp *_app;
}

-(id)initWithApp:(DIApp *)app;

@end
