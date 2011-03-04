//
//  NCNotificationManager.m
//  Nounce
//
//  Created by Chetan Surpur on 2/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCNotificationManager.h"
#import "NCEvent.h"


@implementation NCNotificationManager

+ (void) initialize
{
	notifications = [[NSMutableDictionary alloc] init];
	
	[self listen];
}

+ (void) dealloc
{
	[notifications release];
	[super dealloc];
}

/*
 * Accessors and setters
 */

+ (NCNotification *) notificationWithID:(NSString *)notificationID
{
	return [[[notifications objectForKey:notificationID] retain] autorelease];
}

+ (void) setNotification:(NCNotification *)notification forID:(NSString *)ID
{
	[notifications setObject:notification forKey:ID];
}

/*
 * Event listeners
 */

+ (void) listen
{
	[[NSDistributedNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(eventForNotification:)
	 name:@"Nounce_NotificationResponse"
	 object:nil];
}

/*
 * Event handlers
 */

+ (void) eventForNotification:(NSNotification *)message
{
	NCNotification *eventedNotification = [NSKeyedUnarchiver unarchiveObjectWithData:[[message userInfo] objectForKey:@"notification"]];
	NCEvent *event = [NSKeyedUnarchiver unarchiveObjectWithData:[[message userInfo] objectForKey:@"event"]];
	
	NCNotification *notification = [self notificationWithID:[eventedNotification ID]];
	
	if ([notification callbackObject] && [notification callbackSelector]) {
		[[notification callbackObject] performSelector:[notification callbackSelector] withObject:event withObject:notification];
	}
}

/*
 * Functions
 */

+ (void) notify:(NCNotification *)notification
{
	[self setNotification:notification forID:[notification ID]];
	
	NSData *archivedNotification = [NSKeyedArchiver archivedDataWithRootObject:notification];
	[[NSDistributedNotificationCenter defaultCenter]
	 postNotificationName:@"Nounce_Notification"
	 object:nil
	 userInfo:[NSDictionary dictionaryWithObject:archivedNotification forKey:@"notification"]];
}

@end
