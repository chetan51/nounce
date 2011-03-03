//
//  NCEvent.m
//  Nounce
//
//  Created by Chetan Surpur on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCEvent.h"


@implementation NCEvent

@synthesize type;
@synthesize data;


- (void) encodeWithCoder: (NSCoder *) coder
{
    [coder encodeObject:[NSNumber numberWithInt:type]	forKey:@"type"];
    [coder encodeObject:data							forKey:@"data"];
}

- (id) initWithCoder: (NSCoder *) coder
{
    if (self = [super init]) {
        type = [[coder decodeObjectForKey:@"type"] intValue];
		data = [coder decodeObjectForKey:@"data"];
    }
	
    return (self);
}

@end
