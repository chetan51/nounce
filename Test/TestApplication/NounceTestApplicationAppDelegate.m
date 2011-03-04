//
//  NounceTestApplicationAppDelegate.m
//  NounceTestApplication
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NounceTestApplicationAppDelegate.h"

@implementation NounceTestApplicationAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NCNotification *notification = [NCNotification
									notificationWithTitle:@"Test Notification"
									content:@"testing..."
									input:@"<form name='test-form'>"
												"<input type='text' name='message' value='message'>"
												"<input type='submit' name='reply' class='submit' value='Reply'>"
												"<input type='submit' name='forward' class='submit' value='Forward'>"
											"</form>"];
	[notification setObserver:self selector:@selector(firstNotificationEvent:forNotification:)];
	[NCNotificationManager notify:notification];
	
	NCNotification *notification2 = [NCNotification
									 notificationWithTitle:@"Test Notification 2"
									 content:@"<i>testing custom content...</i>"
									 input:nil];
	[[notification2 fromApp] setID:@"something"];
	[[notification2 fromApp] setName:@"Another App"];
	[NCNotificationManager notify:notification2];
}

- (void) firstNotificationEvent:(NCEvent *)event forNotification:(NCNotification *)notification
{
	if ([event type] == NCEVENT_INPUT_SUBMIT) {
		NSDictionary *inputData = [[event data] objectForKey:@"InputData"];
		NSLog(@"input submit from first notification: %@", inputData);
	}
}

@end
