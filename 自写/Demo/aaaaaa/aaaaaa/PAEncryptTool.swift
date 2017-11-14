//
//  PAEncryptTool.swift
//  aaaaaa
//
//  Created by luozhijun on 2017/11/13.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = -1
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    func stringFromBytes(bytes: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String{
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", bytes[i])
        }
        return String(format: hash as String)
    }
    
    func encryptedString(with algorithm: CryptoAlgorithm, isHmac: Bool = false, hmacKey: String = "") -> (String, String) {
        guard let str = cString(using: .utf8) else { return ("", "") }
        let strLen = CC_LONG(lengthOfBytes(using: .utf8))
        var digestLen = algorithm.digestLength
        
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        defer {
            result.deallocate(capacity: digestLen)
        }
        
        if isHmac {
            guard let keyStr = hmacKey.cString(using: .utf8) else { return ("", "") }
            let keyLen  = Int(hmacKey.lengthOfBytes(using: .utf8))
            let strLen1 = lengthOfBytes(using: .utf8)
            CCHmac(algorithm.HMACAlgorithm, keyStr, keyLen, str, strLen1, result)
        } else {
            switch algorithm {
            case .MD5:
                CC_MD5(str, strLen, result)
            case .SHA1:
                CC_SHA1(str, strLen, result)
            case .SHA224:
                CC_SHA224(str, strLen, result)
            case .SHA256:
                CC_SHA256(str, strLen, result)
            case .SHA384:
                CC_SHA384(str, strLen, result)
            case .SHA512:
                CC_SHA512(str, strLen, result)
            }
        }
        
        let data = NSMutableData()
        data.append(result, length: digestLen)
        let dataBase64Str = data.base64EncodedString(options: .endLineWithCarriageReturn)
        return (stringFromBytes(bytes: result, length: digestLen), dataBase64Str)
    }
        
    var md5: String {
        return encryptedString(with: .MD5).0
    }
    
    var sha1: String! {
        return encryptedString(with: .SHA1).0
    }
    
    var sha256String: String! {
        return encryptedString(with: .SHA256).0
    }
    
    var sha512String: String! {
        return encryptedString(with: .SHA512).0
    }
    
    func base64EncodedString(with options: NSData.Base64EncodingOptions) -> String {
        guard let data = self.data(using: .utf8, allowLossyConversion: true) else { return "" }
        return (data as NSData).base64EncodedString(options: options)
    }
    
    /// 去除base64中的特殊字符+/=, +和/分别用-和_取代, 等号去掉.
    mutating func replaceBase64ParticularChars() {
        self = self.replacingOccurrences(of: "+", with: "-")
        self = self.replacingOccurrences(of: "/", with: "_")
        self = self.replacingOccurrences(of: "=", with: "")
    }
}
