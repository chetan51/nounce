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

+ (void) listen
{
	[[NSDistributedNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(eventForNotification:)
	 name:@"Nounce_NotificationResponse"
	 object:nil];
}

+ (void) eventForNotification:(NSNotification *)message
{
	NCNotification *notification = [NSKeyedUnarchiver unarchiveObjectWithData:[[message userInfo]
																			   objectForKey:@"notification"]];
	NSDictionary *response = [[message userInfo] objectForKey:@"response"];
	NCEvent *event = [NSKeyedUnarchiver unarchiveObjectWithData:[response objectForKey:@"Event"]];
	
	NSLog(@"%@", response);
	NSLog(@"%@", event);
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
