//
//  NounceApplicationBridge.m
//  Nounce
//
//  Created by Chetan Surpur on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NounceApplicationBridge.h"


@implementation NounceApplicationBridge

@synthesize delegate;

/*
 * Initialization and descruction
 */

- (id)init
{
	if (self = [super init]) {
		// Listen for notifications from Nounce
		[[NSDistributedNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(inputWasSubmittedForNotification:)
		 name:@"Nounce_NotificationInputSubmitted"
		 object:nil];
	}
	
	return self;
}

/*
 * Accessors and setters
 */

+ (id)sharedBridge
{
	static id applicationBridge = nil;
	
	if (applicationBridge == nil) {
		applicationBridge = [[self alloc] init];
    }
	
    return applicationBridge;
}

- (NCNotification *) notificationWithID:(NSString *)notificationID
{
	return [[[notifications objectForKey:notificationID] retain] autorelease];
}

- (void) setNotification:(NCNotification *)notification forID:(NSString *)ID
{
	[notifications setObject:notification forKey:ID];
}

/*
 * Functions
 */

- (void)notify:(NCNotification *)notification
{
	NSData *archivedNotification = [NSKeyedArchiver archivedDataWithRootObject:notification];
	[[NSDistributedNotificationCenter defaultCenter]
	 postNotificationName:@"Nounce_PostNotification"
	 object:nil
	 userInfo:[NSDictionary dictionaryWithObject:archivedNotification forKey:@"notification"]];
}

/*
 * Event handlers
 */

- (void)inputWasSubmittedForNotification:(NSNotification *)inputWasSubmittedMessage
{
	if (self.delegate) {
		if ([self.delegate respondsToSelector:@selector(inputWasSubmittedForNotification:formName:buttonName:inputData:)]) {
			NCNotification *notification	= [self notificationWithID:[inputWasSubmittedMessage object]];
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

@end
