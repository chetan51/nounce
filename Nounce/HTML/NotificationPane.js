/*
 * DOM accessors
 */

function applicationsDiv()
{
	return $("#applications");
}

function applicationDivMold()
{
	return $("#molds > .application");
}

function notificationDivMold()
{
	return $("#molds > .notification");
}

function applicationDivWithID (appID)
{
	return $("#"+jqID(appID), applicationsDiv());
}

function notificationDivWithID (notificationID, applicationDiv)
{
	return $("#"+jqID(notificationID));
}

function applicationDivForNotificationDiv (notificationDiv)
{
	return notificationDiv.parents(".application");
}

function formForInput (input)
{
	return input.parents("form");
}

function notificationDivForInput (input)
{
	return input.parents(".notification");
}

function controlsForNotificationDiv (notificationDiv)
{
	return $("> .controls", notificationDiv);
}

function hideButtonForNotificationDiv (notificationDiv)
{
	return $("> .hide", controlsForNotificationDiv(notificationDiv));
}

function notificationDivForHideButton (button)
{
	return button.parents(".notification");
}

/*
 * Initialization
 */

$(document).ready(function() {
	/* Testing
	notify("TestApp-0", "test notification", "testing ...", "<form name='test'><input type='text' name='reply' style='width: 100%; box-sizing: border-box; -webkit-box-sizing: border-box;'><input type='submit' name='reply' class='submit' value='Reply'><input type='submit' name='forward' class='submit' value='Forward'></form>", null, "com.yourcompany.TestApp", "Test Application");
	notify("TestApp-1", "test notification 2", "testing again ...", null, null, "com.yourcompany.TestApp", "Test Application");
	notify("TestApp2-0", "test notification 3", "testing again 2 ...", "<form><input type='submit' name='reply' class='submit' value='Reply'><input type='text' name='reply'><input type='submit' name='forward' class='submit' value='Forward'></form>", null, "TestApp2", "Test Application 2");
	*/
});

/*
 * Functions
 */

function notify (notificationID, notificationTitle, notificationContent, notificationInput, notificationIconPath, fromAppID, fromAppName, isUpdate)
{
	var applicationDiv = applicationDivWithID(fromAppID);
	if (!applicationDiv.length) {
		applicationDiv = applicationDivMold().clone();
		applicationDiv.attr("id", fromAppID);
		applicationsDiv().append(applicationDiv);
	}
	
	applicationDiv.children(".name").html(fromAppName);
	
	var notificationDiv = notificationDivWithID(notificationID, applicationDiv);
	if (!notificationDiv.length) {
		notificationDiv = notificationDivMold().clone();
		notificationDiv.attr("id", notificationID);
		applicationDiv.children(".notifications").append(notificationDiv);
		
		if (notificationInput) {
			notificationDiv.children(".input").html(notificationInput);
			notificationDiv.children(".input").show();
			
			// Add event listeners
			notificationDiv.children(".input").find("input[type='submit']").click(notificationInputButtonWasClicked);
			notificationDiv.children(".input").find("input").focus(notificationInputWasFocused).blur(notificationInputWasBlurred);
		}
		
		// Add event listeners
		notificationDiv.hover(notificationWasHoveredIn, notificationWasHoveredOut);
		hideButtonForNotificationDiv(notificationDiv).click(notificationHideWasClicked);
	}
	if (notificationIconPath) {
		notificationDiv.children(".icon").attr("src", "file://" + notificationIconPath);
		notificationDiv.children(".icon").show();
	}
	else {
		notificationDiv.children(".icon").hide();
	}
	notificationDiv.children(".title").html(notificationTitle);
	notificationDiv.children(".content").html(notificationContent);
	
	applicationsDiv().show();
}

function hideNotification (notificationID)
{
	var notificationDiv = notificationDivWithID(notificationID);
	var applicationDiv = applicationDivForNotificationDiv(notificationDiv);
	
	notificationDiv.remove();
	
	if (!applicationDiv.children(".notifications").children().length) {
		applicationDiv.remove();
	}
	
	if (!applicationsDiv().children().length) {
		applicationsDiv().hide();
		window.NotificationPaneController.UINotificationPaneWasHidden();
	}
	
	window.NotificationPaneController.UINotificationWasHidden_(notificationID);
}

function submitNotificationInputForm(form, notificationID, buttonName)
{
	var inputData = JSON.stringify(form.serializeObject());
	window.NotificationPaneController.UIInputWasSubmittedForNotificationWithID_formName_buttonName_inputData_(notificationID, form.attr("name"), buttonName, inputData);
	
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

function notificationWasHoveredIn(e)
{
	focusNotificationDiv($(this));
}

function notificationWasHoveredOut(e)
{
	blurNotificationDiv($(this));
}

function focusNotificationDiv(notificationDiv)
{
	notificationDiv.find("input").animate({'opacity': ".95"});
}

function blurNotificationDiv(notificationDiv)
{
	if (!notificationDiv.find("input").is(":focus")) {
		notificationDiv.find("input").animate({'opacity': ".45"});
	}
}

function notificationInputButtonWasClicked(e)
{	
	if ($(this).hasClass("submit")) {
		submitNotificationInputForm(formForInput($(this)), notificationDivForInput($(this)).attr("id"), $(this).attr("name"));
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

function notificationInputWasFocused(e)
{
	focusNotificationDiv(notificationDivForInput($(this)));
}

function notificationInputWasBlurred(e)
{
	blurNotificationDiv(notificationDivForInput($(this)));
}

function notificationHideWasClicked(e)
{
	var notificationDiv = notificationDivForHideButton($(this));
	hideNotification(notificationDiv.attr("id"));
}

/*
 * NotificationPaneController event listeners
 */

/*
 * jQuery extensions / plugins
 */

jQuery.extend(jQuery.expr[':'], {
    focus: function(element) { 
        return element == document.activeElement; 
    }
});

function jqID(myID) { 
	return myID.replace(/(:|\.)/g,'\\$1');
}
