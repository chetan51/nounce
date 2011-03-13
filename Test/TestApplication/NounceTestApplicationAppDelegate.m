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
	[[NounceApplicationBridge sharedBridge] setDelegate:self];
	
	NCNotification *notification = [NCNotification
									notificationWithTitle:@"Test Notification"
									content:@"testing..."
									input:@"<form name='test-form'>"
												"<input type='text' name='message' value='message'>"
												"<input type='submit' name='reply' class='submit' value='Reply'>"
												"<input type='submit' name='forward' class='submit' value='Forward'>"
											"</form>"];
	[[NounceApplicationBridge sharedBridge] notify:notification];
	
	NCNotification *notification2 = [NCNotification
									 notificationWithTitle:@"Test Notification 2"
									 content:@"<i>testing custom content...</i>"
									 input:nil];
	[notification2 setID:@"something-9384"];
	[[notification2 fromApp] setID:@"com.anotherapp.notherapp"];
	[[notification2 fromApp] setName:@"Another App"];
	[notification2 setIsUpdate:YES];
	[[NounceApplicationBridge sharedBridge] notify:notification2];
	//[[NounceApplicationBridge sharedBridge] hideNotification:notification2];
}

- (void)inputWasSubmittedForNotification:(NCNotification *)notification formName:(NSString *)formName buttonName:(NSString *)buttonName inputData:(NSDictionary *)inputData
{
	NSLog(@"input submit from notification: %@", inputData);
}

@end
