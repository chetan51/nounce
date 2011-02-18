//
//  NCApplicationCollectionViewItem.m
//  Nounce
//
//  Created by Chetan Surpur on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCApplicationCollectionViewItem.h"


@implementation NCApplicationCollectionViewItem

- (void) awakeFromNib
{
	if ([self representedObject]) {
		NSLog(@"%@", [self representedObject]);
		[[self representedObject] setNotifications:notifications];
	}
}

@end
