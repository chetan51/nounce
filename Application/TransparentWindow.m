//
//  TransparentWindow.m
//  RoundedFloatingPanel
//
//  Created by Matt Gemmell on Thu Jan 08 2004.
//  <http://iratescotsman.com/>
//


#import "TransparentWindow.h"

@implementation TransparentWindow


- (id) initWithContentRect: (NSRect) contentRect
                 styleMask: (unsigned int) aStyle
                   backing: (NSBackingStoreType) bufferingType
                     defer: (BOOL) flag
{
    if (self = [super initWithContentRect: contentRect
                                styleMask: NSBorderlessWindowMask
                                  backing: bufferingType
                                    defer: flag])
		
    {
		[self setLevel: NSStatusWindowLevel];
        [self setBackgroundColor: [NSColor clearColor]];
        [self setAlphaValue:1.0];
        [self setOpaque:NO];
        [self setHasShadow:NO];
    }
    
    return self;
}

- (BOOL) canBecomeKeyWindow
{
    return YES;
}

@end
