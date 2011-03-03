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
	return [notifications objectForKey:notificationID];
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
		[[notification callbackObject] performSelectorOnMainThread:[notification callbackSelector] withObject:event waitUntilDone:NO];
	}
}

/*
 * Functions
 */

+ (void) notify:(NCNotification *)notification
{
	[notifications setObject:notification forKey:[notification ID]];
	
	NSData *archivedNotification = [NSKeyedArchiver archivedDataWithRootObject:notification];
	[[NSDistributedNotificationCenter defaultCenter]
	 postNotificationName:@"Nounce_Notification"
	 object:nil
	 userInfo:[NSDictionary dictionaryWithObject:archivedNotification forKey:@"notification"]];
}

@end
