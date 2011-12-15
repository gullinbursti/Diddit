//
//  DIChore.h
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIChore : NSObject

+ (DIChore *)choreWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSDictionary *dictionary;
@property (nonatomic) int type_id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *info;
@property (nonatomic) int points;
@property (nonatomic, retain) NSString *icoPath;
@property (nonatomic, retain) NSString *imgPath;

@end
