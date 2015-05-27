// This is a test harness for your module
// You should do something interesting in this harness
// to test out the module and to provide instructions
// to users on how to use it by example.


// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});
var label = Ti.UI.createLabel();
win.add(label);
win.open();

// TODO: write your module tests here
var ios64titaniumparse = require('com.ez2010.ios64parse');
Ti.API.info("module is => " + ios64titaniumparse);

label.text = ios64titaniumparse.example();

Ti.API.info("module exampleProp is => " + ios64titaniumparse.exampleProp);
ios64titaniumparse.exampleProp = "This is a test value";

if (Ti.Platform.name == "android") {
	var proxy = ios64titaniumparse.createExample({
		message: "Creating an example Proxy",
		backgroundColor: "red",
		width: 100,
		height: 100,
		top: 100,
		left: 150
	});

	proxy.printMessage("Hello world!");
	proxy.message = "Hi world!.  It's me again.";
	proxy.printMessage("Hello world!");
	win.add(proxy);
}

