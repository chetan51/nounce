/*
 * Globals and constants
 */

notificationStatusIsSelected = false;
notifications = [];

function isNotificationStatusSelected()
{
	return notificationStatusIsSelected;
}

/*
 * DOM accessors
 */

function statusAreaDiv()
{
	return $("#status-area");
}

function statusAreaBackgroundDiv()
{
	return $("#status-area-background");
}

function notificationCounterDiv()
{
	return statusAreaDiv().children("#counter");
}

function notificationCounterAllDiv()
{
	return notificationCounterDiv().children(".all");
}

function notificationCounterNewDiv()
{
	return notificationCounterDiv().children(".new");
}

/*
 * Initialization
 */

$(document).ready(function() {
	// Add event listeners
	statusAreaDiv().click(statusAreaDivWasClicked);
	
	/* Testing
	notify("TestApp-0", "test notification", "testing ...", "<form><input type='text' name='reply' style='width: 100%; box-sizing: border-box; -webkit-box-sizing: border-box;'><input type='submit' name='reply' class='submit' value='Reply'><input type='submit' name='forward' class='submit' value='Forward'></form>", null, "TestApp", "Test Application");
	notify("TestApp-1", "test notification 2", "testing again ...", null, null, "TestApp", "Test Application");
	notify("TestApp2-0", "test notification 3", "testing again 2 ...", "<form><input type='submit' name='reply' class='submit' value='Reply'><input type='text' name='reply'><input type='submit' name='forward' class='submit' value='Forward'></form>", null, "TestApp2", "Test Application 2");
	*/
});

/*
 * Functions
 */

function notify (notificationID, notificationTitle, notificationContent, notificationInput, notificationIconPath, fromAppID, fromAppName, isUpdate)
{
	if (!isUpdate || 
		isUpdate && !notifications[notificationID]) {
		notifications[notificationID] = "new";
		
		updateNotificationsCounters();
	}
}

function hideNotification (notificationID)
{
	notifications[notificationID] = null;
	updateNotificationsCounters();
}

function selectNotificationStatus()
{
	statusAreaBackgroundDiv().removeClass("default").addClass("selected");
	markAllNotificationsAsViewed();
	updateNotificationsCounters();
	notificationStatusIsSelected = true;
}

function unselectNotificationStatus()
{
	statusAreaBackgroundDiv().removeClass("selected").addClass("default");
	markAllNotificationsAsViewed();
	updateNotificationsCounters();
	notificationStatusIsSelected = false;
}

function markAllNotificationsAsViewed()
{
	for (key in notifications) {
		if (notifications[key] == "new") {
			notifications[key] = "viewed";
		}
	}
}

function updateNotificationsCounters() {
	var allCounter = 0, newCounter = 0;
	for (key in notifications) {
		if (notifications[key] == "new") {
			allCounter++;
			newCounter++;
		}
		else if (notifications[key] == "viewed") {
			allCounter++;
		}
	}
	
	if (newCounter > 0) {
		notificationCounterNewDiv().html(newCounter);
		notificationCounterAllDiv().hide();
		notificationCounterNewDiv().show();
	}
	else {
		notificationCounterNewDiv().hide();
		
		if (allCounter > 0) {
			notificationCounterAllDiv().html(allCounter);
			notificationCounterAllDiv().show();
		}
		else {
			notificationCounterAllDiv().hide();
		}
	}	
}

/*
 * Event listeners
 */

function statusAreaDivWasClicked(e)
{
	if (!notificationStatusIsSelected) {
		selectNotificationStatus();
		window.NotificationStatusController.UINotificationStatusWasSelectedForApplicationWithID_(null);
	}
	else {
		unselectNotificationStatus();
		window.NotificationStatusController.UINotificationStatusWasUnselected();
	}
}