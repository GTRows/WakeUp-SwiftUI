//
//  WorkShopViewModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 9.06.2023.
//

import Foundation

enum WorkShopTab {
    case myPackages
    case community
}

class WorkShopViewModel: ObservableObject {
    @Published var packages: [PackageModel] = []

    private var communityPackages: [PackageModel] = []
    private var myPackages: [PackageModel] = []

    @Published var selectedTab: WorkShopTab = .myPackages
    
    public func deletePackage(package: PackageModel) {
        FireBaseService.shared.deletePackage(packageID: package.id.uuidString) { Result in
            switch Result{
            case .success(_):
                self.getUserPackages()
            case .failure(let error):
                AlertService.shared.show(error: error)
            }
        }
    }
    
    func getAllPackages() {
        FireBaseService.shared.fetchAllPackages { Result in
            switch Result {
            case let .success(packages):
                self.packages = packages
                self.communityPackages = packages
            case let .failure(error):
                AlertService.shared.show(error: error)
            }
        }
    }
    
    func getUserPackages() { 
        print("getUserPackages")
        
        FireBaseService.shared.fetchUserPackages { Result in
            switch Result {
            case let .success(packages):
                print("packages: \(packages)")
                self.packages = packages
                self.myPackages = packages
            case let .failure(error):
                print("error: \(error)")
                AlertService.shared.show(error: error)
            }
        }
    }
    
    

}
