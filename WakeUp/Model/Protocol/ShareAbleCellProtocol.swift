//
//  ShareAbleCellProtocol.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 16.06.2023.
//

import Foundation
import SwiftUI

protocol ShareAbleCellProtocol {
    func share(emailToShare: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getNameModel() -> String
    func getCellView() -> any View
}
