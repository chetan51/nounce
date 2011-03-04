//
//  NCAIMessage.m
//  NounceAdiumPlugin
//
//  Created by Chetan Surpur on 2/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCAIMessage.h"


@implementation NCAIMessage

@synthesize isSenderSelf;
@synthesize senderName;
@synthesize message;

- (void) dealloc
{
	[self setSenderName:nil];
	[self setMessage:nil];
	[super dealloc];
}

@end
