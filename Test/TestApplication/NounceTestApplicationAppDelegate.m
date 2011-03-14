//
//  NounceTestApplicationAppDelegate.m
//  NounceTestApplication
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 Chetan Surpur. All rights reserved.
//

#import "NounceTestApplicationAppDelegate.h"
#import <Nounce/NounceApplicationBridge.h>
#import <Nounce/NCIcon.h>

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
	
	NCIcon *icon = [[NCIcon alloc] init];
	[icon setPath:[[NSBundle mainBundle] pathForResource:@"happy-icon" ofType:@"png"]];
	[notification setIcon:icon];
	
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
	
	
	NCNotification *notification3 = [NCNotification
									 notificationWithTitle:@"Test Notification with really reallyyyyy really really long title"
									 content:@"really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really long content"
									 input:@"really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really really long input"];
	[notification3 setID:@"something-9386"];
	[[notification3 fromApp] setID:@"com.anotherapp.notherapp"];
	[[notification3 fromApp] setName:@"Another App"];
	[[NounceApplicationBridge sharedBridge] notify:notification3];
}

- (void)inputWasSubmittedForNotification:(NCNotification *)notification formName:(NSString *)formName buttonName:(NSString *)buttonName inputData:(NSDictionary *)inputData
{
	NSLog(@"input submit from notification: %@", inputData);
}

@end
