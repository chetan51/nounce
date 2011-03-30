/*
 * Class Notification
 * 
 * Constructor options:
 *     ID
 *     application
 *     title
 *     content
 *     input                     (optional)
 *     iconPath                  (optional)
 *     wasHiddenCallback         (optional)
 *     inputWasSubmittedCallback (optional)
 */

var Notification = Class.extend(
{
	init: function(options, element)
	{
		this.options = $.extend({}, options);
		this.element = $(element);
		this._display();
	},
    
	ID: function()
	{
		return this.options.ID;
	},
    
	setTitle: function(title)
	{
		this.options.title = title;
	},
	 
	setContent: function(content)
	{
		this.options.content = content;
	},
	 
	setInput: function(input)
	{
		this.options.input = input;
	},
	 
	setIconPath: function(iconPath)
	{
		this.options.iconPath = iconPath;
	},
	 
	_display: function()
	{
		var input = this.element.children(".input");
		if (this.options.input &&
			!input.is(":visible")) {
			input.html(this.options.input);
			
			// Add event listeners for input
			input.find("input[type='submit']").click($.proxy(this._inputButtonWasClicked, this));
			input.find("input").focus($.proxy(this._inputWasFocused, this));
			input.find("input").blur($.proxy(this._inputWasBlurred, this));
			
			input.show();
		}
		else {
			input.hide();
		}
		
		// Add event listeners
		this.element.mouseenter($.proxy(this._wasHoveredIn, this));
		this.element.mouseleave($.proxy(this._wasHoveredOut, this));
		this.element.find("> .controls > .hide").click($.proxy(this._hideWasClicked, this));
		
		this.refreshDisplay();
		this.element.show();
	},
	
	refreshDisplay: function()
	{
		if (this.options.iconPath) {
			this.element.children(".icon").attr("src", "file://" + this.options.iconPath);
			this.element.children(".icon").show();
		}
		else {
			this.element.children(".icon").hide();
		}
		this.element.children(".title").html(this.options.title);
		this.element.children(".content").html(this.options.content);
	},

	focus: function()
	{
		this.element.find("input").animate({'opacity': ".95"});
	},

	blur: function()
	{
		if (!this.element.find("input").is(":focus")) {
			this.element.find("input").animate({'opacity': ".45"});
		}
	},
	
	hide: function()
	{
		this.element.remove();
		this.options.application.clearNotification(this);

		if (this.options.wasHiddenCallback) {
			this.options.wasHiddenCallback(this);
		}
	},
	
	_wasHoveredIn: function()
	{
		this.focus();
	},

	_wasHoveredOut: function()
	{
		this.blur();
	},

	_hideWasClicked: function()
	{
		this.hide();
	},

	_inputWasFocused: function()
	{
		this.focus();
	},

	_inputWasBlurred: function()
	{
		this.blur();
	},

	_inputButtonWasClicked: function(event)
	{
		var button = $(event.currentTarget);
		
		if (button.hasClass("submit") && this.options.inputWasSubmittedCallback) {
			this.options.inputWasSubmittedCallback(formForInput(button), this, button.attr("name"));
		}
		/*
		else if (button.hasClass("show-form")) {
			var targetForm = button.attr('rel');
			if (targetForm) {

			}
		}
		*/
		
		event.stopPropagation();               
		event.preventDefault();
	}
});

/*
 * Accessor functions
 */

function formForInput(input)
{
	return input.parents("form");
}
