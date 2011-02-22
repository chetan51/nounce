//
//  NCViewController.m
//  Nounce
//
//  Created by Chetan Surpur on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NCViewController.h"


@implementation NCViewController

- (void)notify:(NCNotification *)notification
{
/*
	NCApplicationView *appView;
	NCNotificationView *notificationView;
	BOOL appFound = NO;
	BOOL notificationFound = NO;
	
	for (appView in [applicationViews arrangedObjects]) {
		if ([[[appView application] ID] isEqual:[[notification fromApp] ID]]) {
			appFound = YES;
			[appView setApplication:[notification fromApp]];
			
			for (notificationView in [[appView notifications] arrangedObjects]) {
				if ([[[notificationView notification] ID] isEqual:[notification ID]]) {
					notificationFound = YES;
					[notificationView setNotification:notification];
					
					break;
				}
			}
			
			break;
		}
	}
	
	if (!appFound) {
		appView = [[NCApplicationView alloc] init];
		[appView setApplication:[notification fromApp]];
		[applicationViews addObject:appView];
	}
	if (!notificationFound) {
		NCNotificationView *notificationView = [[NCNotificationView alloc] init];
		[notificationView setNotification:notification];
		[[appView notifications] addObject:notificationView];
	}
*/
}

@end
