//
//  DIStoreObserver.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.16.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import "DIStoreObserver.h"
#import "DIAppDelegate.h"

@implementation DIStoreObserver

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	
	for (SKPaymentTransaction *transaction in transactions) {
		switch (transaction.transactionState) {
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				break;
				
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				break;
				
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
				
			default:
				break;
		}
	}
}

-(void)failedTransaction:(SKPaymentTransaction *)transaction {
	if (transaction.error.code != SKErrorPaymentCancelled) {
		// Optionally, display an error here.
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed Transaction" message:transaction.error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
	
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void)restoreTransaction:(SKPaymentTransaction *)transaction {
	//If you want to save the transaction
	// [self recordTransaction: transaction];
	
	//Provide the new content
	// [self provideContent: transaction.originalTransaction.payment.productIdentifier];
	
	//Finish the transaction
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	
}

-(void)completeTransaction:(SKPaymentTransaction *)transaction {
	//If you want to save the transaction
	//[self recordTransaction: transaction];
	
	//Provide the new content
	//[self provideContent: transaction.payment.productIdentifier];
	
	//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Completed Transaction" message:@"Your payment has been processed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	//[alert show];
	//[alert release];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	ASIFormDataRequest *dataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/AppStore.php"]] retain];
	[dataRequest setPostValue:[NSString stringWithFormat:@"%d", 2] forKey:@"action"];
	[dataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[dataRequest setPostValue:transaction.transactionIdentifier forKey:@"transID"];
	[dataRequest setPostValue:[[NSString stringWithFormat:@"%@", transaction.transactionReceipt] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"< >"]] forKey:@"data"];
	[dataRequest setPostValue:[dateFormat stringFromDate:transaction.transactionDate] forKey:@"transDate"];
	[dataRequest setDelegate:self];
	[dataRequest startAsynchronous];
	
	[dateFormat release];
	
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	@autoreleasepool {
		NSError *error = nil;
		NSDictionary *parsedResult = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
		
		if (error != nil)
			NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
		
		else {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"IAP_COMPLETED" object:nil];
		}
	}
	
	[_loadOverlay remove];
}

-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
}

@end
