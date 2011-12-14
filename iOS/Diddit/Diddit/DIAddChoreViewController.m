//
//  DIAddChoreViewController.m
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DIAddChoreViewController.h"

#import "DIChoreTypeViewCell.h"
#import "DIConfirmChoreViewController.h"

@implementation DIAddChoreViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_dismissMe:) name:@"DISMISS_ADD_CHORE" object:nil];
		
		_choreTypes = [[NSMutableArray alloc] init];
		
		UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 39)] autorelease];
		//headerLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:18.0];
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor];
		headerLabel.textColor = [UIColor whiteColor];
		headerLabel.shadowColor = [UIColor colorWithWhite:0.25 alpha:1.0];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		headerLabel.text = @"Add Chore";
		[headerLabel sizeToFit];
		self.navigationItem.titleView = headerLabel;
		
		UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		backButton.frame = CGRectMake(0, 0, 60.0, 30);
		[backButton setBackgroundImage:[[UIImage imageNamed:@"non_Active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateNormal];
		[backButton setBackgroundImage:[[UIImage imageNamed:@"active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateHighlighted];
		backButton.titleEdgeInsets = UIEdgeInsetsMake(-1.0, 1.0, 1.0, -1.0);
		//backButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
		[backButton setTitle:@"Back" forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
	}
	
	return (self);
}

-(id)initWithChoreTypes:(NSMutableArray *)choreTypes {
	if ((self = [self init])) {
		_choreTypes = choreTypes;
	}
	
	return (self);
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
	
	_myChoresTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_myChoresTableView.rowHeight = 54;
	_myChoresTableView.delegate = self;
	_myChoresTableView.dataSource = self;
	_myChoresTableView.layer.borderColor = [[UIColor colorWithWhite:0.75 alpha:1.0] CGColor];
	_myChoresTableView.layer.borderWidth = 1.0;
	[self.view addSubview:_myChoresTableView];
	
	//	UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 366, 320, 50)];
	//bgView.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1.0];
	//bgView.layer.borderColor = [[UIColor colorWithWhite:0.0 alpha:1.0] CGColor];
	//[self.view addSubview:bgView];
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)dealloc {
	[super dealloc];
}


#pragma mark - Notification handlers
-(void)_dismissMe:(NSNotification *)notification {
	NSLog(@"_dismissMe:");
	[self dismissViewControllerAnimated:YES completion:nil];	
}

#pragma mark - navigation
- (void)_goBack {
	[self dismissViewControllerAnimated:YES completion:nil];	
}

#pragma mark - TableView Data Source Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([_choreTypes count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DIChoreTypeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIChoreTypeViewCell cellReuseIdentifier]];
		
	if (cell == nil)
		cell = [[[DIChoreTypeViewCell alloc] init] autorelease];
		
	cell.choreType = [_choreTypes objectAtIndex:indexPath.row];
	cell.shouldDrawSeparator = (indexPath.row == ([_choreTypes count] - 1));
		
	return cell;
}

#pragma mark - TableView Delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	DIConfirmChoreViewController *confirmChoreType = [[[DIConfirmChoreViewController alloc] initWithChoreType:[_choreTypes objectAtIndex:indexPath.row]] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:confirmChoreType] autorelease];
	//[self.navigationController presentViewController:navigationController animated:YES completion:nil];
	[self.navigationController presentModalViewController:navigationController animated:YES];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 55;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	//	cell.textLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12.0];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
}


#pragma mark - ASI Delegates
- (void)requestFinished:(ASIHTTPRequest *)request { 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	[pool release];
} 

@end
