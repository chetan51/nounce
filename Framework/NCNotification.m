//
//  NCNotification.m
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCNotification.h"


@implementation NCNotification

@synthesize ID;
@synthesize fromApp;
@synthesize title;
@synthesize textContent;

+ (NCNotification *) notificationWithTitle:(NSString *)title
							   textContent:(NSString *)textContent
{
	NCNotification *notification = [[NCNotification alloc] autorelease];
	
	[notification setID:[NSNumber numberWithInt:0]]; // stubbed
	[notification setTitle:title];
	[notification setTextContent:textContent];
	NCApplication *fromApp = [NCApplication applicationWithBundleIdentifier:
							  [[NSBundle mainBundle] bundleIdentifier]];
	[notification setFromApp:fromApp];
	
	return notification;
}

- (void) encodeWithCoder: (NSCoder *) coder
{
    [coder encodeObject:ID			forKey:@"ID"];
    [coder encodeObject:fromApp		forKey:@"fromApp"];
    [coder encodeObject:title		forKey:@"title"];
    [coder encodeObject:textContent forKey:@"textContent"];
}

- (id) initWithCoder: (NSCoder *) coder
{
    if (self = [super init]) {
        ID			= [coder decodeObjectForKey:@"ID"];
        fromApp		= [coder decodeObjectForKey:@"fromApp"];
        title		= [coder decodeObjectForKey:@"title"];
        textContent = [coder decodeObjectForKey:@"textContent"];
    }
	
    return (self);
}

- (void) dealloc
{
    [ID release];
	[fromApp release];
	[title release];
	[textContent release];
    [super dealloc];
}

@end
