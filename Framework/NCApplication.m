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
@synthesize name;

+ applicationWithBundleIdentifier:(NSString *)bundleIdentifier
{
	NCApplication *application = [[NCApplication alloc] autorelease];
	
	[application setID:bundleIdentifier];
	
	NSString * path = [[NSWorkspace sharedWorkspace]
					   absolutePathForAppBundleWithIdentifier:(NSString *)bundleIdentifier];
	[application setName:[[NSFileManager defaultManager] displayNameAtPath:path]];
	
	return application;
}

- (void) encodeWithCoder: (NSCoder *) coder
{
    [coder encodeObject:ID		forKey:@"ID"];
    [coder encodeObject:name	forKey:@"name"];
}

- (id) initWithCoder: (NSCoder *) coder
{
    if (self = [super init]) {
        ID		= [coder decodeObjectForKey:@"ID"];
        name	= [coder decodeObjectForKey:@"name"];
    }
	
    return (self);
}

@end
