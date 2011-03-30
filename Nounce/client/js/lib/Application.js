/*
 * Class Application
 * 
 * Constructor options:
 *     ID
 *     name
 *     wasHiddenCallback (optional)
 */

var Application = Class.extend(
{
	init: function(options, element)
	{
		this.options = $.extend({
			notifications: {}
		}, options);
		this.element = $(element);
		this._display();
	},
	 
	ID: function()
	{
		return this.options.ID;
	},

	notifications: function()
	{
		return this.options.notifications;
	},

	_display: function()
	{
		this.element.children(".name").html(this.options.name);
		this.element.show();
	},

	hide: function()
	{
		this.element.remove();
		
		if (this.options.wasHiddenCallback) {
			this.options.wasHiddenCallback(this);
		}
	},
	
	notificationWithID: function(notificationID)
	{
		return this.options.notifications[notificationID];
	},
	
	setNotification: function(notification)
	{
		if (!this.options.notifications[notification.ID()]) {
			this.element.children(".notifications").append(notification.element);
		}
		this.options.notifications[notification.ID()] = notification;
	},

	clearNotification: function(notification)
	{
		this.options.notifications[notification.ID()] = null;
		
		var numberOfNotifications = 0;
		for (var n in this.options.notifications) {
			if (this.options.notifications[n]) {
				numberOfNotifications++;
			}
		}
		if (numberOfNotifications == 0) {
			this.hide();
		}
	}
});
