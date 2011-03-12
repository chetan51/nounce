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
		[[NSDistributedNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(notificationWasHidden_public:)
		 name:NCNotificationWasHiddenEvent
		 object:NCNounceAppID];
		
		// Listen for private events
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(inputWasSubmitted_private:)
		 name:NCInputWasSubmittedEvent
		 object:NCNounceAppID];
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(notificationWasHidden_private:)
		 name:NCNotificationWasHiddenEvent
		 object:NCNounceAppID];
		
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(notificationPaneWasHidden_private:)
		 name:NCNotificationPaneWasHiddenEvent
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

- (void)notificationWasHidden_public:(NSNotification *)hideNotificationEvent
{
	NCNotification *notification = [NSKeyedUnarchiver unarchiveObjectWithData:[[hideNotificationEvent userInfo] objectForKey:@"Notification"]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:[hideNotificationEvent name]
														object:[[notification fromApp] ID]
													  userInfo:[hideNotificationEvent userInfo]];
}

#pragma mark Private events

- (void)inputWasSubmitted_private:(NSNotification *)inputWasSubmittedEvent
{
	NCNotification *notification = [NSKeyedUnarchiver unarchiveObjectWithData:[[inputWasSubmittedEvent userInfo] objectForKey:@"Notification"]];
	
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:[inputWasSubmittedEvent name]
																   object:[[notification fromApp] ID]
																 userInfo:[inputWasSubmittedEvent userInfo]];
}

- (void)notificationWasHidden_private:(NSNotification *)notificationWasHiddenEvent
{
	NCNotification *notification = [NSKeyedUnarchiver unarchiveObjectWithData:[[notificationWasHiddenEvent userInfo] objectForKey:@"Notification"]];
	
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:[notificationWasHiddenEvent name]
																   object:[[notification fromApp] ID]
																 userInfo:[notificationWasHiddenEvent userInfo]];	
}

- (void)notificationPaneWasHidden_private:(NSNotification *)notificationPaneWasHiddenEvent
{
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:[notificationPaneWasHiddenEvent name]
																   object:NCNounceAppID
																 userInfo:[notificationPaneWasHiddenEvent userInfo]];	
}

#pragma mark -

@end
