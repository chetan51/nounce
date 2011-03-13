//
//  NounceAppDelegate.m
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 Chetan Surpur. All rights reserved.
//

#import "NounceAppDelegate.h"


@implementation NounceAppDelegate

@synthesize eventController,
			notificationController,
			notificationPaneController,
			notificationStatusController;

#pragma mark App loading and unloading

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Controllers
	eventController = [[NCEventController alloc] init];
	notificationController = [[NCNotificationController alloc] init];
	notificationPaneController = [[NCNotificationPaneController alloc] init];
	notificationStatusController = [[NCNotificationStatusController alloc] init];
}

- (void) dealloc
{
	[eventController release];
	[notificationController release];
	[notificationPaneController release];
	[notificationStatusController release];
	[super dealloc];
}

@end
