//
//  RecordedAudio.swift
//  my pitch perfect
//
//  Created by Kathleen Stukenborg on 9/29/15.
//  Copyright © 2015 Kathleen Stukenborg. All rights reserved.
//
// This is our model

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String = ""
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}