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

- (NSDictionary *) activeNotificationsForApplication:(NCApplication *)application
{
	return [notifications objectForKey:[application ID]];
}

- (void) notify:(NCNotification *)notification
{
	[applications setObject:[notification fromApp] forKey:[[notification fromApp] ID]];
	
	NSMutableDictionary *appNotifications = [notifications objectForKey:[[notification fromApp] ID]];
	if (!appNotifications) {
		appNotifications = [[NSMutableDictionary alloc] init];
	}
	[appNotifications setObject:notification forKey:[notification ID]];
	[notifications setObject:appNotifications forKey:[[notification fromApp] ID]];
	[appNotifications release];
}

/* NSOutlineView DataSource implementation */

- (int)	outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [applications count];
    }
	
    if ([item isKindOfClass:[NCApplication class]]) {
		return [[self activeNotificationsForApplication:item] count];
    }
	
    return 0; 
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([item isKindOfClass:[NCApplication class]]) {
        if ([[self activeNotificationsForApplication:item] count] > 0) {
            return YES;
		}
    }
    
    return NO;
}

- (id) outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item
{
    if (item == nil) {
        item = applications;
    }
    
    if ([item isKindOfClass:[NCApplication class]]) {
		NSDictionary *appNotifications = [self activeNotificationsForApplication:item];
        return [appNotifications objectForKey:[[appNotifications allKeys] objectAtIndex:index]];
    }
	if ([item isKindOfClass:[NSDictionary class]]) {
		return [item objectForKey:[[item allKeys] objectAtIndex:index]];
	}
    
    return nil;
}

- (id) outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
	if ([item isKindOfClass:[NCApplication class]]) {
		return [item name];
	}
	if ([item isKindOfClass:[NCNotification class]]) {
		return [item title];
	}
    
    return nil;
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
