//
//  NCApplication.h
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NCApplication : NSObject {
	NSString *ID;
	NSString *name;
}

@property (retain) NSString *ID;
@property (retain) NSString *name;

+ applicationWithBundleIdentifier:(NSString *)bundleIdentifier;

@end
