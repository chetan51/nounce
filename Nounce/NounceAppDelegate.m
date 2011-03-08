//
//  NounceAppDelegate.m
//  Nounce
//
//  Created by Chetan Surpur on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NounceAppDelegate.h"
#import "JSON.h"

#define DEFAULTSTATUSITEMLENGTH 100.0


@implementation NounceAppDelegate

@synthesize notificationWindow;

/* App loading and unloading */

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Object variables
	notificationCenter = [NCNotificationCenter sharedNotificationCenter];
	
	// Start listening for notifications
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
	
	// Listen for focus gained / lost events (TODO: make this user-configurable)
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(UIHideGeneralNotifications)
	 name:NSWindowDidResignKeyNotification
	 object:notificationWindow];
}

- (void) setupNotificationPane
{
	// Set up the delegate of the notificationPane for relevant events
    [notificationPane setDrawsBackground:NO];
    [notificationPane setUIDelegate:self];
    [notificationPane setFrameLoadDelegate:self];
	[notificationPane setEditingDelegate:self];
    
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
    NSString *htmlPath = [resourcesPath stringByAppendingString:@"/NotificationPane.html"];
    [[notificationPane mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]]];
}

- (void) setupNotificationStatus
{
	// Create notification status WebView
    float width = DEFAULTSTATUSITEMLENGTH;
    float height = [[NSStatusBar systemStatusBar] thickness];
    NSRect viewFrame = NSMakeRect(0, 0, width, height);
	notificationStatus = [[[WebView alloc] initWithFrame:viewFrame frameName:@"NCNotificationStatus" groupName:@"NCNotificationUI"] autorelease];
	[[[notificationStatus mainFrame] frameView] setAllowsScrolling:NO];
	
	// Set up the delegate of the notificationStatus for relevant events
    [notificationStatus setDrawsBackground:NO];
    [notificationStatus setUIDelegate:self];
    [notificationStatus setFrameLoadDelegate:self];
	[notificationStatus setEditingDelegate:self];
	
	// Configure notificationPane to let JavaScript talk to this object
    [[notificationStatus windowScriptObject] setValue:self forKey:@"AppController"];
	
    // Load the HTML content
    NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
    NSString *htmlPath = [resourcesPath stringByAppendingString:@"/NotificationStatus.html"];
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
	 name:@"Nounce_PostNotification"
	 object:nil];
}

- (void) notificationPosted:(NSNotification *)message
{
	NCNotification *notification = [NSKeyedUnarchiver unarchiveObjectWithData:[[message userInfo]
																				objectForKey:@"notification"]];
	[self notify:notification];
}

- (void) notify:(NCNotification *)notification
{
	NSLog(@"New notification from %@: %@ - %@", [[notification fromApp] ID], [notification title], [notification content]);
	[notificationCenter notify:notification];
	[self UINotify:notification];
}


/* UI functions */

- (void) UINotify:(NCNotification *)notification
{
	NSArray *args = [NSArray arrayWithObjects:
					 [notification ID],
					 [notification title] ? [notification title] : (NSString *)[NSNull null],
					 [notification content] ? [notification content] : (NSString *)[NSNull null],
					 [notification input] ? [notification input] : (NSString *)[NSNull null],
					 [[notification fromApp] ID],
					 [[notification fromApp] name] ? [[notification fromApp] name] : (NSString *)[NSNull null],
					 nil];
	[[notificationPane windowScriptObject] callWebScriptMethod:@"notify" withArguments:args];
	[[notificationStatus windowScriptObject] callWebScriptMethod:@"notify" withArguments:args];
}

- (void) UIShowGeneralNotifications
{
	[NSApp activateIgnoringOtherApps:YES]; // allows windows of this app to become front
	[notificationWindow setAlphaValue:0.0];
	[notificationWindow makeKeyAndOrderFront:nil];
    [[notificationWindow animator] setAlphaValue:1.0];
	
	[[notificationStatus windowScriptObject] callWebScriptMethod:@"UIShowGeneralNotifications" withArguments:nil];
}

- (void) UIHideGeneralNotifications
{
	[NSApp hide:nil]; // give focus back to previous app
	[notificationWindow orderOut:nil];
	
	[[notificationStatus windowScriptObject] callWebScriptMethod:@"UIHideGeneralNotifications" withArguments:nil];
}


/* Notification pane / status indicator event handlers */

- (void)NCLog:(NSString *)message
{
	NSLog(@"%@", message);
}

- (void) NCShowGeneralNotificationsClicked
{
	[self UIShowGeneralNotifications];
}

- (void) NCHideGeneralNotificationsClicked
{
	[self UIHideGeneralNotifications];
}

- (void) NCNotificationInputSubmittedWithID:(NSString *)notificationID
								   formName:(NSString *)formName
								 buttonName:(NSString *)buttonName
								  inputData:(NSString *)inputData
{
	SBJsonParser *parser = [SBJsonParser new];
	NSDictionary *inputDataDictionary = [parser objectWithString:inputData error:nil];
	
	[notificationCenter submitFormForNotificationWithID:notificationID inputData:inputDataDictionary formName:formName buttonName:buttonName];

	[parser release];
}


/* WebView initialization */

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	if (sender == notificationStatus) {
		// Add to system status bar
		float width = DEFAULTSTATUSITEMLENGTH;
		statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:width] retain];
		[statusItem setView:notificationStatus];
	}
}

- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element 
    defaultMenuItems:(NSArray *)defaultMenuItems
{
    return nil; // disable contextual menu
}

- (BOOL)webView:(WebView *)webView shouldChangeSelectedDOMRange:(DOMRange *)currentRange 
	 toDOMRange:(DOMRange *)proposedRange 
	   affinity:(NSSelectionAffinity)selectionAffinity 
 stillSelecting:(BOOL)flag
{
	if (webView == notificationStatus) {
		return NO; // disable text selection
	}
	else {
		return YES;
	}
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
