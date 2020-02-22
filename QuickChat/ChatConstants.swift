//
//  ChatConstants.swift
//  QuickChat
//
//  Created by carlos on 21/02/20.
//  Copyright © 2020 Carlos Velasco. All rights reserved.
//

struct Constants {
    static let appName = "📨QUICKCHAT"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let lightRed = "BrandLightRed"
        static let blue = "BrandBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
