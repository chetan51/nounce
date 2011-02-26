//
//  NounceTestApplicationAppDelegate.m
//  NounceTestApplication
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NounceTestApplicationAppDelegate.h"
#import <Nounce/NCNotification.h>
#import <Nounce/NCNotificationManager.h>

@implementation NounceTestApplicationAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NCNotification *notification = [NCNotification notificationWithTitle:@"Test Notification" textContent:@"testing..."];
	[NCNotificationManager notify:notification];
	
	NCNotification *notification2 = [NCNotification notificationWithTitle:@"Test Notification 2" textContent:@"testing again..."];
	[[notification2 fromApp] setID:@"something"];
	[[notification2 fromApp] setName:@"Another App"];
	[NCNotificationManager notify:notification2];
}

@end
