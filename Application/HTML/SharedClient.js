/*
 * Defaults and constants
 */


/*
 * Global variables
 */

applicationViews = {};
notificationPaneVisible = false;

/*
 * Accessors and setters of global variables
 */

function getApplicationView (ID) {
	return applicationViews[ID];
}

function setApplicationView (applicationView) {
	applicationViews[applicationView.ID] = applicationView;
}

/*
 * DOM accessors
 */

function getApplicationsDiv()
{
	return $("#applications");
}

function getPlaceholderDiv()
{
	return $("#placeholder");
}

function getNotificationIconsDiv()
{
	return $("#notification-icons");
}

/*
 * Initialization
 */

$(document).ready(function() {
	/* Testing
	notify("0", "test notification", "testing ...", "TestApp", "Test Application");
	notify("1", "test notification 2", "testing again ...", "TestApp", "Test Application");
	notify("0", "test notification 3", "testing again 2 ...", "TestApp2", "Test Application 2");
	 */
	getApplicationsDiv().hover(hoveredApplicationsDiv);
	getNotificationIconsDiv().click(clickedNotificationIconsDiv);
});

/*
 * Functions
 */

function notify (notificationID, notificationTitle, notificationContent, fromAppID, fromAppName)
{
	var applicationView = getApplicationView(fromAppID);
	var notificationView = new NotificationView(notificationID, fromAppID, notificationTitle, notificationContent);
	
	if (!applicationView) {
		applicationView = new ApplicationView(fromAppID, fromAppName);
		setApplicationView(applicationView);
	}
	
	applicationViews[fromAppID].setNotification(notificationView);

	getPlaceholderDiv().hide();
	getApplicationsDiv().show();
	applicationView.updateDisplay();
	notificationView.updateDisplay();
}

function selectNotificationIconsDiv()
{
	getNotificationIconsDiv().removeClass("default").addClass("selected");	
}

function unselectNotificationIconsDiv()
{
	getNotificationIconsDiv().removeClass("selected").addClass("default");	
}

/*
 * Event listeners
 */

function hoveredApplicationsDiv(e) {
	window.AppController.NCLog_("hovered over applications div");
}

function clickedNotificationIconsDiv(e)
{
	if (!notificationPaneVisible) {
		window.AppController.NCShowGeneralNotificationsClicked();
	}
	else {
		window.AppController.NCHideGeneralNotificationsClicked();
	}
}

/*
 * AppController event listeners
 */

function UIShowGeneralNotifications()
{
	selectNotificationIconsDiv();
	notificationPaneVisible = true;
}

function UIHideGeneralNotifications()
{
	unselectNotificationIconsDiv();
	notificationPaneVisible = false;
}

/*
 * View classes
 */

var ApplicationView = function (ID, name)
{
	var self = this;

	self.ID            = ID;
	self.name          = name;
	self.notifications = {};
	self.display       = null;
	
	self.setNotification = function (notification)
	{
		var existingNotification = self.notifications[notification.ID];
		
		if (existingNotification) {
			notification.display = existingNotification.display;
		}
		
		self.notifications[notification.ID] = notification;
	}
	
	self.updateDisplay = function()
	{
		if (!self.display) {
			self.display = $("#molds > .application").clone();
			getApplicationsDiv().append(self.display);
		}
		
		self.display.children(".name").html(self.name);
	}
}

var NotificationView = function (ID, fromAppID, title, content)
{
	var self = this;

	self.ID        = ID;
	self.fromAppID = fromAppID;
	self.title     = title;
	self.content   = content;
	self.display   = null;
	
	self.updateDisplay = function()
	{
		if (!self.display) {
			self.display = $("#molds > .notification").clone();
			getApplicationView(self.fromAppID).display.children(".notifications").append(self.display);
		}

		self.display.children(".title").html(self.title);
		self.display.children(".content").html(self.content);
	}
}
