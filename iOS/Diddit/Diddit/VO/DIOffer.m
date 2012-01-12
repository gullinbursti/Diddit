//
//  DIOffer.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIOffer.h"

@implementation DIOffer

@synthesize dictionary;
@synthesize offer_id, title, app_name, info, points, ico_url, img_url, video_url, itunes_id, images;


+(DIOffer *)offerWithDictionary:(NSDictionary *)dictionary {
	
	DIOffer *offer = [[DIOffer alloc] init];
	offer.dictionary = dictionary;
	
	offer.offer_id = [[dictionary objectForKey:@"id"] intValue];
	offer.title = [dictionary objectForKey:@"title"];
	offer.app_name = [dictionary objectForKey:@"name"];
	offer.info = [dictionary objectForKey:@"info"];
	offer.points = [[dictionary objectForKey:@"points"] intValue];
	offer.ico_url = [dictionary objectForKey:@"ico_url"];
	offer.img_url = [dictionary objectForKey:@"img_url"];
	offer.video_url = [dictionary objectForKey:@"video_url"];
	offer.itunes_id = [dictionary objectForKey:@"itunes_id"];
	offer.images = [dictionary objectForKey:@"images"];
	
	return (offer);
}

-(NSString *)disp_points {
	return ([NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:self.points] numberStyle:NSNumberFormatterDecimalStyle]);
}

-(void)dealloc {
	self.dictionary = nil;
	self.title = nil;
	self.app_name = nil;
	self.info = nil;
	self.img_url = nil;
	self.ico_url = nil;
	self.video_url = nil;
	self.itunes_id = nil;
	self.images = nil;
	
	[super dealloc];
}
@end
