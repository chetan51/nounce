//
//  NCApplication.h
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 Chetan Surpur. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NCApplication : NSObject {
	NSString *ID;
	NSString *name;
}

@property (copy) NSString *ID;
@property (copy) NSString *name;

+ applicationWithBundleIdentifier:(NSString *)bundleIdentifier;

@end
