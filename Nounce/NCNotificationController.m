//
//  NCNotificationController.m
//  Nounce
//
//  Created by Chetan Surpur on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCNotificationController.h"
#import <Nounce/NCNounceProtocol.h>


@implementation NCNotificationController

@synthesize notifications;

#pragma mark Initializers and destructors

- (id)init
{
	if(self = [super init]) {
		notifications = [[NSMutableDictionary alloc] init];
		
		// Listen for events
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(notificationWasPosted:)
		 name:NCNotificationWasPostedEvent
		 object:nil];
	}
	
	return self;
}

- (void)dealloc
{
	[notifications release];
	[super dealloc];
}

#pragma mark Accessors and setters

- (NCNotification *)notificationWithID:(NSString *)ID
{
	return [[[notifications objectForKey:ID] retain] autorelease];
}

- (void)setNotification:(NCNotification *)notification
{
	[notifications setObject:notification forKey:[notification ID]];
}

#pragma mark Event handlers

- (void)notificationWasPosted:(NSNotification *)notificationWasPostedEvent
{
	NCNotification *notification = [NSKeyedUnarchiver unarchiveObjectWithData:[[notificationWasPostedEvent userInfo] objectForKey:@"Notification"]];
	[self setNotification:notification];
}

@end
