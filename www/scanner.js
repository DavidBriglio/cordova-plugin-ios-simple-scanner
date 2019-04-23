var exec = require('cordova/exec');

module.exports = {
  scanBarcode: function(orientation, showGuide, successCallback, errorCallback) {
    if (!successCallback && !errorCallback) {
      // Use promise if no callbacks were provided
      return new Promise((resolve, reject) => {
        exec(resolve, reject, "BarcodeScanner", "capture", [orientation, showGuide ? "true" : "false"]);
      });
    } else {
      exec(successCallback, errorCallback, "BarcodeScanner", "capture", [orientation, showGuide ? "true" : "false"]);
    }
  }
};