# cordova-plugin-ios-simple-scanner
Simple iOS Barcode Scanner for Cordova. **PDF417 Supported!**

# How To Use
Install the plugin using:
```terminal
cordova plugin add cordova-plugin-ios-simple-scanner

//or

cordova plugin add https://github.com/DavidBriglio/cordova-plugin-ios-simple-scanner
```

Call the scan method with the following parameters:

|Parameter|Type|Description|
|---|---|---|
|orientation|String|The locked orientation to show the scanner in. Can be: "portrait", "landscapeLeft", "landscapeRight", "portraitUpsideDown".|
|show guide|Boolean|If set to true, the guide box and 'Scanning..' label will be shown.|
|success callback|Function|Method to handle successfully scanning a barcode. This method will be passed an object with two string attributes: "format" - Type of the barcode scanned, "data" - all data contained within the barcode (string).|
|error callback|Function|Method to handle all errors / cancelling the scanner. A status message will be passed in.|

Example:
```javascript
var successCallback = function(value) {
    console.log("Format Found: " + value.format, "Data: " + value.data);
};

var errorCallback = function(message) {
    console.log("Error Reading Barcode: " + message);
};

// Scan as landscapeLeft, showing the box guide, with success and error callbacks
cordova.plugins.ios.simpleScanner("landscapeLeft", true, successCallback, errorCallback);
```

# Supported Formats
Currently the only supported format is **PDF417**, but more formats will be supported soon.

# Known Issues
If the scan method is called while the scanner is already running, the scanner will freeze. If you are planning on opening another instance of the scanner, make sure the current one is not scanning.

Since this plugin creates a view to show the user, there will be a warning about time taken to run the plugin that will suggest running in a background thread.

# Images
All icon images were taken and modified from [ionicons](http://ionicons.com/) (100% Free and Open Source - MIT).

# License
MIT License, please look at the LICENSE file.