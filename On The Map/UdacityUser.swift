//
//  UdacityUser.swift
//  On The Map
//
//  Created by Mina Atef on 9/1/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

struct UdacityUser {
    public private(set) var firstName = ""
    public private(set) var lastName = ""
    
    // Construct a UdacityUser from a dictionary
    init(firstName: String, lastName: String) {
        
        self.firstName = firstName
        self.lastName = lastName
    
    }

}
