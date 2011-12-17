//
//  DIChorePriceViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DIChorePriceViewController.h"

@implementation DIChorePriceViewController

@synthesize productDetailsList, productIdentifierList;

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_dismissMe:) name:@"DISMISS_CONFIRM_CHORE" object:nil];
		
		UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 39)] autorelease];
		//headerLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:18.0];
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor];
		headerLabel.textColor = [UIColor whiteColor];
		headerLabel.shadowColor = [UIColor colorWithWhite:0.25 alpha:1.0];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		headerLabel.text = @"Purchase Chore";
		[headerLabel sizeToFit];
		self.navigationItem.titleView = headerLabel;
		
		/*
		 UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		 backButton.frame = CGRectMake(0, 0, 60.0, 30);
		 [backButton setBackgroundImage:[[UIImage imageNamed:@"non_Active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateNormal];
		 [backButton setBackgroundImage:[[UIImage imageNamed:@"active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateHighlighted];
		 backButton.titleEdgeInsets = UIEdgeInsetsMake(-1.0, 1.0, 1.0, -1.0);
		 //backButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
		 [backButton setTitle:@"Back" forState:UIControlStateNormal];
		 [backButton addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		 self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
		 */
	}
	
	return (self);
}

-(id)initWithChore:(DIChore *)chore {
	if ((self = [self init])) {
		_chore = chore;	
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
	
	_imgView = [[EGOImageView alloc] initWithFrame:CGRectMake(32, 32, 256, 256)];
	_imgView.imageURL = [NSURL URLWithString:_chore.imgPath];
	//[self.view addSubview:_imgView];
	
	productDisplayTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	productDisplayTableView.rowHeight = 54;
	productDisplayTableView.delegate = self;
	productDisplayTableView.dataSource = self;
	productDisplayTableView.layer.borderColor = [[UIColor colorWithWhite:0.75 alpha:1.0] CGColor];
	productDisplayTableView.layer.borderWidth = 1.0;
	[self.view addSubview:productDisplayTableView];
	
	_label = [[UILabel alloc] initWithFrame:CGRectMake(128, 300, 64, 16)];
	//_label.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:9.5];
	_label.backgroundColor = [UIColor clearColor];
	_label.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	_label.lineBreakMode = UILineBreakModeTailTruncation;
	_label.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:_label];
	
	_slider = [[UISlider alloc] initWithFrame:CGRectMake(32, 320, 256, 32)];
	[_slider addTarget:self action:@selector(_goSliderChange:) forControlEvents:UIControlEventValueChanged];
	_slider.minimumValue = 1.0;
	_slider.maximumValue = 10.0;
	[self.view addSubview:_slider];
	
	_purchaseButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_purchaseButton.frame = CGRectMake(32, 375, 256, 32);
	//_purchaseButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
	_purchaseButton.titleEdgeInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
	[_purchaseButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButton.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[_purchaseButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButtonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:7] forState:UIControlStateHighlighted];
	[_purchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_purchaseButton setTitle:@"Purchase" forState:UIControlStateNormal];
	[_purchaseButton addTarget:self action:@selector(_goPurchase) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_purchaseButton];
}

-(void)viewDidLoad {
	
	productDetailsList    = [[NSMutableArray alloc] init];  
	productIdentifierList = [[NSMutableArray alloc] init];
	
	if ([SKPaymentQueue canMakePayments])
		NSLog(@"PURCHASING ALLOWED DICKHEAD!");
	
	else
		NSLog(@"CAN'T BUY SHIT!");
	
	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject: @"com.sparklemountain.diddit.00099"]];
	
	/*
	for (int i=0; i<=9; i++) {
		NSString *productIdent = [NSString stringWithFormat:@"com.sparklemountain.diddit.%03d99", i];
		[productIdentifierList addObject:productIdent]; 
		NSLog(@"PRODUCT: [%@]", productIdent);
	}	
	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdentifierList]];  
	*/
	request.delegate = self;
	[request start];
	
	[super viewDidLoad];
}

-(void)viewDidUnload {
	[super viewDidUnload];
}

-(void)dealloc {
	[super dealloc];
}


#pragma mark - navigation
- (void)_goPurchase {
	
	int price = (int)_slider.value;
	_chore.cost = price;
	
	UIAlertView *purchaseAlert = [[UIAlertView alloc] initWithTitle:@"Coming Soon"
																		 message:[NSString stringWithFormat:@"In-App purchase for $%d", price]
																		delegate:self
															cancelButtonTitle:@"OK"
															otherButtonTitles:@"Cancel", nil];
	[purchaseAlert show];
	[purchaseAlert release];
}


#pragma mark - Event Handlers
-(void)_goSliderChange:(id)sender {
	_label.text = [NSString stringWithFormat:@"$%d", (int)_slider.value];
}


#pragma mark - TableView Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {  
	return ([productDetailsList count]);
}   

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {  
	static NSString *GenericTableIdentifier = @"GenericTableIdentifier";  
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: GenericTableIdentifier];  
	
	if (cell == nil)
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: GenericTableIdentifier] autorelease];  
	
	NSUInteger row = [indexPath row];  
	SKProduct *thisProduct = [productDetailsList objectAtIndex:row];  
	[cell.textLabel setText:[NSString stringWithFormat:@"%@ - %@", thisProduct.localizedTitle, thisProduct.price]];   
	
	return cell;  
}


#pragma mark - AlertView Delegates
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"clickedButtonAtIndex: [%d]", buttonIndex);
	
	if (buttonIndex == 0) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_CHORE" object:_chore];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"REMOVE_AVAIL_CHORE" object:_chore];
		
		ASIFormDataRequest *addChoreRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
		[addChoreRequest setPostValue:[NSString stringWithFormat:@"%d", 4] forKey:@"action"];
		[addChoreRequest setPostValue:[NSString stringWithFormat:@"%d", 2] forKey:@"userID"];
		[addChoreRequest setPostValue:[NSString stringWithFormat:@"%d", _chore.chore_id] forKey:@"choreID"];
		[addChoreRequest setDelegate:self];
		[addChoreRequest startAsynchronous];
		
		ASIFormDataRequest *purchaseRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Purchases.php"]] retain];
		[purchaseRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
		[purchaseRequest setPostValue:[NSString stringWithFormat:@"%d", 2] forKey:@"userID"];
		[purchaseRequest setPostValue:[NSString stringWithFormat:@"%d", _chore.chore_id] forKey:@"choreID"];
		[purchaseRequest setPostValue:[NSString stringWithFormat:@"%d", _chore.cost] forKey:@"price"];
		[purchaseRequest setDelegate:self];
		[purchaseRequest startAsynchronous];
		
		[self.navigationController dismissViewControllerAnimated:YES completion:^(void) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISS_ADD_CHORE" object:_chore];
		}];
	}
}

#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	//	@autoreleasepool {
	//		NSError *error = nil;
	//		NSArray *parsedChores = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
	//		
	//		if (error != nil)
	//			NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
	//		
	//		else {
	//			NSMutableArray *choreList = [NSMutableArray array];
	//			
	//			for (NSDictionary *serverChore in parsedChores) {
	//				DIChore *chore = [DIChore choreWithDictionary:serverChore];
	//				
	//				if (chore != nil)
	//					[choreList addObject:chore];
	//			}
	//			
	//		}
	//	}
}

-(void)requestFailed:(ASIHTTPRequest *)request {
}



#pragma mark - StoreKit Delegates
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	NSLog(@"Product request OK: %@", response.products); 
	
	NSArray *myProduct = response.products;
	
	for (int i=0; i<[myProduct count]; i++) {
		SKProduct *product = [myProduct objectAtIndex:i];
		NSLog(@"Name: %@ - Price: %f", [product localizedTitle], [[product price] doubleValue]);
		NSLog(@"Product identifier: %@", [product productIdentifier]);
	}
	
	
	
	[productDetailsList addObjectsFromArray: response.products];  
	[productDisplayTableView reloadData];
}  

-(void)requestDidFinish:(SKRequest *)request {
	NSLog(@"Product request done");
	[request release];  
}  

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"Failed to connect with error: %@", [error localizedDescription]);  
}

@end
