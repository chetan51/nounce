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

function getTotalApplicationViews () {
	return applicationViews.length;
}

function getTotalNotificationViews () {
	var totalNotificationViews = 0;
	for (var a in applicationViews) {
		var applicationView = applicationViews[a];
		totalNotificationViews += applicationView.getTotalNotifications();
	}
	return totalNotificationViews;
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

function getNotificationCounterDiv()
{
	return getNotificationIconsDiv().children("#counter");
}

function getNotificationCounterAllDiv()
{
	return getNotificationCounterDiv().children(".all");
}

function getNotificationCounterNewDiv()
{
	return getNotificationCounterDiv().children(".new");
}

/*
 * Initialization
 */

$(document).ready(function() {
	/* Testing
	notify("TestApp-0", "test notification", "testing ...", "<form><input type='text' name='reply' style='width: 100%; box-sizing: border-box; -webkit-box-sizing: border-box;'><input type='submit' name='reply' class='submit' value='Reply'><input type='submit' name='forward' class='submit' value='Forward'></form>", "TestApp", "Test Application");
	notify("TestApp-1", "test notification 2", "testing again ...", null, "TestApp", "Test Application")
	notify("TestApp2-0", "test notification 3", "testing again 2 ...", 
"<form><input type='submit' name='reply' class='submit' value='Reply'><input type='text' name='reply'><input type='submit' name='forward' class='submit' value='Forward'></form>", "TestApp2", "Test Application 2");
	*/
	
	// Add event listeners
	getNotificationIconsDiv().click(clickedNotificationIconsDiv);
});

/*
 * Functions
 */

function notify (notificationID, notificationTitle, notificationContent, notificationInput, fromAppID, fromAppName)
{
	var applicationView = getApplicationView(fromAppID);
	var notificationView = new NotificationView(notificationID, fromAppID, notificationTitle, notificationContent, notificationInput);
	
	if (!applicationView) {
		applicationView = new ApplicationView(fromAppID, fromAppName);
		setApplicationView(applicationView);
	}
	
	applicationViews[fromAppID].setNotification(notificationView);

	getPlaceholderDiv().hide();
	getApplicationsDiv().show();
	applicationView.updateDisplay();
	notificationView.updateDisplay();
	
	updateNotificationsCounterAll();
}

function selectNotificationIconsDiv()
{
	getNotificationIconsDiv().removeClass("default").addClass("selected");	
}

function unselectNotificationIconsDiv()
{
	getNotificationIconsDiv().removeClass("selected").addClass("default");	
}

function updateNotificationsCounterAll() {
	getNotificationCounterAllDiv().html(getTotalNotificationViews());
}

function submitNotificationInputForm(form, notificationID, buttonName)
{
	var inputData = JSON.stringify(form.serializeObject());
	window.AppController.NCNotificationInputSubmittedWithID_formName_buttonName_inputData_(notificationID, form.attr("name"), buttonName, inputData);
	
	// Reset form
	$(':input',form)
	.not(':button, :submit, :reset, :hidden')
	.val('')
	.removeAttr('checked')
	.removeAttr('selected');
}

/*
 * Event listeners
 */

function clickedNotificationIconsDiv(e)
{
	if (!notificationPaneVisible) {
		window.AppController.NCShowGeneralNotificationsClicked();
	}
	else {
		window.AppController.NCHideGeneralNotificationsClicked();
	}
}

function notificationHoveredIn(e)
{
	$(this).find("input").animate({'opacity': ".95"});
}

function notificationHoveredOut(e)
{
	if (!$(this).find("input").is(":focus")) {
		$(this).find("input").animate({'opacity': ".45"});
	}
}

function notificationInputButtonClicked(e, button, notificationID)
{
	if (button.hasClass("submit")) {
		submitNotificationInputForm(button.parents("form"), notificationID, button.attr("name"));
	}
	/*
	else if (button.hasClass("show-form")) {
		var targetForm = button.attr('rel');
		if (targetForm) {

		}
	}
	*/
	
	e.stopPropagation();               
	e.preventDefault();
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
	
	self.getTotalNotifications = function()
	{
		var totalNotifications = 0;
		for (var n in self.notifications) {
			totalNotifications++;
		}
		return totalNotifications;
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

var NotificationView = function (ID, fromAppID, title, content, input)
{
	var self = this;

	self.ID        = ID;
	self.fromAppID = fromAppID;
	self.title     = title;
	self.content   = content;
	self.input     = input;
	self.display   = null;
	
	self.updateDisplay = function()
	{
		if (!self.display) {
			self.display = $("#molds > .notification").clone();
			getApplicationView(self.fromAppID).display.children(".notifications").append(self.display);
			
			if (self.input) {
				self.display.children(".input").html(self.input);
				self.display.children(".input").show();
				
				// Add event listeners
				self.display.children(".input").find("input[type='submit']").click(function(e) {
					notificationInputButtonClicked(e, $(this), self.ID);
				});
			}
				
			// Add event listeners
			self.display.hover(notificationHoveredIn, notificationHoveredOut);
		}

		self.display.children(".title").html(self.title);
		self.display.children(".content").html(self.content);
	}
}

/*
 * jQuery extensions / plugins
 */

jQuery.extend(jQuery.expr[':'], {
    focus: function(element) { 
        return element == document.activeElement; 
    }
});
