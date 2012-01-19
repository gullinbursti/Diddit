//
//  DIStoreObserver.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.16.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "ASIFormDataRequest.h"
#import "DILoadOverlay.h"

@interface DIStoreObserver : NSObject <SKPaymentTransactionObserver, ASIHTTPRequestDelegate> {
	DILoadOverlay *_loadOverlay;
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
-(void)failedTransaction:(SKPaymentTransaction *)transaction;
-(void)restoreTransaction:(SKPaymentTransaction *)transaction;
-(void)completeTransaction:(SKPaymentTransaction *)transaction;

@end
