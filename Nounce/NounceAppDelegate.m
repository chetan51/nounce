//
//  NounceAppDelegate.m
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 Chetan Surpur. All rights reserved.
//

#import "NounceAppDelegate.h"
#import <Sparkle/Sparkle.h>


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
	
	// Check for updates
	if ([[SUUpdater sharedUpdater] automaticallyChecksForUpdates]) {
		[[SUUpdater sharedUpdater] checkForUpdatesInBackground];
	}
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
