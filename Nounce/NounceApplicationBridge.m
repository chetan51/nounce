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

/*
 * Functions
 */

- (void)notify:(NCNotification *)notification
{
	NSData *archivedNotification = [NSKeyedArchiver archivedDataWithRootObject:notification];
	[[NSDistributedNotificationCenter defaultCenter]
	 postNotificationName:@"Nounce_NotificationPosted"
	 object:nil
	 userInfo:[NSDictionary dictionaryWithObject:archivedNotification forKey:@"notification"]];
}

/*
 * Event handlers
 */

- (void)inputWasSubmittedForNotification:(NSNotification *)inputSubmittedMessage
{
	if (self.delegate) {
		if ([self.delegate respondsToSelector:@selector(inputWasSubmittedForNotification:formName:buttonName:inputData:)]) {
			NCNotification *notification = [inputSubmittedMessage object];
			NSString *formName			= [[inputSubmittedMessage userInfo] objectForKey:@"FormName"];
			NSString *buttonName		= [[inputSubmittedMessage userInfo] objectForKey:@"ButtonName"];
			NSDictionary *inputData		= [[inputSubmittedMessage userInfo] objectForKey:@"InputData"];
			
			[self.delegate inputWasSubmittedForNotification:notification
												   formName:formName
												 buttonName:buttonName
												  inputData:inputData];
		}
	}
}

@end
