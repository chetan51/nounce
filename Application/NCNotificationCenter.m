//
//  NCNotificationCenter.m
//  Nounce
//
//  Created by Chetan Surpur on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCNotificationCenter.h"


@implementation NCNotificationCenter

static NCNotificationCenter *sharedNotificationCenter = nil;

- (void) notify:(NCNotification *)notification
{
	[applications setObject:[notification fromApp] forKey:[[notification fromApp] ID]];
	
	NSMutableDictionary *appNotifications = [notifications objectForKey:[[notification fromApp] ID]];
	if (!appNotifications) {
		appNotifications = [[NSMutableDictionary alloc] init];
	}
	[appNotifications setObject:notification forKey:[notification ID]];
	[notifications setObject:appNotifications forKey:[[notification fromApp] ID]];
	[appNotifications release]; // TODO: Fix this bad line
}

/* Singleton stuff */

- (id)init {
	if (self = [super init]) {
		applications = [[NSMutableDictionary alloc] init];
		notifications = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

+ (NCNotificationCenter*)sharedNotificationCenter
{
	if (sharedNotificationCenter == nil) {
        sharedNotificationCenter = [[super allocWithZone:NULL] init];
    }
    return sharedNotificationCenter;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedNotificationCenter] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

- (void)dealloc
{
	[applications release];
	[notifications release];
	[super dealloc];
}

@end
