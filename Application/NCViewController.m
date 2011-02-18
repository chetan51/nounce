//
//  NCViewController.m
//  Nounce
//
//  Created by Chetan Surpur on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCViewController.h"


@implementation NCViewController

- (void) setApplicationViews:(NSArrayController *)appViews
{
	applicationViews = appViews;
}

- (void) addApplicationView:(NCApplicationView *)appView
{
	[applicationViews addObject:appView];
}

@end
