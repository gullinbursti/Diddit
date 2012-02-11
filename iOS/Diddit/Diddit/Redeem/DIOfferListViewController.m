//
//  DIOfferListViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIOfferListViewController.h"

#import "DIAppDelegate.h"
#import "DINavTitleView.h"
#import "DINavBackBtnView.h"
#import "DIOffer.h"
#import "DIOfferViewCell.h"

#import "DIOfferDetailsViewController.h"
#import "DIOffersHelpViewController.h"
#import "DITableHeaderView.h"

@implementation DIOfferListViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		_offers = [[NSMutableArray alloc] init];
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"earn didds"] autorelease];
		
		DINavBackBtnView *backBtnView = [[[DINavBackBtnView alloc] init] autorelease];
		[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_goOfferComplete:) name:@"OFFER_VIDEO_COMPLETE" object:nil];
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
	[self.view addSubview:bgImgView];
	
	_offersTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_offersTableView.rowHeight = 80;
	_offersTableView.backgroundColor = [UIColor clearColor];
	_offersTableView.separatorColor = [UIColor clearColor];
	_offersTableView.delegate = self;
	_offersTableView.dataSource = self;
	[self.view addSubview:_offersTableView];
	_offersTableView.hidden = YES;
	
	/*
	_emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 22, 260, 20)];
	_emptyLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:12];
	_emptyLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	_emptyLabel.backgroundColor = [UIColor clearColor];
	_emptyLabel.textAlignment = UITextAlignmentCenter;
	_emptyLabel.text = @"No offers found!";
	[self.view addSubview:_emptyLabel];
	*/
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	CGRect frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
}

-(void)viewDidLoad {
	[super viewDidLoad];
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	
	_offersDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kServerPath, @"Offers.php"]]] retain];
	[_offersDataRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
	[_offersDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[_offersDataRequest setDelegate:self];
	[_offersDataRequest startAsynchronous];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}


-(void)dealloc {
	//[_offersTableView release];
	//[_offers release];
	//[_emptyLabel release];
	//[_offersDataRequest release];
	//[_loadOverlay release];
	
	[super dealloc];
}


#pragma mark - navigation
-(void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)_goHelp {
	DIOffersHelpViewController *offersHelpViewController = [[[DIOffersHelpViewController alloc] initWithTitle:@"need help?" header:@"earning didds is easy and fun" closeLabel:@"Done"] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:offersHelpViewController] autorelease];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}


#pragma mark - Notification handlers
-(void)_goOfferComplete:(NSNotification *)notification {
	DIOffer *offer = (DIOffer *)[notification object];
	
	NSLog(@"OFFER COMPLETE [%@]", offer.title);
	
	[_offers removeObjectIdenticalTo:offer];
	//[_offersTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
	[_offersTableView reloadData];
}

#pragma mark - TableView Data Source Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([_offers count] + 1);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) {
		UITableViewCell *cell = nil;
		
		cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
		if (cell == nil)
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
		
		UIView *appsHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)] autorelease];
		appsHeaderView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.05];
		
		UILabel *appsLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 10, 300.0, 16)];
		appsLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		appsLabel.backgroundColor = [UIColor clearColor];
		appsLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
		appsLabel.text = @"Watch Trailers";
		[appsHeaderView addSubview:appsLabel];
		
		[cell addSubview:appsHeaderView];
		return (cell);
	
	} else {
	
		DIOfferViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIOfferViewCell cellReuseIdentifier]];
		
		if (cell == nil)
			cell = [[[DIOfferViewCell alloc] initWithIndex:indexPath.row - 1] autorelease];
			
		cell.offer = [_offers objectAtIndex:indexPath.row - 1];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			
		return (cell);
	}
}

#pragma mark - TableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	DIOfferViewCell *cell = (DIOfferViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	[cell toggleSelected];
	
	[self.navigationController pushViewController:[[[DIOfferDetailsViewController alloc] initWithOffer:(DIOffer *)[_offers objectAtIndex:indexPath.row - 1]] autorelease] animated:YES];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0)
		return (35);
	
	else
		return (90);
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	//	cell.textLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12.0];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
}

#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	//NSLog(@"OfferListViewController [_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	if ([request isEqual:_offersDataRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			NSArray *parsedOffers = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				NSMutableArray *offerList = [NSMutableArray array];
				
				for (NSDictionary *serverOffer in parsedOffers) {
					DIOffer *offer = [DIOffer offerWithDictionary:serverOffer];
						
					//NSLog(@"OFFER \"%@\"", offer.title);
						
					if (offer != nil)
						[offerList addObject:offer];
				}
					
				_offers = [offerList retain];
				[_offersTableView reloadData];
					
				if ([_offers count] > 0) {
					_offersTableView.hidden = NO;
					_emptyLabel.hidden = YES;
				}
				
				//[choreList sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO]]];
			}
		}
		
	}
	
	[_loadOverlay remove];
}


-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
}

@end
