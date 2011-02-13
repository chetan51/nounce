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

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NCNotification *notification = [NCNotification notificationWithTitle:@"Test Notification" textContent:@"testing..."];
	[NCNotificationManager notify:notification];
}

@end
