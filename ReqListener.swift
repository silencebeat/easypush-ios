//
//  ReqListener.swift
//  CandraLagiIseng
//
//  Created by algo on 1/14/16.
//  Copyright © 2016 apiquestudio. All rights reserved.
//

import Foundation

public protocol ReqListener {
    func onFinish(result: String) -> Void
    func onFailed(message: String, errorStatus: Int) -> Void
}