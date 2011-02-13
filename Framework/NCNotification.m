//
//  NCNotification.m
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCNotification.h"


@implementation NCNotification

@synthesize ID;
@synthesize fromApp;
@synthesize title;
@synthesize textContent;

+ (NCNotification *) notificationWithTitle:(NSString *)title
							   textContent:(NSString *)textContent
{
	NCNotification *notification = [[NCNotification alloc] autorelease];
	
	[notification setTitle:title];
	[notification setTextContent:textContent];
	NCApplication *fromApp = [NCApplication applicationWithBundleIdentifier:
							  [[NSBundle mainBundle] bundleIdentifier]];
	[notification setFromApp:fromApp];
	
	return notification;
}

- (void) dealloc
{
    [ID release];
	[fromApp release];
	[title release];
	[textContent release];
    [super dealloc];
}

@end
