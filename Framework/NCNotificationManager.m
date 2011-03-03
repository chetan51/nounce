//
//  NCNotificationManager.m
//  Nounce
//
//  Created by Chetan Surpur on 2/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCNotificationManager.h"


@implementation NCNotificationManager

+ (void) initialize
{
	notifications = [[NSMutableDictionary alloc] init];
	
	[self listen];
}

+ (void) listen
{
	[[NSDistributedNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(notificationResponsePosted:)
	 name:@"Nounce_NotificationResponse"
	 object:nil];
}

+ (void) notificationResponsePosted:(NSNotification *)message
{
	NCNotification *notification = [NSKeyedUnarchiver unarchiveObjectWithData:[[message userInfo]
																			   objectForKey:@"notification"]];
	NSLog(@"%@", message);
	//[self performSelectorOnMainThread:@selector(notify:) withObject:notification waitUntilDone:NO];	
}

+ (void) notify:(NCNotification *)notification
{
	[notifications setObject:notification forKey:[notification ID]];
	
	NSData *archivedNotification = [NSKeyedArchiver archivedDataWithRootObject:notification];
	[[NSDistributedNotificationCenter defaultCenter]
	 postNotificationName:@"Nounce_Notification"
	 object:nil
	 userInfo:[NSDictionary dictionaryWithObject:archivedNotification forKey:@"notification"]];
}

+ (void) dealloc
{
	[notifications release];
	[super dealloc];
}

@end
