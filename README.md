# iOS 64bit Parse Module for Titanium

<h2> About Module </h2>
This module is for iOS 64bit supporting. It is copied part of the functions from <a href="https://github.com/raymondkam/ios-parse-titanium-module">Raymond</a> and <a href="https://github.com/ewindso/ios-parse-titanium-module"> ewindso </a> with 2 new functions as below

<b>-(void)registerForSinglePushChannel</b>
subscribe to single channel with no need to unsuncribe from current channel first. ONLY the new channel passed to this function will exist after execution.

<b>-(void)unsubscribeFromAllChannels</b>
unsubscribe from all channels with no need to get current subscribtions.

<h2>Parse Framework</h2>
Verison 1.7.2

<h2>Limitation</h2>
ONLY part of the functions from the <a href="https://github.com/ewindso/ios-parse-titanium-module"> ewindso </a>'s version have been implemented. Specifically, only functions regarding Objects and Push notification implemented in this module. 

<h2> Start to build </h2>
In order to compile and build in your own Titanium/Appcelerator environment. Please make sure the settings in this file (ios64-parse-titanium/iphone/titanium.xcconfig) is correct. 

2 values are important in this file, TITANIUM_SDK_VERSION and TITANIUM_SDK. 

If you are not sure what value is correct. The simple way to get the correct setting is this. Creating a brand new ios Module in Titanium/Appcelerator studio with menu File -> New -> Mobile Module Project. Make sure select ios Module. Follow the steps and let the studio created a module automatically. Copy the content of file "iphone/titanium.xcconfig" in this new into the same file in parse module. Then it is good to compile.