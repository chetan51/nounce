//
//  NCViewController.h
//  Nounce
//
//  Created by Chetan Surpur on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NCApplicationView.h"
#import "NCNotificationView.h"
#import "Nounce/NCNotification.h"


@interface NCViewController : NSObject {
	NSArrayController *applicationViews;
}

- (void) setApplicationViews:(NSArrayController *)appViews;
- (void) notify:(NCNotification *)notification;

@end
