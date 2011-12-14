//
//  DIChoreType.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIChoreType : NSObject

+(DIChoreType *)choreTypeWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain) NSDictionary *dictionary;
@property (nonatomic) int type_id;
@property (nonatomic) int freq_id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *info;
@property (nonatomic) int points;
@property (nonatomic, retain) NSString *imgPath;

@end
