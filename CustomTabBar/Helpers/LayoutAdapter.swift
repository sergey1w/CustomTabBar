//
//  LayoutAdapter.swift
// CustomTabBar
//

//

import UIKit

enum LayoutAxis {
    case horizontal
    case vertical
}

func adapt(_ constant: CGFloat, forAxis axis: LayoutAxis) -> CGFloat {
    let screenSize = UIScreen.main.bounds.size
    let baseSize = Constants.baseDeviceSize
    let ratio: CGFloat
    switch axis {
    case .horizontal:
        ratio = screenSize.width / baseSize.width
    case .vertical:
        ratio = screenSize.height / baseSize.height
    }
    return constant * ratio
}

extension Int {
    var VAdapted: CGFloat {
        adapt(CGFloat(self), forAxis: .vertical)
    }
    var HAdapted: CGFloat {
        adapt(CGFloat(self), forAxis: .horizontal)
    }
}

extension CGFloat {
    var VAdapted: CGFloat {
        adapt(self, forAxis: .vertical)
    }
    var HAdapted: CGFloat {
        adapt(self, forAxis: .horizontal)
    }
}

extension CGSize {
    var adapted: CGSize {
        let w = adapt(self.width, forAxis: .horizontal)
        let h = adapt(self.height, forAxis: .vertical)
        return CGSize(width: w, height: h)
    }
}

extension UIFont {
    var adapted: UIFont {
        return self.withSize(self.pointSize.HAdapted)
    }
}
