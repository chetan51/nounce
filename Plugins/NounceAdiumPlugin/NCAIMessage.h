//
//  NCAIMessage.h
//  NounceAdiumPlugin
//
//  Created by Chetan Surpur on 2/28/11.
//  Copyright 2011 Chetan Surpur. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NCAIMessage : NSObject {
	BOOL isSenderSelf;
	NSString *senderName;
	NSString *message;
}

@property BOOL isSenderSelf;
@property (copy) NSString *senderName;
@property (copy) NSString *message;

@end
