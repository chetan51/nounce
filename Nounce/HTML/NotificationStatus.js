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

function notificationIconsDiv()
{
	return $("#notification-icons");
}

function notificationCounterDiv()
{
	return notificationIconsDiv().children("#counter");
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
	notificationIconsDiv().click(notificationIconsDivWasClicked);
	
	/* Testing
	notify("TestApp-0", "test notification", "testing ...", "<form><input type='text' name='reply' style='width: 100%; box-sizing: border-box; -webkit-box-sizing: border-box;'><input type='submit' name='reply' class='submit' value='Reply'><input type='submit' name='forward' class='submit' value='Forward'></form>", "TestApp", "Test Application");
	notify("TestApp-1", "test notification 2", "testing again ...", null, "TestApp", "Test Application");
	notify("TestApp2-0", "test notification 3", "testing again 2 ...", "<form><input type='submit' name='reply' class='submit' value='Reply'><input type='text' name='reply'><input type='submit' name='forward' class='submit' value='Forward'></form>", "TestApp2", "Test Application 2");
	*/
});

/*
 * Functions
 */

function notify (notificationID, notificationTitle, notificationContent, notificationInput, fromAppID, fromAppName)
{
	notifications[notificationID] = "new";
	updateNotificationsCounters();
}

function hideNotification (notificationID)
{
	notifications[notificationID] = null;
	updateNotificationsCounters();
}

function selectNotificationStatus()
{
	notificationIconsDiv().removeClass("default").addClass("selected");
	notificationStatusIsSelected = true;
}

function unselectNotificationStatus()
{
	notificationIconsDiv().removeClass("selected").addClass("default");
	notificationStatusIsSelected = false;
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
	notificationCounterAllDiv().html(allCounter);
}

/*
 * Event listeners
 */

function notificationIconsDivWasClicked(e)
{
	if (!notificationStatusIsSelected) {
		selectNotificationStatus();
		window.NotificationStatusController.notificationStatusWasSelectedForApplicationWithID_(null);
	}
	else {
		unselectNotificationStatus();
		window.NotificationStatusController.notificationStatusWasUnselected();
	}
}