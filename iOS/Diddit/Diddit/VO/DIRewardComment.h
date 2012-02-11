//
//  DIRewardComment.h
//  Diddit
//
//  Created by Matthew Holcombe on 02.10.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIRewardComment : NSObject

+(DIRewardComment *)commentWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic) int comment_id;
@property (nonatomic) int sender_id;
@property (nonatomic, retain) NSDictionary *dictionary;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSDate *timestamp;


@end
