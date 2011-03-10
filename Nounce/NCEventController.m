//
//  NCEventController.m
//  Nounce
//
//  Created by Chetan Surpur on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCEventController.h"
#import <Nounce/NCNounceProtocol.h>
#import <Nounce/NCNotification.h>


@implementation NCEventController

#pragma mark Initialization and destruction

- (id)init
{
	if (self = [super init]) {
		// Listen for public events
		[[NSDistributedNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(notificationWasPosted_public:)
		 name:NCNotificationWasPostedEvent
		 object:NCNounceAppID];
		
		// Listen for private events
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(inputWasSubmitted_private:)
		 name:NCInputWasSubmittedEvent
		 object:NCNounceAppID];
	}
	
	return self;
}

#pragma mark Event handlers
#pragma mark -

#pragma mark Public events

- (void)notificationWasPosted_public:(NSNotification *)postNotificationEvent
{
	NCNotification *notification = [NSKeyedUnarchiver unarchiveObjectWithData:[[postNotificationEvent userInfo] objectForKey:@"Notification"]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:[postNotificationEvent name]
														object:[[notification fromApp] ID]
													  userInfo:[postNotificationEvent userInfo]];
}

#pragma mark Private events

- (void)inputWasSubmitted_private:(NSNotification *)inputWasSubmittedEvent
{
	NCNotification *notification = [NSKeyedUnarchiver unarchiveObjectWithData:[[inputWasSubmittedEvent userInfo] objectForKey:@"Notification"]];
	
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:[inputWasSubmittedEvent name]
																   object:[[notification fromApp] ID]
																 userInfo:[inputWasSubmittedEvent userInfo]];
}

#pragma mark -

@end
