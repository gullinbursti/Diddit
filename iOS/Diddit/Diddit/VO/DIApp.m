//
//  DIApp.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import "DIApp.h"

@implementation DIApp

@synthesize dictionary;
@synthesize app_id, title, info, points, ico_url;


+(DIApp *)appWithDictionary:(NSDictionary *)dictionary {
	
	DIApp *app = [[DIApp alloc] init];
	app.dictionary = dictionary;
	
	app.app_id = [[dictionary objectForKey:@"id"] intValue];
	app.title = [dictionary objectForKey:@"title"];
	app.info = [dictionary objectForKey:@"info"];
	app.points = [[dictionary objectForKey:@"points"] intValue];
	app.ico_url = [dictionary objectForKey:@"ico_url"];
	
	return (app);
}

-(void)dealloc {
	self.dictionary = nil;
	self.title = nil;
	self.info = nil;
	self.ico_url = nil;
	
	[super dealloc];
}


@end
