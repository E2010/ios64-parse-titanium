# iOS 64bit Parse Module for Titanium

<h2> Release Note </h2>
<b>V 2.0</b><br/>
1. Upgrade to Parse Framework 1.14.2<br/>
2. New function added to Support migrated Parse server to own host<br/>
	      Parse.initParseWithConfig({
	        appId: Alloy.CFG.apikeys.parse.app_id,
	        clientKey: Alloy.CFG.apikeys.parse.client_key,
	        serverUrl: Alloy.CFG.apikeys.parse.server_url  // e.g.: "http://localhost:1337/parse"
	      });
       

<b>V 1.2.0</b><br/>
1. Add Push notification analytics function for tracking whether user open the app through push notification. This request NO change of the app code.<br/>
2. Upgrade to Parse Framework 1.10.0<br/>
3. Compiled with Appcelerator SDK 5.1.0.GA

<h2> About Module </h2>
This module is for iOS 64bit supporting. It is copied part of the functions from <a href="https://github.com/raymondkam/ios-parse-titanium-module">Raymond</a> and <a href="https://github.com/ewindso/ios-parse-titanium-module"> ewindso </a> with 2 new functions as below

<b>-(void)registerForSinglePushChannel</b>
subscribe to single channel with no need to unsuncribe from current channel first. ONLY the new channel passed to this function will exist after execution.

<b>-(void)unsubscribeFromAllChannels</b>
unsubscribe from all channels with no need to get current subscribtions.

<h2>Parse Framework</h2>
Verison 1.14.2

<h2>Limitation</h2>
ONLY part of the functions from the <a href="https://github.com/ewindso/ios-parse-titanium-module"> ewindso </a>'s version have been implemented. Specifically, only functions regarding Objects and Push notification implemented in this module. 

<h2> Start to build </h2>
<b>1.Titanium/Appcelerator</b><br/>
In order to compile and build in your own Titanium/Appcelerator environment. Please make sure the settings in this file (ios64-parse-titanium/iphone/titanium.xcconfig) is correct. 

2 values are important in this file, TITANIUM_SDK_VERSION and TITANIUM_SDK. Please notice whether there is a "~" in front of the folder path will make different result. Be sure the folder is correct in your own computer.

If you are not sure what value is correct. The simple way to get the correct setting is this. Creating a brand new ios Module in Titanium/Appcelerator studio with menu File -> New -> Mobile Module Project. Make sure select ios Module. Follow the steps and let the studio created a module automatically. Copy the content of file "iphone/titanium.xcconfig" in this new into the same file in parse module. Then it is good to compile.

<b>2.Xcode 7</b><br/>
This module has just been updated to be compile and build using Xcode 7. The only change is links to 2 libs, libz and libsqlite3. You can change it by yourself by <br/>
1. Opening the "iphone/iOS64TitaniumParse.xcodeproj" with Xcode
2. Delete the old libs links which marked red in project navigator.
3. Add new libs with the steps in the answersing part of this link. http://stackoverflow.com/questions/31420166/libsqlite3-dylib-and-libz-dylib-missing-in-xcode-7-how-do-i-use-parse
