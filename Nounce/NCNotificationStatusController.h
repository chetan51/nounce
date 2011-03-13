//
//  NCNotificationStatusController.h
//  Nounce
//
//  Created by Chetan Surpur on 3/9/11.
//  Copyright 2011 Chetan Surpur. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


@interface NCNotificationStatusController : NSViewController {
    NSStatusItem *statusItem;
	IBOutlet WebView *notificationStatus;
}

- (void)setupNotificationStatus;

@end
