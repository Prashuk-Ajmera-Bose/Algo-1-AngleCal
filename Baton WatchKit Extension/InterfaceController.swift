//
//  InterfaceController.swift
//  Baton WatchKit Extension
//
//  Created by Prashuk Ajmera on 9/6/19.
//  Copyright © 2019 Prashuk Ajmera. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

class InterfaceController: WKInterfaceController {

    let manager = CMMotionManager()
    var can_reset = true
    var logString = ""
    var is_RechedZeroPos = true
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
//        if manager.isDeviceMotionAvailable {
//            manager.deviceMotionUpdateInterval = 1
//            manager.startDeviceMotionUpdates(to: .main) {
//                [weak self] (data, error) in
//
//                guard let data = data, error == nil else {
//                    return
//                }
//
//                let value = atan2(data.gravity.x, data.gravity.y)
//                let angle = atan(value) * 180 / 3.14
//                print("Value: \(value) Angle: \(angle)")
//            }
//        }
        
        startUpadateAccelerometer()
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func startUpadateAccelerometer() {
            self.manager.deviceMotionUpdateInterval = 1.0 / 10.0
            self.manager.startDeviceMotionUpdates(to: OperationQueue()) { (accelerometerData, error) -> Void in
                guard accelerometerData != nil else
                {
                    print("There was an error: \(String(describing: error))")
                    return
                }

                DispatchQueue.main.async {
                    if(self.can_reset){
                        let differenceX : Bool = self.validateButtom(currentValue: accelerometerData!.userAcceleration.x, inititalValue: accelerometerData!.gravity.x)
                        let differenceY : Bool = self.validateButtom(currentValue: accelerometerData!.userAcceleration.y, inititalValue: accelerometerData!.gravity.y)

                        if(differenceX && differenceY && self.gravityOffsetDifference(currentValue: accelerometerData!.userAcceleration.x, referenceValue: accelerometerData!.userAcceleration.x ) && self.gravityOffsetDifference(currentValue: accelerometerData!.userAcceleration.y, referenceValue: accelerometerData!.gravity.y)){
                            WKInterfaceDevice().play(.success)
//                            self.addLog(_logStr: EventsTypes.Achievements1.rawValue)

                            self.logString += String(format: "X: %0.3f Y: %0.3f Z: %0.3f  \n", accelerometerData!.userAcceleration.x, accelerometerData!.userAcceleration.y,accelerometerData!.userAcceleration.z)
                            print(self.logString)
//                            self.m_XYZValueLbl.setText(self.logString)

                            self.is_RechedZeroPos = true
//                            self.session?.sendMessage(["msg" : "\(self.logString)"], replyHandler: nil) { (error) in
//                                NSLog("%@", "Error sending message: \(error)")
//                            }

                        } else {
//                            if(self.checkAchievements2_3(deviceMotionData: accelerometerData!.userAcceleration) == true) {
//                                if self.is_RechedZeroPos == true {
////                                    self.addLog(_logStr: EventsTypes.Achievements2.rawValue)
//                                    self.is_RechedZeroPos = false
//                                } else {
////                                    self.addLog(_logStr: EventsTypes.Achievements3.rawValue)
//                                }
//                            }
                        }
                    } else {
//                        self.gravityReference = accelerometerData!.acceleration
                        //self.logString = String(format: "Reference Acceleration   %0.3f   %0.3f   %0.3f  \n", self.gravityReference.x,self.gravityReference.y,self.gravityReference.z)
                        self.can_reset = true
                    }
                }
            }
        }
    
    func validateButtom(currentValue : Double , inititalValue : Double) -> Bool {
           if( currentValue == 0 && inititalValue == 0) {
               return true
           } else if( currentValue < 0 && inititalValue < 0) {
               return true
           } else if( currentValue > 0 && inititalValue > 0) {
               return true
           } else {
               return false
           }
       }



    func gravityOffsetDifference(currentValue : Double , referenceValue: Double) -> Bool {
           var difference : Double!
           if (fabs(currentValue) <= fabs(referenceValue)) {
               difference = fabs(referenceValue) - fabs(currentValue)
           } else {
               difference = fabs(currentValue) - fabs(referenceValue)
           }

        if (difference <= 9.8 ) {
               return true
           } else {
               return false
           }
       }

}
