//
//  DIAddNewRewardViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.31.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAddNewRewardViewController.h"
#import "DIPricePak.h"

#import "DINavTitleView.h"
#import "DINavBackBtnView.h"

@implementation DIAddNewRewardViewController

#pragma mark - View lifecycle
-(id)init {
	if((self = [super init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"device setup"] autorelease];
		
		DINavBackBtnView *backBtnView = [[[DINavBackBtnView alloc] init] autorelease];
		[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
	}
	
	return (self);
}


-(void)loadView {
	[super loadView];
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	
	_iapPakRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/AppStore.php"]] retain];
	[_iapPakRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
	[_iapPakRequest setDelegate:self];
	[_iapPakRequest startAsynchronous];
}


-(void)viewDidUnload {
    [super viewDidUnload];
}

-(void)dealloc {
	[super dealloc];
}


#pragma mark - ProductsRequest Delegates
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	NSLog(@"\n\n-------PRODUCT REQUEST--------\nINVALID:[%@]\nVALID[%@]", response.invalidProductIdentifiers, response.products);
	
	[_loadOverlay remove];
	NSArray *myProduct = response.products;
	
	if ([response.invalidProductIdentifiers count] > 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Store Error" message:@"Restart app to try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
	
	for (int i=0; i<[myProduct count]; i++) {
		SKProduct *product = [myProduct objectAtIndex:i];
		NSLog(@"Name: %@ - Price: %f - INFO:[%@]", [product localizedTitle], [[product price] doubleValue], [product localizedDescription]);
		NSLog(@"Product identifier: %@", [product productIdentifier]);
		
		SKPayment *payRequest = [SKPayment paymentWithProduct:product];
		[[SKPaymentQueue defaultQueue] addPayment:payRequest];
		
		[request autorelease];
	}
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	NSLog(@"[ChorePrice responseString]=\n%@\n\n", [request responseString]);
	
	if ([request isEqual:_iapPakRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			NSArray *parsedPaks = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				NSMutableArray *iapList = [NSMutableArray array];
				
				for (NSDictionary *serverIAP in parsedPaks) {
					DIPricePak *pricePak = [DIPricePak pricePakWithDictionary:serverIAP];
					
					if (pricePak != nil)
						[iapList addObject:pricePak];
				}
				
				_iapPaks = [iapList retain];
				
			}
		}
		
	} else if ([request isEqual:_addChoreDataRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			NSDictionary *parsedChore = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				
				[self dismissViewControllerAnimated:YES completion:^(void) {
					[[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_CHORE" object:[DIChore choreWithDictionary:parsedChore]];
				}];
			}
		}
	}
	
	[_loadOverlay remove];
}

-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
}

@end
