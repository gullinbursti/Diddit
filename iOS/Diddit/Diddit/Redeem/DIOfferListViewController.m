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
#import "DIChoreStatsView.h"
#import "DIOffer.h"
#import "DIOfferViewCell.h"

#import "DIOfferDetailsViewController.h"
#import "DIOffersHelpViewController.h"

@implementation DIOfferListViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		_offers = [[NSMutableArray alloc] init];
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"earn didds"] autorelease];
		
		DINavBackBtnView *backBtnView = [[[DINavBackBtnView alloc] init] autorelease];
		[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
	[self.view addSubview:bgImgView];
	
	DIChoreStatsView *choreStatsView = [[[DIChoreStatsView alloc] initWithFrame:CGRectMake(10, 13, 300, 34)]autorelease];
	[self.view addSubview:choreStatsView];
	
	UIButton *helpBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	helpBtn.frame = CGRectMake(228, 15, 84, 34);
	helpBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
	[helpBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[helpBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[helpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	helpBtn.titleLabel.shadowColor = [UIColor blackColor];
	helpBtn.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	[helpBtn setTitle:@"Need Help" forState:UIControlStateNormal];
	[helpBtn addTarget:self action:@selector(_goHelp) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:helpBtn];
	
	_offersTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 56, self.view.bounds.size.width, self.view.bounds.size.height - 56) style:UITableViewStylePlain];
	_offersTableView.rowHeight = 80;
	_offersTableView.backgroundColor = [UIColor clearColor];
	_offersTableView.separatorColor = [UIColor clearColor];
	_offersTableView.delegate = self;
	_offersTableView.dataSource = self;
	[self.view addSubview:_offersTableView];
	_offersTableView.hidden = YES;
	
	UIImageView *dividerImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerDivider.png"]] autorelease];
	CGRect frame = dividerImgView.frame;
	frame.origin.y = 54;
	dividerImgView.frame = frame;
	[self.view addSubview:dividerImgView];
	
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
	frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
}

-(void)viewDidLoad {
	[super viewDidLoad];
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	
	_offersDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Offers.php"]] retain];
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
	[_offersTableView release];
	//[_offers release];
	//[_emptyLabel release];
	[_offersDataRequest release];
	[_loadOverlay release];
	
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

#pragma mark - TableView Data Source Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([_offers count]);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DIOfferViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIOfferViewCell cellReuseIdentifier]];
		
	if (cell == nil)
		cell = [[[DIOfferViewCell alloc] init] autorelease];
		
	cell.offer = [_offers objectAtIndex:indexPath.row];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
	return (cell);
}

#pragma mark - TableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	DIOffer *offer = (DIOffer *)[_offers objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:[[[DIOfferDetailsViewController alloc] initWithOffer:offer] autorelease] animated:YES];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (95);
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	//	cell.textLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12.0];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
}

#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	//NSLog(@"OfferListViewController [_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
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
	
	[_loadOverlay remove];
}


-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
}

@end
