//
//  NounceAppDelegate.m
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NounceAppDelegate.h"


@implementation NounceAppDelegate

@synthesize notificationWindow;

/* App loading and unloading */

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	notificationCenter = [NCNotificationCenter sharedNotificationCenter];
	
	[self listen];
}

- (void) awakeFromNib
{
	[self setupNotificationWindow];
	[self setupNotificationPane];
	[self setupNotificationStatus];
}

- (void) setupNotificationWindow
{
	NSRect screenRect = [[NSScreen mainScreen] frame];
	NSRect windowRect = [notificationWindow frame];
	
	// Stretch window fully vertically, minus the system menu bar
	windowRect.size.height = screenRect.size.height - 20;
	
	// Place window on top right of the screen
	windowRect.origin.y = 0;
	
	[notificationWindow setFrame:windowRect display:YES];
	
	[notificationWindow orderFront:nil];
}

- (void) setupNotificationPane
{
	// Set up the delegate of the notificationPane for relevant events
    [notificationPane setDrawsBackground:NO];
    [notificationPane setUIDelegate:self];
    [notificationPane setFrameLoadDelegate:self];
    
    // Configure notificationPane to let JavaScript talk to this object
    [[notificationPane windowScriptObject] setValue:self forKey:@"AppController"];
	
    /*
     Notes: 
	 1. In JavaScript, you can now talk to this object using "window.AppController".
     
	 2. You must explicitly allow methods to be called from JavaScript;
	 See the +isSelectorExcludedFromWebScript: method below for an example.
     
	 3. The method on this class which we call from JavaScript is -showMessage:
	 To call it from JavaScript, we use window.AppController.showMessage_()  <-- NOTE colon becomes underscore!
	 For more on method-name translation, see:
	 http://developer.apple.com/documentation/AppleApplications/Conceptual/SafariJSProgTopics/Tasks/ObjCFromJavaScript.html#
     */
    
    // Load the HTML content
    NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
    NSString *htmlPath = [resourcesPath stringByAppendingString:@"/index.html"];
    [[notificationPane mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]]];
}

- (void) setupNotificationStatus
{
	// Create notification status WebView
    float width = 100.0;
    float height = [[NSStatusBar systemStatusBar] thickness];
    NSRect viewFrame = NSMakeRect(0, 0, width, height);
	notificationStatus = [[[WebView alloc] initWithFrame:viewFrame frameName:@"NCNotificationStatus" groupName:@"NCNotificationUI"] autorelease];
	[[[notificationStatus mainFrame] frameView] setAllowsScrolling:NO];
	
	// Set up the delegate of the notificationStatus for relevant events
    [notificationStatus setDrawsBackground:NO];
    [notificationStatus setUIDelegate:self];
    [notificationStatus setFrameLoadDelegate:self];
	
	// Configure notificationPane to let JavaScript talk to this object
    [[notificationStatus windowScriptObject] setValue:self forKey:@"AppController"];
	
    // Load the HTML content
    NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
    NSString *htmlPath = [resourcesPath stringByAppendingString:@"/status.html"];
    [[notificationStatus mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]]];
}

- (void) dealloc
{
	[super dealloc];
}


/* Listening and responding to notifications */

- (void) listen
{
	[[NSDistributedNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(notificationPosted:)
	 name:@"Nounce"
	 object:nil];
}

- (void) notificationPosted:(NSNotification *)message
{
	NCNotification *notification = [NSKeyedUnarchiver unarchiveObjectWithData:[[message userInfo]
																				objectForKey:@"notification"]];
	[self performSelectorOnMainThread:@selector(notify:) withObject:notification waitUntilDone:NO];
}

- (void) notify:(NCNotification *)notification
{
	NSLog(@"New notification from %@: %@ - %@", [[notification fromApp] ID], [notification title], [notification textContent]);
	[notificationCenter notify:notification];
	[self NPNotify:notification];
}


/* Notification pane functions */

- (void) NPNotify:(NCNotification *)notification
{
	NSArray *args = [NSArray arrayWithObjects:
					 [notification ID],
					 [notification title],
					 [notification textContent],
					 [[notification fromApp] ID],
					 [[notification fromApp] name],
					 nil];
	[[notificationPane windowScriptObject] callWebScriptMethod:@"notify" withArguments:args];
}


/* Notification pane event handlers */

- (void)NPLog:(NSString *)message
{
	NSLog(@"%@", message);
}


/* WebView initialization */

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	if (sender == notificationPane) {
		// Test Javascript function calling
		[[notificationPane windowScriptObject] evaluateWebScript:@"testFunction()"];
	}
	else if (sender == notificationStatus) {
		// Add to system status bar
		float width = 100.0;
		statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:width] retain];
		[statusItem setView:notificationStatus];
	}
}

- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element 
    defaultMenuItems:(NSArray *)defaultMenuItems
{
    return nil; // disable contextual menu for the webView
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector
{
	/*
    if (aSelector == @selector(showMessage:)) {
        return NO;
    }
	*/

	return NO; // for development
}

@end
