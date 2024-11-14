//
//  TabBarButtonModel.swift
// CustomTabBar
//

//

import UIKit

struct TabBarButtonModel {
    let title: String
    let image: UIImage?
}


enum TabBarButton: Int, CaseIterable {
    case profile
    case stats
    case marathon
    case training
    
    var title: String {
        switch self {
        case .profile: return "Profile"
        case .stats: return "Stats"
        case .marathon: return "Marathon"
        case .training: return "Training"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .profile: return .Icon.TabBar.person
        case .stats: return .Icon.TabBar.chart
        case .marathon: return .Icon.TabBar.calendar
        case .training: return .Icon.TabBar.drop
        }
    }
}
