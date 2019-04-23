
import UIKit
import AVFoundation

class BarcodeScannerController : UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet var messageLabel:UILabel!
    @IBOutlet weak var cancelImageButton: UIButton!
    @IBOutlet weak var flashImageButton: UIButton!
    var showGuide:String = "true"
    var pluginOrientation:String = ""
    var originalOrientation:UIInterfaceOrientation?
    var callbackId:String?
    var parentPlugin:CDVPlugin?
    var captureSession:AVCaptureSession?
    var qrCodeFrameView:UIView?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var cancelButton:UIButton?
    var flashButton:UIButton?
    var lineMidLeft:UILabel?
    var lineMidRight:UILabel?
    var lineBottomLeft:UILabel?
    var lineTopLeft:UILabel?
    var lineBottomRight:UILabel?
    var lineTopRight:UILabel?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    convenience init(orientation:String, showguide:String, callback:String, parent:CDVPlugin) {
        self.init(nibName:nil, bundle:nil)
        
        pluginOrientation = orientation
        showGuide = showguide
        callbackId = callback
        parentPlugin = parent
        
        switch(UIDevice.current.orientation) {
            case .landscapeLeft:
                originalOrientation = UIInterfaceOrientation.landscapeLeft
                break;
            case .landscapeRight:
                originalOrientation = UIInterfaceOrientation.landscapeRight
                break;
            case .portraitUpsideDown:
                originalOrientation = UIInterfaceOrientation.portraitUpsideDown
                break;
            default:
                originalOrientation = UIInterfaceOrientation.portrait
                break;
        }
        
        switch(pluginOrientation) {
            case "landscapeRight":
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                break;
            case "landscapeLeft":
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                break;
            case "portraitUpsideDown":
                UIDevice.current.setValue(UIInterfaceOrientation.portraitUpsideDown.rawValue, forKey: "orientation")
                break;
            default:
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
    
    override func viewDidLoad(){
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            return
        }

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // Initialize the captureSession object.
            captureSession = AVCaptureSession()

            // Set the input device on the capture session.
            captureSession?.addInput(input)

            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)

            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.qr]

            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            switch(pluginOrientation) {
                case "landscapeRight":
                    videoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
                    break;
                case "landscapeLeft":
                    videoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
                    break;
                case "portraitUpsideDown":
                    videoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portraitUpsideDown
                    break;
                default:
                    videoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            }
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resize
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            qrCodeFrameView = UIView()

            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
                
            if(showGuide == "true") {
                lineMidLeft = UILabel(frame: CGRect(
                    x:view.bounds.size.width / 7, 
                    y:(view.bounds.size.height / 2) - (view.bounds.size.height / 8), 
                    width:2, 
                    height: view.bounds.size.height / 4)
                )
                if let lineMidLeft = lineMidLeft {
                    lineMidLeft.backgroundColor = .white
                    view.addSubview(lineMidLeft)
                    view.bringSubviewToFront(lineMidLeft)
                }
                
                lineMidRight = UILabel(frame: CGRect(
                    x:view.bounds.size.width - (view.bounds.size.width / 7), 
                    y:(view.bounds.size.height / 2) - (view.bounds.size.height / 8), 
                    width:2, 
                    height: view.bounds.size.height / 4)
                )
                if let lineMidRight = lineMidRight {
                    lineMidRight.backgroundColor = .white
                    view.addSubview(lineMidRight)
                    view.bringSubviewToFront(lineMidRight)
                }
                
                lineBottomLeft = UILabel(frame: CGRect(
                    x:view.bounds.size.width - (view.bounds.size.width / 7) - (view.bounds.size.width / 12) + 2, 
                    y:(view.bounds.size.height / 2) - (view.bounds.size.height / 8), 
                    width: view.bounds.size.width / 12, 
                    height: 2)
                )
                if let lineBottomLeft = lineBottomLeft {
                    lineBottomLeft.backgroundColor = .white
                    view.addSubview(lineBottomLeft)
                    view.bringSubviewToFront(lineBottomLeft)
                }
                
                lineTopLeft = UILabel(frame: CGRect(
                    x:view.bounds.size.width - (view.bounds.size.width / 7) - (view.bounds.size.width / 12) + 2, 
                    y:(view.bounds.size.height / 2) + (view.bounds.size.height / 8) - 2, 
                    width: view.bounds.size.width / 12, 
                    height: 2)
                )
                if let lineTopLeft = lineTopLeft {
                    lineTopLeft.backgroundColor = .white
                    view.addSubview(lineTopLeft)
                    view.bringSubviewToFront(lineTopLeft)
                }
                
                lineBottomRight = UILabel(frame: CGRect(
                    x:view.bounds.size.width / 7, 
                    y:(view.bounds.size.height / 2) - (view.bounds.size.height / 8), 
                    width: view.bounds.size.width / 12, 
                    height: 2)
                )
                if let lineBottomRight = lineBottomRight {
                    lineBottomRight.backgroundColor = .white
                    view.addSubview(lineBottomRight)
                    view.bringSubviewToFront(lineBottomRight)
                }

                lineTopRight = UILabel(frame: CGRect(
                    x:view.bounds.size.width / 7, 
                    y:(view.bounds.size.height / 2) + (view.bounds.size.height / 8) - 2, 
                    width: view.bounds.size.width / 12, 
                    height: 2)
                )
                if let lineTopRight = lineTopRight {
                    lineTopRight.backgroundColor = .white
                    view.addSubview(lineTopRight)
                    view.bringSubviewToFront(lineTopRight)
                }
            
                messageLabel = UILabel(frame: CGRect(x:0, y:0, width:view.bounds.size.width, height:40))
                messageLabel.textAlignment = .center
                messageLabel.text = "Scanning..."
                messageLabel.textColor = .white
                view.addSubview(messageLabel)
                view.bringSubviewToFront(messageLabel)
            }
            
            cancelButton = UIButton(frame: CGRect(x:view.bounds.size.width - 51, y:5, width:48, height:48))
            if let cancelButton = cancelButton {
                cancelButton.setImage(UIImage(named: "ios7-close-empty-white.png"), for: .normal)
                cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
                view.addSubview(cancelButton)
                view.bringSubviewToFront(cancelButton)
            }

            flashButton = UIButton(frame: CGRect(x:view.bounds.size.width - 51, y:view.bounds.size.height - 51, width:48, height:48))
            if let flashButton = flashButton {
                flashButton.setImage(UIImage(named: "ios7-bolt-outline-white.png"), for: .normal)
                flashButton.addTarget(self, action: #selector(toggleFlash), for: .touchUpInside)
                view.addSubview(flashButton)
                view.bringSubviewToFront(flashButton)
            }

            // Start video capture.
            captureSession?.startRunning()

        } catch {
            print(error)
        }
    }
    
    @objc func cancelButtonAction(sender: UIButton!) {
        // Prepare a failed result for cordova
        parentPlugin?.commandDelegate!.send(CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Barcode scan cancelled."), callbackId: callbackId);
        cleanupScreen()
    }
    
    @objc func toggleFlash() {
        if let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch {
            do {
                try device.lockForConfiguration()
                let torchOn = !device.isTorchActive
                try device.setTorchModeOn(level: 1.0)
                device.torchMode = (torchOn) ? .on : .off
                device.unlockForConfiguration()
            } catch {
                print("Error toggling flash.")
            }
            if(!device.isTorchActive) {
                flashButton?.setImage(UIImage(named: "ios7-bolt-white.png"), for: .normal)
            } else {
                flashButton?.setImage(UIImage(named: "ios7-bolt-outline-white.png"), for: .normal)
            }
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero	
            return
        }

        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        if metadataObj.type == AVMetadataObject.ObjectType.pdf417 || metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds

            //Get the barcode value and type
            var barcodeReturn = [AnyHashable: Any]();
            barcodeReturn["data"] = metadataObj.stringValue;
            barcodeReturn["format"] = metadataObj.type;

            //Prepare the result and make the callback
            parentPlugin?.commandDelegate!.send(CDVPluginResult(status:CDVCommandStatus_OK, messageAs: barcodeReturn), callbackId: callbackId)

        	cleanupScreen()
        }
    }
    
    func cleanupScreen() {
        
        if let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasTorch {
            do {
                try device.lockForConfiguration()
                device.torchMode = .off
                device.unlockForConfiguration()
            } catch {
                print("Error turning off flash.")
            }
        }
        
        videoPreviewLayer?.removeFromSuperlayer()
        qrCodeFrameView?.removeFromSuperview()
        messageLabel?.removeFromSuperview()
        cancelButton?.removeFromSuperview()
        flashButton?.removeFromSuperview()
        lineMidLeft?.removeFromSuperview()
        lineMidRight?.removeFromSuperview()
        lineBottomLeft?.removeFromSuperview()
        lineTopLeft?.removeFromSuperview()
        lineBottomRight?.removeFromSuperview()
        lineTopRight?.removeFromSuperview()
        captureSession?.stopRunning()

        lineMidLeft = nil
        lineMidRight = nil
        lineBottomLeft = nil
        lineTopLeft = nil
        lineBottomRight = nil
        lineTopRight = nil
        flashButton = nil
        cancelButton = nil
        videoPreviewLayer = nil
        qrCodeFrameView = nil
        messageLabel = nil
        captureSession = nil
        
        UIDevice.current.setValue(originalOrientation?.rawValue, forKey: "orientation")
        
        self.dismiss(animated: true, completion: nil)
    }
}
