var exec = require('cordova/exec');

module.exports = {
  scanBarcode: function(orientation, showGuide, successCallback, errorCallback) {
    exec(successCallback, errorCallback, "BarcodeScanner", "capture", [orientation, showGuide ? "true" : "false"]);
  }
};