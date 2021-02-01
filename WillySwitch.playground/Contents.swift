//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController, WillySwitchDelegate {
    private weak var toggle: WillySwitch!
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newToggle = WillySwitch(titles: ["Option 1", "Option 2", "Option 3"])
        newToggle.translatesAutoresizingMaskIntoConstraints = false
        newToggle.layer.borderWidth = 2
        toggle = newToggle
        
        view.addSubview(toggle)
        
        NSLayoutConstraint.activate([
            toggle.widthAnchor.constraint(equalToConstant: 300),
            toggle.heightAnchor.constraint(equalToConstant: 68),
            toggle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            toggle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func willySwitch(didSelectTitle title: String) {
        //
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
