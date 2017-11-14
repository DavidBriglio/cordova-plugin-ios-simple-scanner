import Foundation
import UIKit

@available(iOS 10, *)
@objc(BarcodeScanner) class BarcodeScanner : CDVPlugin {
    
    var scannerController:BarcodeScannerController? = nil
    
    @objc(capture:)
    func capture(command: CDVInvokedUrlCommand) {
            let scannerController:BarcodeScannerController = BarcodeScannerController(
                                                                orientation:command.arguments[0] as? String ?? "",
                                                                showguide:command.arguments[1] as? String ?? "true",
                                                                callback:command.callbackId,
                                                                parent:self)
            scannerController.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
            scannerController.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
            self.viewController?.present(scannerController, animated:true, completion:nil)
        }
    }
}