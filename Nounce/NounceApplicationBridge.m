//
//  NounceApplicationBridge.m
//  Nounce
//
//  Created by Chetan Surpur on 3/7/11.
//  Copyright 2011 Chetan Surpur. All rights reserved.
//

#import "NounceApplicationBridge.h"
#import "NCNounceProtocol.h"


@interface NounceApplicationBridge()

#pragma mark Private methods

- (void)setNotification:(NCNotification *)notification forID:(NSString *)ID;

@end


@implementation NounceApplicationBridge

@synthesize delegate;

#pragma mark Initialization and descruction

- (id)init
{
	if (self = [super init]) {
		// Listen for notifications from Nounce
		[[NSDistributedNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(inputWasSubmittedForNotification:)
		 name:NCInputWasSubmittedEvent
		 object:[[NSBundle mainBundle] bundleIdentifier]];
		[[NSDistributedNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(notificationWasHidden:)
		 name:NCNotificationWasHiddenEvent
		 object:[[NSBundle mainBundle] bundleIdentifier]];
		
		[[NSDistributedNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(notificationPaneWasHidden:)
		 name:NCNotificationPaneWasHiddenEvent
		 object:nil];
	}
	
	return self;
}

#pragma mark Accessors and setters

+ (id)sharedBridge
{
	static id applicationBridge = nil;
	
	if (applicationBridge == nil) {
		applicationBridge = [[self alloc] init];
    }
	
    return applicationBridge;
}

- (NCNotification *)notificationWithID:(NSString *)notificationID
{
	return [[[notifications objectForKey:notificationID] retain] autorelease];
}

- (void)setNotification:(NCNotification *)notification forID:(NSString *)ID
{
	[notifications setObject:notification forKey:ID];
}

#pragma mark Functions

- (void)notify:(NCNotification *)notification
{
	NSData *archivedNotification = [NSKeyedArchiver archivedDataWithRootObject:notification];
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:NCNotificationWasPostedEvent
																   object:NCNounceAppID
																 userInfo:[NSDictionary dictionaryWithObject:archivedNotification
																									  forKey:@"Notification"]];
}

- (void)hideNotification:(NCNotification *)notification
{
	NSData *archivedNotification = [NSKeyedArchiver archivedDataWithRootObject:notification];
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:NCNotificationWasHiddenEvent
																   object:NCNounceAppID
																 userInfo:[NSDictionary dictionaryWithObject:archivedNotification
																									  forKey:@"Notification"]];	
}

#pragma mark Event handlers

- (void)inputWasSubmittedForNotification:(NSNotification *)inputWasSubmittedMessage
{
	if (self.delegate) {
		if ([self.delegate respondsToSelector:@selector(inputWasSubmittedForNotification:formName:buttonName:inputData:)]) {
			NCNotification *notification	= [NSKeyedUnarchiver unarchiveObjectWithData:[[inputWasSubmittedMessage userInfo] objectForKey:@"Notification"]];
			NSString *formName				= [[inputWasSubmittedMessage userInfo] objectForKey:@"FormName"];
			NSString *buttonName			= [[inputWasSubmittedMessage userInfo] objectForKey:@"ButtonName"];
			NSDictionary *inputData			= [[inputWasSubmittedMessage userInfo] objectForKey:@"InputData"];
			
			[self.delegate inputWasSubmittedForNotification:notification
												   formName:formName
												 buttonName:buttonName
												  inputData:inputData];
		}
	}
}

- (void)notificationWasHidden:(NSNotification *)notificationWasHiddenEvent
{
	if (self.delegate) {
		if ([self.delegate respondsToSelector:@selector(notificationWasHidden:)]) {
			NCNotification *notification	= [NSKeyedUnarchiver unarchiveObjectWithData:[[notificationWasHiddenEvent userInfo] objectForKey:@"Notification"]];
			
			[self.delegate notificationWasHidden:notification];
		}
	}
}

- (void)notificationPaneWasHidden:(NSNotification *)notificationPaneWasHiddenEvent
{
	if (self.delegate) {
		if ([self.delegate respondsToSelector:@selector(notificationPaneWasHidden)]) {
			[self.delegate notificationPaneWasHidden];
		}
	}
}

@end
