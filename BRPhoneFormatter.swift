//
//  BRPhoneFormatter.swift
//  Eureka
//
//  Created by Ramon Honório on 10/10/16.
//  Copyright © 2016. All rights reserved.
//

import Foundation
import Eureka

open class BRPhoneFormatter : Formatter, FormatterProtocol {
    
    override open func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        guard obj != nil else { return false }
        let str = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        obj?.pointee = str as AnyObject?
        return true
    }
    
    
    override open func string(for obj: Any?) -> String? {
        if (obj is String) {
            let oldString = (obj as! String)
            return getNewFormattedString(oldString)
        } else {
            return nil
        }
    }
    
    open func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
        
        let offset = ((newValue?.characters.count ?? 0) - (oldValue?.characters.count ?? 0))
        return textInput.position(from: position, offset: offset) ?? position
    }
    
    fileprivate func getNewFormattedString (_ oldString: String) -> String {
        let oldString = oldString as NSString
        let length = oldString.length
        let formattedString = NSMutableString()
        var index = 0 as Int
        
        let areaCodeLength = 2
        let prefixLength = oldString.length > 10 ? 5 : 4
        
        if length - index > areaCodeLength {
            let areaCode = oldString.substring(with: NSMakeRange(index, areaCodeLength))
            formattedString.appendFormat("(%@) ", areaCode)
            index += areaCodeLength
        }
        if length - index > prefixLength {
            let prefix = oldString.substring(with: NSMakeRange(index, prefixLength))
            formattedString.appendFormat("%@-", prefix)
            index += prefixLength
        }
        let remainder = oldString.substring(from: index)
        formattedString.append(remainder)
        
        return formattedString as String
    }
}

