//
//  DIChorePriceViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIAppDelegate.h"
#import "DIChorePriceViewController.h"

#import "DIPricePak.h"
#import "DIPricePakViewCell.h"
#import "DIHowDiddsWorkViewController.h"

@implementation DIChorePriceViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super initWithTitle:@"add chore" header:@"how much is the chore worth?" backBtn:@"Back"])) {
		
		_selIndex = -1;
		_cells = [[NSMutableArray alloc] init];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_goIAPComplete:) name:@"IAP_COMPLETED" object:nil];
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
	
	_iapTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, self.view.bounds.size.width, self.view.bounds.size.height - 80) style:UITableViewStylePlain];
	_iapTableView.rowHeight = 80;
	_iapTableView.backgroundColor = [UIColor clearColor];
	_iapTableView.separatorColor = [UIColor clearColor];
	_iapTableView.rowHeight = 95;
	_iapTableView.delegate = self;
	_iapTableView.dataSource = self;
	[self.view addSubview:_iapTableView];
	
	_howBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_howBtn.frame = CGRectMake(84, 30, 150, 28);
	_howBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
	[_howBtn setBackgroundImage:[[UIImage imageNamed:@"genericButton_nonActive.png"] stretchableImageWithLeftCapWidth:17 topCapHeight:0] forState:UIControlStateNormal];
	[_howBtn setBackgroundImage:[[UIImage imageNamed:@"genericButton_Active.png"] stretchableImageWithLeftCapWidth:17 topCapHeight:0] forState:UIControlStateHighlighted];
	[_howBtn setTitleColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateNormal];
	[_howBtn setTitle:@"How do didds work?" forState:UIControlStateNormal];
	[_howBtn addTarget:self action:@selector(_goHow) forControlEvents:UIControlEventTouchUpInside];
	_howBtn.hidden = YES;
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	CGRect frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
	
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	
	_iapPakRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/AppStore.php"]] retain];
	[_iapPakRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
	[_iapPakRequest setDelegate:self];
	[_iapPakRequest startAsynchronous];
}

-(void)viewDidLoad {
	[super viewDidLoad];
}

-(void)viewDidUnload {
	[super viewDidUnload];
}

-(void)dealloc {
	[_iapTableView release];
	[_iapPaks release];
	[_howBtn release];
	[_loadOverlay release];
	
	[super dealloc];
}


#pragma mark - Navigation
-(void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)_goHow {
	DIHowDiddsWorkViewController *howDiddsWorkViewController = [[[DIHowDiddsWorkViewController alloc] initWithTitle:@"what are didds?" header:@"didds are app currency for kids" closeLabel:@"Done"] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:howDiddsWorkViewController] autorelease];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}


#pragma mark - Notification handlers
-(void)_goIAPComplete:(NSNotification *)notification {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	
	_addChoreDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
	[_addChoreDataRequest setPostValue:[NSString stringWithFormat:@"%d", 7] forKey:@"action"];
	[_addChoreDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[_addChoreDataRequest setPostValue:_chore.title forKey:@"choreTitle"];
	[_addChoreDataRequest setPostValue:_chore.info forKey:@"choreInfo"];
	[_addChoreDataRequest setPostValue:[NSNumber numberWithFloat:_chore.cost] forKey:@"cost"];
	[_addChoreDataRequest setPostValue:[dateFormat stringFromDate:_chore.expires] forKey:@"expires"];
	[_addChoreDataRequest setPostValue:_chore.imgPath forKey:@"image"];
	[_addChoreDataRequest setDelegate:self];
	[_addChoreDataRequest startAsynchronous];
	
	[dateFormat release];
}


#pragma mark - TableView Data Source Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([_iapPaks count] + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row < [_iapPaks count]) {
		DIPricePakViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIPricePakViewCell cellReuseIdentifier]];
		
		if (cell == nil)
			cell = [[[DIPricePakViewCell alloc] init] autorelease];
		
		cell.pricePak = [_iapPaks objectAtIndex:indexPath.row];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
		[_cells addObject:cell];
			
		return (cell);
		
	} else {
		UITableViewCell *cell = nil;
		
		cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
		
		if (cell == nil) {			
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
			[cell addSubview:_howBtn];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
		
		return (cell);
	}
}

#pragma mark - TableView Delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	_selIndex = indexPath.row;
	if (indexPath.row < [_iapPaks count]) {
	
		DIPricePakViewCell *cell;
		for (int i=0; i<[_cells count]; i++) {
			cell = (DIPricePakViewCell *)[_cells objectAtIndex:i];
			[cell toggleSelect:NO];
		}
	
		cell = (DIPricePakViewCell *)[_cells objectAtIndex:indexPath.row];
		[cell toggleSelect:YES];
		
		_chore.points = ((DIPricePak *)[_iapPaks objectAtIndex:indexPath.row]).points;
		_chore.cost = ((DIPricePak *)[_iapPaks objectAtIndex:indexPath.row]).cost;
		_chore.icoPath = ((DIPricePak *)[_iapPaks objectAtIndex:indexPath.row]).ico_url;
		_chore.itunes_id = ((DIPricePak *)[_iapPaks objectAtIndex:indexPath.row]).itunes_id;
		
		if (_chore.cost > 0.00) {
			
			//if ([SKPaymentQueue canMakePayments]) {
				NSLog(@"REQUEST PRODUCT[%@]", _chore.itunes_id);
				
				_loadOverlay = [[DILoadOverlay alloc] init];
				SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:_chore.itunes_id, nil]];
				request.delegate = self;
				[request start];
			//}
		} else {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"IAP_COMPLETED" object:nil];
		}
	}
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (81);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	
	if (indexPath.row != _selIndex && _selIndex > -1 && indexPath.row < [_iapPaks count])
		[(DIPricePakViewCell *) cell toggleSelect:NO];
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
	//NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
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
				[_iapTableView reloadData];
				_howBtn.hidden = NO;
				
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
