/*
 * Globals and constants
 */

notificationStatusIsSelected = false;
notifications = [];

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
	updateNotificationsCounterAll();
}

function selectNotificationIconsDiv()
{
	notificationIconsDiv().removeClass("default").addClass("selected");	
}

function unselectNotificationIconsDiv()
{
	notificationIconsDiv().removeClass("selected").addClass("default");	
}

function updateNotificationsCounterAll() {
	var counter = 0;
	for (key in notifications) {
		counter++;
	}
	notificationCounterAllDiv().html(counter);
}

/*
 * Event listeners
 */

function notificationIconsDivWasClicked(e)
{
	if (!notificationStatusIsSelected) {
		selectNotificationIconsDiv();
		window.NotificationStatusController.notificationStatusWasSelectedForApplicationWithID_(null);
	}
	else {
		unselectNotificationIconsDiv();
		window.NotificationStatusController.notificationStatusWasUnselected();
	}
	
	notificationStatusIsSelected = !notificationStatusIsSelected;
}

/*
 * AppController event listeners
 */
