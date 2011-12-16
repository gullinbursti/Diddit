//
//  DIAddCustomChoreViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.15.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIFormDataRequest.h"

@interface DIAddCustomChoreViewController : UIViewController <ASIHTTPRequestDelegate> {
	
	UITextField *_titleTxtField;
	UITextField *_icoTxtField;
	UITextField *_imgTxtField;
}

@end
