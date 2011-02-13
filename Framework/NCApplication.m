//
//  NCApplication.m
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCApplication.h"


@implementation NCApplication

@synthesize ID;

+ applicationWithBundleIdentifier:(NSString *)bundleIdentifier
{
	NCApplication *application = [[NCApplication alloc] autorelease];
	
	[application setID:bundleIdentifier];
	
	return application;
}

@end
