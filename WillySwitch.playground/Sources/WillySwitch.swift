import UIKit

public protocol WillySwitchDelegate: class {
    func willySwitch(didSelectTitle title: String)
}

public class WillySwitch: UIControl {
    private var selectedTitle: String?
    private let buttons: [UIButton]
    public weak var delegate: WillySwitchDelegate?
    
    public init(titles: [String]) {
        
        // create buttons
        
        var buttons = [UIButton]()
        
        for title in titles {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.textAlignment = .center
            buttons.append(button)
        }
        
        // initialize control
        
        selectedTitle = titles.first
        self.buttons = buttons
        super.init(frame: .zero)
        
        // configure buttons
        
        buttons.forEach {
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            self.configureButton($0, forSelected: $0.currentTitle == selectedTitle)
        }
        
        // add & constrain button views
        
        var constraints = [NSLayoutConstraint]()
        
        let buttonWidthAnchor = buttons.first?.widthAnchor ?? widthAnchor
        
        for (i, button) in buttons.enumerated() {
            self.addSubview(button)
            
            let leftBorderingAnchor = i == 0 ? leftAnchor : buttons[i - 1].rightAnchor
            let rightBorderingAnchor = i == buttons.count - 1 ? rightAnchor : buttons[i + 1].leftAnchor
            
            constraints.append(contentsOf: [
                button.topAnchor.constraint(equalTo: topAnchor),
                button.bottomAnchor.constraint(equalTo: bottomAnchor),
                button.leftAnchor.constraint(equalTo: leftBorderingAnchor),
                button.rightAnchor.constraint(equalTo: rightBorderingAnchor),
                button.widthAnchor.constraint(equalTo: buttonWidthAnchor)
            ])
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton(_ button: UIButton, forSelected selected: Bool) {
        button.titleLabel?.font = selected ? .selectedButtonFont : .buttonFont
        button.alpha = selected ? 1 : 0.25
    }
    
    @objc private func buttonTapped(_ button: UIButton) {
        isUserInteractionEnabled = false
        
        let title = button.currentTitle!
        let didSelectNewTitle = title != selectedTitle
        
        let group = DispatchGroup()
        
        if didSelectNewTitle {
            let previouslySelectedButton = buttons.first { $0.currentTitle == selectedTitle }!
            
            group.enter()
            
            UIView.animate(withDuration: 0.4) {
                self.configureButton(previouslySelectedButton, forSelected: false)
                self.configureButton(button, forSelected: true)
            } completion: { _ in
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.selectedTitle = title
            self.isUserInteractionEnabled = true
            
            if didSelectNewTitle {
                self.delegate?.willySwitch(didSelectTitle: title)
            }
        }
    }
}

fileprivate extension UIFont {
    static let buttonFont = UIFont(name: "Helvetica-Bold", size: 15)!
    static let selectedButtonFont = UIFont(name: "Helvetica-Bold", size: 17)!
}
