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
@synthesize title;
@synthesize info;
@synthesize points;
@synthesize icoPath;


+(DIChore *)choreWithDictionary:(NSDictionary *)dictionary {
	
	DIChore *chore = [[DIChore alloc] init];
	chore.dictionary = dictionary;
	
	chore.title = [dictionary objectForKey:@"title"];
	chore.info = [dictionary objectForKey:@"info"];
	chore.points = [[dictionary objectForKey:@"points"] intValue];
	chore.icoPath = [dictionary objectForKey:@"icoPath"];
	
	return (chore);
}

@end
