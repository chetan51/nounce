//
//  NounceDelegateProtocol.h
//  Nounce
//
//  Created by Chetan Surpur on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NCNotification.h"

@protocol NounceDelegate <NSObject>

@optional

- (void)inputWasSubmittedForNotification:(NCNotification *)notification formName:(NSString *)formName buttonName:(NSString *)buttonName inputData:(NSDictionary *)inputData;

- (void)notificationPaneWasHidden;

@end