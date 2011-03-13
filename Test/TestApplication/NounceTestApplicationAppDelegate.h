//
//  NounceTestApplicationAppDelegate.h
//  NounceTestApplication
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 Chetan Surpur. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Nounce/NCNotification.h>
#import <Nounce/NCEvent.h>
#import <Nounce/NounceDelegateProtocol.h>
#import <Nounce/NounceApplicationBridge.h>

@interface NounceTestApplicationAppDelegate : NSObject <NSApplicationDelegate, NounceDelegate> {
	
}

- (void)inputWasSubmittedForNotification:(NCNotification *)notification formName:(NSString *)formName buttonName:(NSString *)buttonName inputData:(NSDictionary *)inputData;

@end
