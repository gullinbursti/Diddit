//
//  DIChore.m
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import "DIChore.h"

@implementation DIChore

@synthesize dictionary;
@synthesize type_id;
@synthesize title;
@synthesize info;
@synthesize points;
@synthesize icoPath;
@synthesize imgPath;


+(DIChore *)choreWithDictionary:(NSDictionary *)dictionary {
	
	DIChore *chore = [[DIChore alloc] init];
	chore.dictionary = dictionary;
	
	chore.type_id = [[dictionary objectForKey:@"id"] intValue];
	chore.title = [dictionary objectForKey:@"title"];
	chore.info = [dictionary objectForKey:@"info"];
	chore.points = [[dictionary objectForKey:@"points"] intValue];
	chore.icoPath = [dictionary objectForKey:@"icoPath"];
	chore.imgPath = [dictionary objectForKey:@"imgPath"];
	
	return (chore);
}

@end
