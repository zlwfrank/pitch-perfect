//
//  recordAudioClass.swift
//  pitch perfect
//
//  Created by ZhouLiwei on 8/8/15.
//  Copyright (c) 2015 ZhouLiwei. All rights reserved.
//

//foundation is a framework is iso and contain important classes that define waht it means for something to be a string or an array
import Foundation

//NSObject is the root class for most classes in ios
class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
}