//
//  DIChore.m
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DIChore.h"

@implementation DIChore

@synthesize dictionary;
@synthesize title;
@synthesize info;
@synthesize worth;
@synthesize icoPath;


+(DIChore *)choreWithDictionary:(NSDictionary *)dictionary {
	
	DIChore *chore = [[DIChore alloc] init];
	chore.dictionary = dictionary;
	
	chore.title = [dictionary objectForKey:@"title"];
	chore.info = [dictionary objectForKey:@"info"];
	chore.worth = [dictionary objectForKey:@"worth"];
	chore.icoPath = [dictionary objectForKey:@"icoPath"];
	
	return (chore);
}

-(NSString *)price {
	return (([self.worth integerValue] >= 0.0) ? [NSNumberFormatter localizedStringFromNumber:self.worth numberStyle:NSNumberFormatterCurrencyStyle] : @"Free");
}

@end
