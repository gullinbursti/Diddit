//
//  DIAddNewRewardViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.31.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import "ASIFormDataRequest.h"

#import "DIChore.h"
#import "DILoadOverlay.h"
#import "DIDevice.h"
#import "DIPricePak.h"

@interface DIAddNewRewardViewController : UIViewController <SKProductsRequestDelegate, UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate, ASIHTTPRequestDelegate> {
	DILoadOverlay *_loadOverlay;
	
	ASIFormDataRequest *_iapPakRequest;
	ASIFormDataRequest *_addChoreDataRequest;
	
	NSMutableArray *_iapPaks;
	NSMutableArray *_pricePakViews;
	
	DIChore *_chore;
	DIDevice *_device;
	DIPricePak *_pricePak;
	
	int _type_id;
	int _points;
	int _cost;
	
	UILabel *_titleLabel;
	UILabel *_commentLabel;
	
	UILabel *_titleInputLabel;
	UITextField *_titleInputTxtField;
	
	UILabel *_commentInputLabel;
	UITextView *_commentInputTxtView;
	
	UIView *_holderView;
	UIView *_txtInputView;
}

-(id)initWithDevice:(DIDevice *)device;

@end
