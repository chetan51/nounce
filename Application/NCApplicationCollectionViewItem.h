//
//  NCApplicationCollectionViewItem.h
//  Nounce
//
//  Created by Chetan Surpur on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NCApplicationCollectionViewItem : NSCollectionViewItem {
	IBOutlet NSArrayController *notifications;
}

- (void) awakeFromNib;

@end