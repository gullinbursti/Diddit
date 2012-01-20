//
//  DISponsorship.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.19.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DIOffer.h"
#import "DIApp.h"

@interface DISponsorship : NSObject

+(DISponsorship *)sponsorshipWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSDictionary *dictionary;
@property (nonatomic) int sponsorship_id;
@property (nonatomic) int type_id;
@property (nonatomic, retain) NSString *img_url;
@property (nonatomic, retain) DIOffer *offer;
@property (nonatomic, retain) DIApp *app;

@end
