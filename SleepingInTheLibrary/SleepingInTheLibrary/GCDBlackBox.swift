//
//  GCDBlackBox.swift
//  SleepingInTheLibrary
//
//  Created by Geek on 1/24/19.
//  Copyright © 2019 Geek. All rights reserved.
//

import Foundation

func performUpdatesOnMain(_ updates : @escaping () -> Void){
    DispatchQueue.main.async {
         updates()
    }
}
