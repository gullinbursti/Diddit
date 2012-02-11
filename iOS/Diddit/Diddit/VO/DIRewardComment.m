//
//  DIRewardComment.m
//  Diddit
//
//  Created by Matthew Holcombe on 02.10.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIRewardComment.h"

@implementation DIRewardComment

@synthesize dictionary;
@synthesize comment_id, sender_id, message, timestamp;

+(DIRewardComment *)commentWithDictionary:(NSDictionary *)dictionary {
	
	DIRewardComment *comment = [[DIRewardComment alloc] init];
	comment.dictionary = dictionary;
	
	comment.comment_id = [[dictionary objectForKey:@"id"] intValue];
	comment.sender_id = [[dictionary objectForKey:@"sender_id"] intValue]; 
	comment.message = [dictionary objectForKey:@"message"];
	comment.timestamp = [dictionary objectForKey:@"timestamp"];

	return (comment);
}

-(void)dealloc {
	self.dictionary = nil;
	self.message = nil;
	self.timestamp = nil;
	
	[super dealloc];
}

@end
