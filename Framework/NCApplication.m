//
//  NCApplication.m
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCApplication.h"


@implementation NCApplication

@synthesize ID;

+ applicationWithBundleIdentifier:(NSString *)bundleIdentifier
{
	NCApplication *application = [[NCApplication alloc] autorelease];
	
	[application setID:bundleIdentifier];
	
	return application;
}

- (void) encodeWithCoder: (NSCoder *) coder
{
    [coder encodeObject:ID forKey:@"ID"];
}

- (id) initWithCoder: (NSCoder *) coder
{
    if (self = [super init]) {
        ID = [coder decodeObjectForKey:@"ID"];
    }
	
    return (self);
}

@end
