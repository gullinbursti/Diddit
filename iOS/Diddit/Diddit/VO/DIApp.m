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
@synthesize ident;
@synthesize title;
@synthesize info;
@synthesize points;
@synthesize icoPath;


+(DIApp *)appWithDictionary:(NSDictionary *)dictionary {
	
	DIApp *app = [[DIApp alloc] init];
	app.dictionary = dictionary;
	
	app.ident = [[dictionary objectForKey:@"id"] intValue];
	app.title = [dictionary objectForKey:@"title"];
	app.info = [dictionary objectForKey:@"info"];
	app.points = [[dictionary objectForKey:@"points"] intValue];
	app.icoPath = [dictionary objectForKey:@"icoPath"];
	
	return (app);
}


@end
