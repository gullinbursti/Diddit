//
//  DIRedeemStoreViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAppDelegate.h"
#import "DINavTitleView.h"
#import "DIOffersHelpViewController.h"
#import "DIAppDetailsViewController.h"
#import "DIAppListViewController.h"
#import "DIAppViewCell.h"

@implementation DIAppListViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		_features = [[NSMutableArray alloc] init];
		_apps = [[NSMutableArray alloc] init];
		
		self.navigationItem.titleView = [[DINavTitleView alloc] initWithTitle:@"store"];
		
		UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		backButton.frame = CGRectMake(0, 0, 54.0, 34.0);
		[backButton setBackgroundImage:[[UIImage imageNamed:@"homeButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[backButton setBackgroundImage:[[UIImage imageNamed:@"homeButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		[backButton addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
		
		_featuredDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Apps.php"]] retain];
		[_featuredDataRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
		[_featuredDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[_featuredDataRequest setDelegate:self];
		//[_featuredDataRequest startAsynchronous];
		
		_appsDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Apps.php"]] retain];
		[_appsDataRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
		[_appsDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[_appsDataRequest setDelegate:self];
		[_appsDataRequest startAsynchronous];
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
	
	UIButton *pointsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	pointsButton.frame = CGRectMake(50, 15, 59, 34);
	pointsButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10.0];
	//pointsButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[pointsButton setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[pointsButton setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateSelected];
	[pointsButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
	[pointsButton setTitle:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle] forState:UIControlStateNormal];
	[self.view addSubview:pointsButton];
	
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
	
	UIButton *offersBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	offersBtn.frame = CGRectMake(228, 15, 84, 34);
	offersBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
	[offersBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_nonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[offersBtn setBackgroundImage:[[UIImage imageNamed:@"earnDiddsButton_Active.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateSelected];
	[offersBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	offersBtn.titleLabel.shadowColor = [UIColor blackColor];
	offersBtn.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	[offersBtn setTitle:@"Earn Didds" forState:UIControlStateNormal];
	[offersBtn addTarget:self action:@selector(_goOffers) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:offersBtn];
	
	UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
	CGRect frame = dividerImgView.frame;
	frame.origin.y = 54;
	dividerImgView.frame = frame;
	[self.view addSubview:dividerImgView];
	
	_featuredScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0, 320, 100)];
	_featuredScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_featuredScrollView.opaque = NO;
	_featuredScrollView.contentSize = CGSizeMake(480, 100);
	_featuredScrollView.scrollsToTop = NO;
	_featuredScrollView.showsHorizontalScrollIndicator = YES;
	_featuredScrollView.showsVerticalScrollIndicator = NO;
	_featuredScrollView.alwaysBounceHorizontal = NO;
	
	CGRect featFrame;
	UIImageView *feat1ImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"storeFeature.png"]];
	featFrame = feat1ImgView.frame;
	featFrame.origin.x = 5;
	featFrame.origin.y = 10;
	feat1ImgView.frame = featFrame;
	[_featuredScrollView addSubview:feat1ImgView];
	
	UIImageView *feat2ImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"storeFeature.png"]];
	featFrame = feat2ImgView.frame;
	featFrame.origin.x = 165;
	featFrame.origin.y = 10;
	feat2ImgView.frame = featFrame;
	[_featuredScrollView addSubview:feat2ImgView];
	
	UIImageView *feat3ImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"storeFeature.png"]];
	featFrame = feat3ImgView.frame;
	featFrame.origin.x = 325;
	featFrame.origin.y = 10;
	feat3ImgView.frame = featFrame;
	[_featuredScrollView addSubview:feat3ImgView];
	
	
	_appsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 56, self.view.bounds.size.width, self.view.bounds.size.height - 56) style:UITableViewStylePlain];
	_appsTableView.rowHeight = 80;
	_appsTableView.backgroundColor = [UIColor clearColor];
	_appsTableView.separatorColor = [UIColor clearColor];
	_appsTableView.delegate = self;
	_appsTableView.dataSource = self;
	[self.view addSubview:_appsTableView];
	_appsTableView.hidden = YES;
	
	
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

-(void)_goOffers {
	[self.navigationController popViewControllerAnimated:NO];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PUSH_OFFERS_SCREEN" object:nil];
	
	//	[self.navigationController dismissViewControllerAnimated:YES completion:^(void) {
	//		[[NSNotificationCenter defaultCenter] postNotificationName:@"PUSH_OFFERS_SCREEN" object:nil];
	//	}];
}

#pragma mark - TableView Data Source Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([_apps count]);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == -1) {
		UITableViewCell *cell = nil;
		cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
		
		if (cell == nil) {			
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		}
		
		return (cell);
		
	} else {
		DIAppViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIAppViewCell cellReuseIdentifier]];
		
		if (cell == nil)
			cell = [[[DIAppViewCell alloc] init] autorelease];
		
		cell.app = [_apps objectAtIndex:indexPath.row];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		return (cell);		
	}
}

#pragma mark - TableView Delegates
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return (136);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return (_featuredScrollView);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DIApp *app = (DIApp *)[_apps objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:[[[DIAppDetailsViewController alloc] initWithApp:app] autorelease] animated:YES];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (80);
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	//	cell.textLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12.0];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
}

#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	NSLog(@"AppListViewController [_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	@autoreleasepool {
		NSError *error = nil;
		NSArray *parsedApps = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
		if (error != nil)
			NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
		
		else {
			NSMutableArray *appList = [NSMutableArray array];
			
			for (NSDictionary *serverApp in parsedApps) {
				DIApp *app = [DIApp appWithDictionary:serverApp];
				
				NSLog(@"APP \"%@\"", app.title);
				
				if (app != nil)
					[appList addObject:app];
			}
			
			_apps = [appList retain];
			[_appsTableView reloadData];
			
			if ([_apps count] > 0) {
				_appsTableView.hidden = NO;
				//_emptyLabel.hidden = YES;
			}
			
			//[choreList sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO]]];
		}
	}
}


-(void)requestFailed:(ASIHTTPRequest *)request {
}


@end
