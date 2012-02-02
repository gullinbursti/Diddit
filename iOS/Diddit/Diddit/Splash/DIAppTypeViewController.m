//
//  DIAppTypeViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.24.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAppTypeViewController.h"
#import "DIAppDelegate.h"
#import "DINavTitleView.h"
#import "DINavLeftBtnView.h"
#import "DISyncCodeMakerViewController.h"
#import "DISyncSubViewController.h"

@implementation DIAppTypeViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"device setup"] autorelease];
		
		//DINavLeftBtnView *backBtnView = [[[DINavLeftBtnView alloc] initWithLabel:@"Back"] autorelease];
		//[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		//self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fue_background.jpg"]] autorelease];
	CGRect frame = bgImgView.frame;
	frame.origin.y = -20;
	bgImgView.frame = frame;
	[self.view addSubview:bgImgView];
	
	UILabel *instructLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 30, 300, 20)] autorelease];
	instructLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:14];
	instructLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
	instructLabel.backgroundColor = [UIColor clearColor];
	instructLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	instructLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	instructLabel.textAlignment = UITextAlignmentCenter;
	instructLabel.text = @"please select your device type";
	[self.view addSubview:instructLabel];
	
	UIButton *masterSignupButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	masterSignupButton.frame = CGRectMake(20, 70, 280, 80);
	[masterSignupButton setBackgroundImage:[[UIImage imageNamed:@"fue_buttonTop_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[masterSignupButton setBackgroundImage:[[UIImage imageNamed:@"fue_buttonTop_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	masterSignupButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:16];
	masterSignupButton.titleLabel.textColor = [UIColor whiteColor];
	masterSignupButton.titleLabel.shadowColor = [UIColor blackColor];
	masterSignupButton.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	[masterSignupButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -75, 0, 75)];
	[masterSignupButton setImageEdgeInsets:UIEdgeInsetsMake(0, 160, 0, -160)];
	[masterSignupButton setImage:[UIImage imageNamed:@"fueArrow.png"] forState:UIControlStateNormal];
	[masterSignupButton setTitle:@"I am a parent" forState:UIControlStateNormal];
	[masterSignupButton addTarget:self action:@selector(_goMaster) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:masterSignupButton];
	
	UIButton *subSignupButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	subSignupButton.frame = CGRectMake(20, 150, 280, 80);
	[subSignupButton setBackgroundImage:[[UIImage imageNamed:@"fue_buttonBottom_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[subSignupButton setBackgroundImage:[[UIImage imageNamed:@"fue_buttonBottom_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	subSignupButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:16];
	subSignupButton.titleLabel.textColor = [UIColor whiteColor];
	subSignupButton.titleLabel.shadowColor = [UIColor blackColor];
	subSignupButton.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	[subSignupButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 40)];
	[subSignupButton setImageEdgeInsets:UIEdgeInsetsMake(0, 195, 0, -195)];
	[subSignupButton setImage:[UIImage imageNamed:@"fueArrow.png"] forState:UIControlStateNormal];
	[subSignupButton setTitle:@"I am a kid's iOS device" forState:UIControlStateNormal];
	[subSignupButton addTarget:self action:@selector(_goSub) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:subSignupButton];
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
}

-(void)viewDidLoad {
    [super viewDidLoad];
	
	//_syncPickerController = [[GKPeerPickerController alloc] init];
	//_syncPickerController.delegate = self;
	//_syncPickerController.connectionTypesMask = GKPeerPickerConnectionTypeOnline;
	
	_syncClients = [[NSMutableArray alloc] init];
	
	//[_syncPickerController show];
	
}

-(void)viewDidUnload {
    [super viewDidUnload];
}


-(void)dealloc {
	[super dealloc];
}


#pragma mark - Navigation
-(void)_goBack {
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)_goMaster {
	[self.navigationController pushViewController:[[[DISyncCodeMakerViewController alloc] init] autorelease] animated:YES];
}

-(void)_goSub {
	[self.navigationController pushViewController:[[[DISyncSubViewController alloc] init] autorelease] animated:YES];
}


#pragma mark PeerPickerController Delegates

// This creates a unique Connection Type for this particular applictaion
-(GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
	// Create a session with a unique session ID - displayName:nil = Takes the iPhone Name
	GKSession* session = [[GKSession alloc] initWithSessionID:@"com.getdiddit.sync" displayName:nil sessionMode:GKSessionModePeer];
	return [session autorelease];
}

// Tells us that the peer was connected
-(void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
	
	// Get the session and assign it locally
	_syncSession = session;
	session.delegate = self;
	
	//No need of teh picekr anymore
	picker.delegate = nil;
	[picker dismiss];
	[picker autorelease];
}

// Function to receive data when sent from peer
-(void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
	//Convert received NSData to NSString to display
	NSString *whatDidIget = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	
	//Dsiplay the fart as a UIAlertView
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Code Recieved" message:whatDidIget delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	[whatDidIget release];
}

#pragma mark GKSessionDelegate

-(void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
	
	if(state == GKPeerStateConnected){
		// Add the peer to the Array
		[_syncClients addObject:peerID];
		
		NSString *str = [NSString stringWithFormat:@"Connected with %@",[session displayNameForPeer:peerID]];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connected" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		// Used to acknowledge that we will be sending data
		[session setDataReceiveHandler:self withContext:nil];
		
		[[self.view viewWithTag:12] removeFromSuperview];
		
		NSString *loudFart = @"Brrrruuuuuummmmmmmppppppppp";
		[_syncSession sendData:[loudFart dataUsingEncoding: NSASCIIStringEncoding] toPeers:_syncClients withDataMode:GKSendDataReliable error:nil];
	}
	
}

@end
