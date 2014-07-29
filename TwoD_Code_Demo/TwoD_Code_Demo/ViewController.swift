//
//  ViewController.swift
//  TwoD_Code_Demo
//
//  Created by Techsun on 14-7-28.
//  Copyright (c) 2014年 techsun. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
class ViewController: UIViewController ,AVCaptureMetadataOutputObjectsDelegate {
    

    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    let session = AVCaptureSession()
    var layer: AVCaptureVideoPreviewLayer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "二维码扫描"
        self.view.backgroundColor = UIColor.grayColor()
        let labIntroudction = UILabel(frame:CGRectMake(15, 80, 290, 50))
        labIntroudction.backgroundColor = UIColor.clearColor()
        labIntroudction.numberOfLines = 2
        labIntroudction.textColor = UIColor.whiteColor()
        labIntroudction.text = "将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。"
        self.view.addSubview(labIntroudction)
        let imageView = UIImageView(frame:CGRectMake(10, 140, 300, 300))
        imageView.image = UIImage(named:"pick_bg")
        self.view.addSubview(imageView)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        let item0 = UIBarButtonItem(image:(UIImage(named:"ocrBack.png")), style:(UIBarButtonItemStyle.Bordered), target:self, action:(Selector("backClick")))
        let item1 = UIBarButtonItem(image:(UIImage(named:"ocr_flash-off.png")), style:(UIBarButtonItemStyle.Bordered), target:self, action:(Selector("turnTorchOn")))
        let item2 = UIBarButtonItem(image:(UIImage(named:"ocr_albums.png")), style:(UIBarButtonItemStyle.Bordered), target:self, action:(Selector("pickPicture")))
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem : (UIBarButtonSystemItem.FlexibleSpace), target: self, action: nil)
        toolBar.items = [item0,flexibleSpaceItem,item2,flexibleSpaceItem, item1]
        toolBar.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height-44, 320, 44)
        self.view.addSubview(toolBar)
    }

    func backClick(){
        
    }
    func turnTorchOn(){
        
    }
    func pickPicture(){
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupCamera()
        self.session.startRunning()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    func setupCamera(){
        self.session.sessionPreset = AVCaptureSessionPresetHigh
        var error : NSError?
        let input = AVCaptureDeviceInput(device: device, error: &error)
        if error {
            println(error.description)
            return
        }
        if session.canAddInput(input) {
            session.addInput(input)
        }
        layer = AVCaptureVideoPreviewLayer(session: session)
        layer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer!.frame = CGRectMake(20,150,280,280);
        self.view.layer.insertSublayer(self.layer, atIndex: 0)
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode];
        }
        
        session.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: AnyObject[]!, fromConnection connection: AVCaptureConnection!){
        var stringValue:String?
        if metadataObjects.count > 0 {
            var metadataObject = metadataObjects[0] as AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
        }
        self.session.stopRunning()
        println("code is \(stringValue)")
        
//        let alertController = UIAlertController(title: "二维码", message: "扫到的二维码内容为:\(stringValue)", preferredStyle: UIAlertControllerStyle.Alert)
//        alertController.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alertController, animated: true, completion: nil)
        var alertView = UIAlertView()
        alertView.delegate=self
        alertView.title = "二维码"
        alertView.message = "扫到的二维码内容为:\(stringValue)"
        alertView.addButtonWithTitle("确认")
        alertView.show()
    }

}

