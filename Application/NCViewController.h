//
//  NCViewController.h
//  Nounce
//
//  Created by Chetan Surpur on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NCApplicationView.h"
#import "Nounce/NCNotification.h"


@interface NCViewController : NSObject {
	NSMutableArray *applicationViews;
}

- (void) setApplicationViews:(NSMutableArray *)appViews;
- (void) addApplicationView:(NCApplicationView *)appView;
- (void) notify:(NCNotification *)notification;

@end
