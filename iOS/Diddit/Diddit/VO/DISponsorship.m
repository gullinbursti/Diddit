//
//  DISponsorship.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.19.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DISponsorship.h"
#import "DIOffer.h"

@implementation DISponsorship

@synthesize dictionary;
@synthesize sponsorship_id, img_url, type_id, offer, app;

+(DISponsorship *)sponsorshipWithDictionary:(NSDictionary *)dictionary {
	DISponsorship *sponsorship = [[DISponsorship alloc] init];
	sponsorship.dictionary = dictionary;
	
	sponsorship.sponsorship_id = [[dictionary objectForKey:@"sponsorship_id"] intValue];
	sponsorship.img_url = [dictionary objectForKey:@"sponsorship_img"];
	sponsorship.type_id = [[dictionary objectForKey:@"type_id"] intValue]; 
	sponsorship.offer = [DIOffer offerWithDictionary:[dictionary objectForKey:@"offer"]];
	sponsorship.app = [DIApp appWithDictionary:[dictionary objectForKey:@"store"]];
	
	return (sponsorship);
}

-(void)dealloc {
	self.dictionary = nil;
	self.img_url = nil;
	self.offer = nil;
	self.app = nil;
	[super dealloc];
}

@end
