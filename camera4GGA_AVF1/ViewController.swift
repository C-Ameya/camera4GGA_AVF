//
//  ViewController.swift
//  camera4GGA_AVF1
//
//  Created by Chie Takahashi on 2018/03/07.
//  Copyright © 2018年 ctak. All rights reserved.
//

import UIKit
import AVFoundation
import Photos




class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
  
  //カメラセッション
  var captureSession: AVCaptureSession?
  var capturePhotoOutput: AVCapturePhotoOutput?
  var previewLayer: AVCaptureVideoPreviewLayer?
  @objc var captureDevice: AVCaptureDevice?
  
  @IBOutlet var preView: UIView!
//  @IBOutlet var capture: UIButton!
  //captureボタンを押すと写真が撮れる
  @IBAction func capture(_ sender: Any) {
    let photoSettings : AVCapturePhotoSettings!
    photoSettings = AVCapturePhotoSettings.init(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
    photoSettings.isAutoStillImageStabilizationEnabled = true
    photoSettings.flashMode = .off
    photoSettings.isHighResolutionPhotoEnabled = false
    self.capturePhotoOutput?.capturePhoto(with: photoSettings, delegate: self)
  }
  
  //撮影した写真をviewに表示
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.captureSession = AVCaptureSession()
    self.captureSession?.sessionPreset = .photo
    self.capturePhotoOutput = AVCapturePhotoOutput()
    self.captureDevice = AVCaptureDevice.default(for: .video)
    let input = try! AVCaptureDeviceInput(device: self.captureDevice!)
    self.captureSession?.addInput(input)
    self.captureSession?.addOutput(self.capturePhotoOutput!)
    self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
    self.previewLayer?.frame = self.preView.bounds
    self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
    self.previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
    self.preView.layer.addSublayer(self.previewLayer!)
    self.captureSession?.startRunning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  
  //ISOとシャッタースピードの処理
//  func ChangeValue(sender: UIButton){
//  let Setting = AVCaptureDevice.default(for: .video)
//  do {
//  try Setting?.lockForConfiguration()
    //lockForConfigurationからunlockForConfigurationの間に処理を書かないとダメ
    //スライダーからボタンに変換するので、処理の書き換えをどうするか？
    
//  let isoSetting: Float = isoButton.value
//  timerMapping = ssButton.value
//
//  let StockTime: Int32 = Int32(timerMapping)
//  let SetTime: CMTime = CMTimeMake(1, StockTime)
//
//    Setting?.setExposureModeCustom(duration: SetTime, iso: isoSetting, completionHandler: nil)
//
//  Setting?.unlockForConfiguration()
//  } catch {
//
//  let alertController = UIAlertController(title: "Cheak", message: "False !!", preferredStyle: .alert)
//  let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//  alertController.addAction(defaultAction)
//  present(alertController, animated: true, completion: nil)
//  }
//}
  
  //ISO設定？？？ボタン版
//  func ISOTappedAction(_ sender: Any) {
//    func isoSetting(sender: UIButton){
//      let isoSetting: Float = isoButton.value
//      do{
//      isoSetting.lockForConfiguration()
//      Setting?.setExposureModeCustom(iso: isoSetting, completionHandler: nil)
//      Setting?.unlockForConfiguration()
//      }
//    }
  
  //ホワイトバランスの処理
  
  @IBAction func wbTappedAction(_ sender: Any) {
  func WB(sender: UIButton){
  let wbSetting =  AVCaptureDevice.default(for: .video)
  do{
      try wbSetting?.lockForConfiguration()
    var  g:AVCaptureDevice.WhiteBalanceGains = AVCaptureDevice.WhiteBalanceGains(redGain: 0.0, greenGain: 0.0, blueGain: 0.0)
    
      g.blueGain = 1.5
      g.greenGain = 1.0
      g.redGain = 4.0
    
    wbSetting?.setWhiteBalanceModeLocked(with: g, completionHandler: nil )
      
} catch {
      
      let alertController = UIAlertController(title: "Cheak", message: "False !!", preferredStyle: .alert)
      
      let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(defaultAction)
      present(alertController, animated: true, completion: nil)
    }
      }
    
    //ホワイトバランスリセットの処理
    func resetWBTappedAction(_ sender: Any) {
    func resetWB(sender: UIButton){
      let resetWB = AVCaptureDevice.default(for: .video)
      do{
        try resetWB?.lockForConfiguration()
        var  decomp:AVCaptureDevice.WhiteBalanceGains = AVCaptureDevice.WhiteBalanceGains(redGain: 0.0, greenGain: 0.0, blueGain: 0.0)
        
        decomp.blueGain = 2.5
        decomp.greenGain = 1.3
        decomp.redGain = 2.5
        resetWB?.setWhiteBalanceModeLocked(with: decomp, completionHandler: nil )
      } catch {
        let alertController = UIAlertController(title: "チェック", message: "失敗", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
      }
    }
  
    
  //写真の保存
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    PHPhotoLibrary.shared().performChanges( {
      let creationRequest = PHAssetCreationRequest.forAsset()
      creationRequest.addResource(with: PHAssetResourceType.photo, data: photo.fileDataRepresentation()!, options: nil)
    }, completionHandler: nil)
  }
  
  func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                   didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings,
                   error: Error?) {
    
    guard error == nil else {
      print("Error in capture process: \(String(describing: error))")
      return
    }
  }
  
  //保存した結果をアラートで表示
  func showResultOfSaveImage(_image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer){
    var title = "保存完了"
    var message = "カメラロールに保存しました"
    if error != nil{
      title = "エラー"
      message = "保存に失敗しました"
    }
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //OKボタンを追加
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    //UIAlertControllerを表示
    self.present(alert, animated: true, completion: nil)
    }
}
}



