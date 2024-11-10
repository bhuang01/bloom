//
//  Post.swift
//  Bloom
//
//  Created by vzhu on 11/10/24.
//

import Foundation

struct Post: Identifiable {
    let id: UUID = UUID()
    let title: String
    let briefDescription: String
    let fullDescription: String
}
