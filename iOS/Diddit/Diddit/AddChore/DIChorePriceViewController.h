//
//  DIChorePriceViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "ASIFormDataRequest.h"
#import "DIChore.h"
#import "EGOImageView.h"



@interface DIChorePriceViewController : UIViewController <SKProductsRequestDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate> {
	DIChore *_chore;
	UIButton *_purchaseButton;
	EGOImageView *_imgView;
	
	UILabel *_label;
	UISlider *_slider;
	
	
	NSMutableArray *productIdentifierList;  
	NSMutableArray *productDetailsList; 
	UITableView *productDisplayTableView;
}

@property(nonatomic, retain) NSMutableArray *productIdentifierList;  
@property(nonatomic, retain) NSMutableArray *productDetailsList;

-(id)initWithChore:(DIChore *)chore;

@end
