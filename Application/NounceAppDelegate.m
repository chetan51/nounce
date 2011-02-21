//
//  NounceAppDelegate.m
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NounceAppDelegate.h"
#import "NCApplicationView.h"
#import "NCNotificationView.h"


@implementation NounceAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	notificationCenter = [NCNotificationCenter sharedNotificationCenter];
	
	viewController = [[NCViewController alloc] init];
	[viewController setApplicationViews:applicationViews];
	
	[self listen];
}

- (void) listen
{
	[[NSDistributedNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(notificationPosted:)
	 name:@"Nounce"
	 object:nil];
}

- (void) notificationPosted:(NSNotification *)message
{
	NCNotification *notification = [NSKeyedUnarchiver unarchiveObjectWithData:[[message userInfo]
																				objectForKey:@"notification"]];
	[self performSelectorOnMainThread:@selector(notify:) withObject:notification waitUntilDone:NO];
}

- (void) notify:(NCNotification *)notification
{
	NSLog(@"New notification from %@: %@ - %@", [[notification fromApp] ID], [notification title], [notification textContent]);
	[notificationCenter notify:notification];
	[viewController notify:notification];
}

- (void) dealloc
{
	[viewController release];
	[super dealloc];
}

@end
