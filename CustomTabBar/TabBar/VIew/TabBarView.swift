//
//  TabBarView.swift
// CustomTabBar
//

//

import UIKit

final class TabBarView: UIView {
    
    private var buttons: [UIButton] = []
    
    weak var tabBarController: TabBarControllerProtocol?
    
    private let selectedBackgroundLayer = CALayer()
    
    private(set) var selectedIndex = 0
    
    private var maxSelectedButtonWidth: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .layoutSubviews) { [self] in
            calculateButtonFrames()
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        buttons[selectedIndex].isSelected = false
        sender.isSelected = true
        selectedIndex = sender.tag
        tabBarController?.didTapTabBarButton(selectedIndex)
        setNeedsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit TabBarView")
    }
}

// MARK: UI setup
extension TabBarView {
    private func setup() {
        backgroundColor = .Main.green
        setButtons()
        setupMovingLayer()
    }
    
    private func setupMovingLayer() {
        layer.insertSublayer(selectedBackgroundLayer, at: 0)
        selectedBackgroundLayer.backgroundColor = UIColor.Main.sand.cgColor
    }
    
    private func calculateButtonFrames() {
        let selectedButton = buttons[selectedIndex]
        let selectedButtonSize = selectedButton.intrinsicContentSize
        let width = bounds.width
        let horizontalPadding = CSp.small * 2
        let spacing = CSp.small * CGFloat(buttons.count - 1)
        let availableWidth = width - horizontalPadding - spacing - maxSelectedButtonWidth
        
        let otherButtonsWidth = availableWidth / CGFloat(buttons.count - 1)
        
        for index in 0..<buttons.count {
            let currentButton = buttons[index]
            
            if currentButton.isSelected {
                currentButton.bounds.size = .init(width: maxSelectedButtonWidth, height: selectedButtonSize.height)
            } else {
                currentButton.bounds.size = CGSize(
                    width: otherButtonsWidth,
                    height: selectedButtonSize.height
                )
            }
            
            let center: CGPoint
            if index == 0 {
                center = CGPoint(x: CSp.small + currentButton.bounds.midX, y: bounds.midY)
            } else {
                let xOffset = buttons[index - 1].frame.maxX + CSp.small + currentButton.bounds.midX
                center = CGPoint(x: xOffset, y: bounds.midY)
            }
            
            currentButton.center = center
        }
        
        selectedBackgroundLayer.frame = selectedButton.frame
        selectedBackgroundLayer.cornerRadius = selectedBackgroundLayer.bounds.height / 2
    }
    
    private func setButtons() {
        self.buttons = TabBarButton.allCases.map { button in
            let btn = makeButton(model: button)
            btn.tag = button.rawValue
            if button.rawValue == 0 { btn.isSelected = true }
            
            addSubview(btn)
            btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            
            return btn
        }
    }
    
    private func makeButton(model: TabBarButton) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .clear
        config.image = model.icon
        config.imagePlacement = .leading
        config.imagePadding = CSp.min
        
        var attributeContainer = AttributeContainer()
        attributeContainer.font = .systemFont(ofSize: 13, weight: .bold)
        let attributedTitle = AttributedString(model.title, attributes: attributeContainer)
        config.attributedTitle = attributedTitle
        
        let btn = UIButton(configuration: config)
        btn.clipsToBounds = true
        btn.configurationUpdateHandler = { btn in
            switch btn.state {
            case .selected:
                btn.configuration?.baseForegroundColor = .Main.green
                btn.configuration?.attributedTitle = attributedTitle
            case .normal:
                btn.configuration?.baseForegroundColor = .white
                btn.configuration?.attributedTitle = nil
            default:
                break
            }
        }
        
        btn.isSelected = true
        let buttonWidth = btn.intrinsicContentSize.width
        if buttonWidth > maxSelectedButtonWidth {
            maxSelectedButtonWidth = buttonWidth
        }
        
        btn.isSelected = false
        
        return btn
    }
}
