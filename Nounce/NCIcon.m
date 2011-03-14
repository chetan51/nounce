//
//  NCIcon.m
//  Nounce
//
//  Created by Chetan Surpur on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCIcon.h"


@implementation NCIcon

@synthesize path;

- (void) encodeWithCoder: (NSCoder *) coder
{
    [coder encodeObject:path forKey:@"path"];
}

- (id) initWithCoder: (NSCoder *) coder
{
    if (self = [super init]) {
        self.path = [coder decodeObjectForKey:@"path"];
    }
	
    return (self);
}

@end
