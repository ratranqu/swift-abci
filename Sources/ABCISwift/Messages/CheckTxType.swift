//===----------------------------------------------------------------------===//
//
// This source file is part of the ABCISwift open source project
//
// Copyright (c) 2019 ABCISwift project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of ABCISwift project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

public enum CheckTxType {
    public typealias RawValue = Int
    
    case new // = 0
    case recheck // = 1
    case UNRECOGNIZED(Int)
    
    init() {
      self = .new
    }

    init?(rawValue: Int) {
      switch rawValue {
      case 0: self = .new
      case 1: self = .recheck
      default: self = .UNRECOGNIZED(rawValue)
      }
    }

    var rawValue: Int {
      switch self {
      case .new: return 0
      case .recheck: return 1
      case .UNRECOGNIZED(let i): return i
      }
    }
}


