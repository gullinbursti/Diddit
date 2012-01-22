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
@synthesize app_id, type_id, title, info, points, score, itunes_id, ico_url, img_url, app_info, images;


+(DIApp *)appWithDictionary:(NSDictionary *)dictionary {
	
	DIApp *app = [[DIApp alloc] init];
	app.dictionary = dictionary;
	
	app.app_id = [[dictionary objectForKey:@"id"] intValue];
	app.type_id = [[dictionary objectForKey:@"type_id"] intValue]; 
	app.title = [dictionary objectForKey:@"title"];
	app.info = [dictionary objectForKey:@"info"];
	app.points = [[dictionary objectForKey:@"points"] intValue];
	app.score = [[dictionary objectForKey:@"score"] intValue];
	app.itunes_id  = [dictionary objectForKey:@"itunes_id"];
	app.ico_url = [dictionary objectForKey:@"ico_url"];
	app.img_url = [dictionary objectForKey:@"img_url"];
	app.app_info = [[dictionary objectForKey:@"description"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
	//app.app_info = [NSString stringWithUTF8String:[[[dictionary objectForKey:@"description"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"] cStringUsingEncoding:[NSString defaultCStringEncoding]]];
	
	app.images = [dictionary objectForKey:@"images"];
	return (app);
}

-(NSString *)disp_points {
	return ([NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:self.points] numberStyle:NSNumberFormatterDecimalStyle]);
}

-(void)dealloc {
	self.dictionary = nil;
	self.title = nil;
	self.info = nil;
	self.ico_url = nil;
	self.img_url = nil;
	self.itunes_id = nil;
	self.app_info = nil;
	self.images = nil;
	
	[super dealloc];
}


@end
