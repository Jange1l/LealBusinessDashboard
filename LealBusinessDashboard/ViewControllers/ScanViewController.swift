//
//  ScanViewController.swift
//  LealBusinessDashboard
//
//  Created by Juan escobar on 12/26/20.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
	
	var captureSession: AVCaptureSession!
	var previewLayer: AVCaptureVideoPreviewLayer!
	
	var code: String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//AccountDetailsNetworking().signOut(completion: {(status) in })
		
		view.backgroundColor = UIColor.black
		captureSession = AVCaptureSession()
		
		guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
		let videoInput: AVCaptureDeviceInput
		
		do {
			videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
		} catch {
			return
		}
		
		if (captureSession.canAddInput(videoInput)) {
			captureSession.addInput(videoInput)
		} else {
			failed()
			return
		}
		
		let metadataOutput = AVCaptureMetadataOutput()
		
		if (captureSession.canAddOutput(metadataOutput)) {
			captureSession.addOutput(metadataOutput)
			
			metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			metadataOutput.metadataObjectTypes = [.qr]
		} else {
			failed()
			return
		}
		
		previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		previewLayer.frame = view.layer.bounds
		previewLayer.videoGravity = .resizeAspectFill
		view.layer.addSublayer(previewLayer)
		
		captureSession.startRunning()
	}
	
	
	func failed() {
		let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
		captureSession = nil
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if (captureSession?.isRunning == false) {
			captureSession.startRunning()
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
				if (captureSession?.isRunning == true) {
					captureSession.stopRunning()
				}
	}
	
	@IBAction func unwindFromScanPopUp(_ sender: UIStoryboardSegue) {
		if sender.source is ScanPopUpViewController {
			captureSession.startRunning()
		}
	}
	
	
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		captureSession.stopRunning()
		
		if let metadataObject = metadataObjects.first {
			guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
			guard let stringValue = readableObject.stringValue else { return }
			AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
			print("STRING VALUE -> ", stringValue)
			let type = stringValue.components(separatedBy: "_")[0]
			let code = stringValue.components(separatedBy: "_")[1]
			let tokens = stringValue.components(separatedBy: "_")
			found(type: type, code: code, tokens: tokens)
		}
		
		// Do not dismiss
		
	}
	
	func found(type: String, code: String, tokens: [String]) {
		// instead of dismissing present the user profile to input dollar amount of purchase
		switch  type {
			case "lp":
				print(code)
				self.code = code
				performSegue(withIdentifier: "PointsCollection", sender: nil)
			case "Pr":
				ScannerNetworking().claimPromo(customerUid: tokens[1], rewardId: tokens[2])
				rewardRedeemed()
			case "Rw":
				print("Deleting reward")
				ScannerNetworking().claimReward(customerUid: tokens[1], rewardId: tokens[2])
				rewardRedeemed()
				
			default:
				print("")
		}
		
		
	}
	
	func rewardRedeemed() {
		let alert = UIAlertController(title: "Success", message: "Reward Redeemed", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
			NSLog("The \"OK\" alert occured.")
			
//			let generator = UINotificationFeedbackGenerator()
//			generator.notificationOccurred(.success)
			let generator = UIImpactFeedbackGenerator(style: .heavy)
			generator.impactOccurred()
			self.captureSession.startRunning()
		}))
	
		self.present(alert, animated: true, completion: nil)
	}
	
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "PointsCollection" {
			if let scp = segue.destination as? ScanPopUpViewController {
				scp.customerUid = code
			}
		}
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}
}
