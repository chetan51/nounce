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
@synthesize textMessage;

- (void) dealloc
{
    [ID release];
	[fromApp release];
	[title release];
	[textMessage release];
    [super dealloc];
}

@end
