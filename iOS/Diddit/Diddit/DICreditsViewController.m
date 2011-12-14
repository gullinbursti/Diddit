//
//  DICreditsViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DICreditsViewController.h"
#import "DICreditsViewCell.h"

@implementation DICreditsViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		
		_chores = [[NSMutableArray alloc] init];
		
		UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 39)] autorelease];
		//headerLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:18.0];
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor];
		headerLabel.textColor = [UIColor whiteColor];
		headerLabel.shadowColor = [UIColor colorWithWhite:0.25 alpha:1.0];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		headerLabel.text = @"My Credits";
		[headerLabel sizeToFit];
		self.navigationItem.titleView = headerLabel;
		
		_sectionTitles = [[NSArray alloc] initWithObjects:@"Free", @"Paid", nil];
	}
	
	return (self);
}

-(id)initWithChores:(NSMutableArray *)chores {
	if ((self = [self init])) {
		_chores = chores;
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]] autorelease];
	[self.view addSubview:bgImgView];
	
	_creditsLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 22, 260, 20)];
	//_creditsLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12];
	_creditsLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	_creditsLabel.backgroundColor = [UIColor clearColor];
	_creditsLabel.textAlignment = UITextAlignmentCenter;
	_creditsLabel.text = [NSString stringWithFormat:@"You have %d credits!", (arc4random() % 10000) + (arc4random() % 5000)];
	[self.view addSubview:_creditsLabel];
	
	_creditsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height - 94) style:UITableViewStylePlain];
	_creditsTableView.rowHeight = 54;
	_creditsTableView.delegate = self;
	_creditsTableView.dataSource = self;
	_creditsTableView.layer.borderColor = [[UIColor colorWithWhite:0.75 alpha:1.0] CGColor];
	_creditsTableView.layer.borderWidth = 1.0;
	[self.view addSubview:_creditsTableView];
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - TableView Data Source Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return (2);
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return ([_sectionTitles objectAtIndex:section]);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return ([_chores count] * 0.5);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	DICreditsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DICreditsViewCell cellReuseIdentifier]];
		
	if (cell == nil)
		cell = [[[DICreditsViewCell alloc] init] autorelease];
		
	cell.chore = [_chores objectAtIndex:indexPath.row];
	cell.shouldDrawSeparator = (indexPath.row == ([_chores count] - 1));
	
	return cell;
}

#pragma mark - TableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//DIConfirmChoreViewController *confirmChoreType = [[[DIConfirmChoreViewController alloc] initWithChoreType:[_choreTypes objectAtIndex:indexPath.row]] autorelease];
	//UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:confirmChoreType] autorelease];
	//[self.navigationController presentViewController:navigationController animated:YES completion:nil];
	//[self.navigationController presentModalViewController:navigationController animated:YES];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 55;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	//	cell.textLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12.0];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	[pool release];
} 

@end
