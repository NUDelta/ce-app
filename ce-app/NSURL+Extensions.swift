//
//  NSURL+Extensions.swift
//  ce-app
//
//  Created by Kevin Chen on 2/12/16.
//  Copyright © 2016 delta. All rights reserved.
//

extension NSURL {
    
    func parseQuery() -> [String: AnyObject] {
        var params = [String: AnyObject]()
        
        if let query = self.query {
            for pair in query.componentsSeparatedByString("&") {
                let components = pair.componentsSeparatedByString("=")
                params[components[0]] = components[1]
            }
        }
        
        return params
    }
}
