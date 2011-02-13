//
//  NCNotificationManager.m
//  Nounce
//
//  Created by Chetan Surpur on 2/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCNotificationManager.h"


@implementation NCNotificationManager

- (id) init {
	self = [super init];
    if (self)
    {
        notifications = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc {
	[notifications release];
	[super dealloc];
}

@end
