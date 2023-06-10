//
//  AritclesModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 6.06.2023.
//

import Foundation

struct ArticlesModel: Identifiable{
    var id: UUID
    var title: String
    var description: String
    var image: String
    var url: String
}
