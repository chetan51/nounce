//
//  NCNotification.m
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 Chetan Surpur. All rights reserved.
//

#import "NCNotification.h"
#include <stdlib.h>


@implementation NCNotification

@synthesize ID;
@synthesize fromApp;
@synthesize title;
@synthesize content;
@synthesize input;
@synthesize icon;
@synthesize group;
@synthesize groupIcon;
@synthesize isUpdate;

+ (NCNotification *)notificationWithTitle:(NSString *)title
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

- (id)init
{
	if ((self = [super init])) {
		[self setIsUpdate:NO];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:ID									forKey:@"ID"];
    [coder encodeObject:fromApp								forKey:@"fromApp"];
    [coder encodeObject:title								forKey:@"title"];
    [coder encodeObject:content								forKey:@"content"];
    [coder encodeObject:input								forKey:@"input"];
    [coder encodeObject:icon								forKey:@"icon"];
    [coder encodeObject:group								forKey:@"group"];
    [coder encodeObject:groupIcon							forKey:@"groupIcon"];
    [coder encodeObject:[NSNumber numberWithBool:isUpdate]	forKey:@"isUpdate"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    if ((self = [super init])) {
        self.ID			= [coder decodeObjectForKey:@"ID"];
        self.fromApp	= [coder decodeObjectForKey:@"fromApp"];
        self.title		= [coder decodeObjectForKey:@"title"];
        self.content	= [coder decodeObjectForKey:@"content"];
        self.input		= [coder decodeObjectForKey:@"input"];
        self.icon		= [coder decodeObjectForKey:@"icon"];
        self.group		= [coder decodeObjectForKey:@"group"];
        self.groupIcon	= [coder decodeObjectForKey:@"groupIcon"];
        self.isUpdate	= [(NSNumber *)[coder decodeObjectForKey:@"isUpdate"] boolValue];
    }
	
    return (self);
}

@end
