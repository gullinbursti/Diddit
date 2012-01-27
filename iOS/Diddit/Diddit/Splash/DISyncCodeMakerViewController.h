//
//  DISyncCodeMakerViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.24.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIFormDataRequest.h"

@class DILoadOverlay;

@interface DISyncCodeMakerViewController : UIViewController <ASIHTTPRequestDelegate> {
	UILabel *_digit1Label;
	UILabel *_digit2Label;
	UILabel *_digit3Label;
	
	DILoadOverlay *_loadOverlay;
	
	ASIFormDataRequest *_signupDataRequest;
	ASIFormDataRequest *_codeDataRequest;
}

@end
