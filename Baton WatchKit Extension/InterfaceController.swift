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

    // Variables
    let manager = CMMotionManager()
    
    var flagV = 1
    var flagP = 1
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Device Motion
        if manager.isDeviceMotionAvailable {
            manager.deviceMotionUpdateInterval = 0.01
            manager.startDeviceMotionUpdates(to: .main) {
                [weak self] (data, error) in

                guard let data = data, error == nil else {
                    return
                }

                // Calculating angle of watch w.r.t to earth
//                let rotationX = atan(data.gravity.x) * 360 / Double.pi
                let rotationX = data.attitude.pitch * 180 / .pi
//                let rotationY = atan(data.gravity.y) * 360 / Double.pi
                let rotationY = data.attitude.roll * 180 / .pi
//                let rotationZ = atan(data.gravity.z) * 360 / Double.pi
//                let rotationZ = data.attitude.yaw * 180 / .pi
                
                if self!.flagV == 1 {
                    if rotationY > 35 && rotationY < 45 {
                        print("Volume Decrease")
                        self!.flagV = 0
                    }
                }
                
                if self!.flagV == 0 {
                    if rotationY < -35 && rotationY > -45 {
                        print("Volume Increase")
                        self!.flagV = 1
                    }
                }
                
                if self!.flagP == 1 {
                    if rotationX > -90 && rotationX < -80 {
                        print("Music Pause")
                        self!.flagP = 0
                    }
                }
                
                if self!.flagP == 0 {
                    if rotationX > 80 && rotationX < 90 {
                        print("Music Play")
                        self!.flagP = 1
                    }
                }
                
//                print(rotationX)
//                print(rotationY)

            }
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
    }

}
