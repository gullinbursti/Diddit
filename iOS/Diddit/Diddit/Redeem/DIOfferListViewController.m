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
#import "DIOffer.h"
#import "DIOfferViewCell.h"

#import "DIOfferDetailsViewController.h"
#import "DIOffersHelpViewController.h"

@implementation DIOfferListViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		_offers = [[NSMutableArray alloc] init];
		self.navigationItem.titleView = [[DINavTitleView alloc] initWithTitle:@"earn didds"];
		
		UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		backButton.frame = CGRectMake(0, 0, 54.0, 34.0);
		[backButton setBackgroundImage:[[UIImage imageNamed:@"homeButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[backButton setBackgroundImage:[[UIImage imageNamed:@"homeButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		[backButton addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
		
		_offersDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Offers.php"]] retain];
		[_offersDataRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
		[_offersDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[_offersDataRequest setDelegate:self];
		[_offersDataRequest startAsynchronous];
	}
	
	return (self);
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
	[self.view addSubview:bgImgView];
	
	UILabel *diddsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 60, 26)];
	diddsLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10];
	diddsLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
	diddsLabel.backgroundColor = [UIColor clearColor];
	diddsLabel.text = @"DIDDS";
	[self.view addSubview:diddsLabel];
	
	_pointsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_pointsButton.frame = CGRectMake(50, 15, 59, 34);
	_pointsButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10.0];
	//diddsBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[_pointsButton setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[_pointsButton setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateSelected];
	[_pointsButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
	[_pointsButton setTitle:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle] forState:UIControlStateNormal];
	[self.view addSubview:_pointsButton];
	
	UILabel *choresLabel = [[UILabel alloc] initWithFrame:CGRectMake(122, 20, 60, 26)];
	choresLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10];
	choresLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
	choresLabel.backgroundColor = [UIColor clearColor];
	choresLabel.text = @"CHORES";
	[self.view addSubview:choresLabel];
	
	UIButton *finishedButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	finishedButton.frame = CGRectMake(170, 15, 38, 34);
	finishedButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10.0];
	[finishedButton setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[finishedButton setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateSelected];
	[finishedButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
	[finishedButton setTitle:[NSString stringWithFormat:@"%d", [DIAppDelegate userTotalFinished]] forState:UIControlStateNormal];
	[self.view addSubview:finishedButton];
	
	UIButton *helpBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	helpBtn.frame = CGRectMake(228, 15, 84, 34);
	helpBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
	[helpBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_nonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[helpBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_Active.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateSelected];
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
	
	UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
	CGRect frame = dividerImgView.frame;
	frame.origin.y = 54;
	dividerImgView.frame = frame;
	[self.view addSubview:dividerImgView];
	
	_emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 22, 260, 20)];
	_emptyLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:12];
	_emptyLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	_emptyLabel.backgroundColor = [UIColor clearColor];
	_emptyLabel.textAlignment = UITextAlignmentCenter;
	_emptyLabel.text = @"No offers found!";
	[self.view addSubview:_emptyLabel];
	
	UIImageView *overlayImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]];
	frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
}

-(void)viewDidLoad {
	[super viewDidLoad];
	
	
}

- (void)viewDidUnload {
	[super viewDidUnload];
}


-(void)dealloc {
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
	NSLog(@"OfferListViewController [_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	@autoreleasepool {
		NSError *error = nil;
		NSArray *parsedOffers = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
		if (error != nil)
			NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
		
		else {
			NSMutableArray *offerList = [NSMutableArray array];
			
			for (NSDictionary *serverOffer in parsedOffers) {
				DIOffer *offer = [DIOffer offerWithDictionary:serverOffer];
					
				NSLog(@"OFFER \"%@\"", offer.title);
					
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


-(void)requestFailed:(ASIHTTPRequest *)request {
}

@end
