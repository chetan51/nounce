//
//  NCNotification.m
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCNotification.h"
#include <stdlib.h>


@implementation NCNotification

@synthesize ID;
@synthesize fromApp;
@synthesize title;
@synthesize content;
@synthesize input;

+ (NCNotification *) notificationWithTitle:(NSString *)title
								   content:(NSString *)content
									 input:(NSString *)input
{
	NCNotification *notification = [[[NCNotification alloc] init] autorelease];
	
	NCApplication *fromApp = [NCApplication applicationWithBundleIdentifier:
							  [[NSBundle mainBundle] bundleIdentifier]];
	[notification setFromApp:fromApp];
	
	int notificationID = arc4random() % 10000;
	[notification setID:[NSString stringWithFormat:@"%@-%d", [fromApp ID], notificationID]];

	[notification setTitle:title];
	[notification setContent:content];
	[notification setInput:input];
	
	return notification;
}

- (void) encodeWithCoder: (NSCoder *) coder
{
    [coder encodeObject:ID			forKey:@"ID"];
    [coder encodeObject:fromApp		forKey:@"fromApp"];
    [coder encodeObject:title		forKey:@"title"];
    [coder encodeObject:content		forKey:@"content"];
    [coder encodeObject:input		forKey:@"input"];
}

- (id) initWithCoder: (NSCoder *) coder
{
    if (self = [super init]) {
        ID			= [coder decodeObjectForKey:@"ID"];
        fromApp		= [coder decodeObjectForKey:@"fromApp"];
        title		= [coder decodeObjectForKey:@"title"];
        content		= [coder decodeObjectForKey:@"content"];
        input		= [coder decodeObjectForKey:@"input"];
    }
	
    return (self);
}

- (void) dealloc
{
    [ID release];
	[fromApp release];
	[title release];
	[content release];
	[input release];
    [super dealloc];
}

@end
