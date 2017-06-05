import UIKit

final class TargetAction: NSObject {
    let callback: () -> ()
    init(callback: @escaping () -> ()) {
        self.callback = callback
    }
    
    func action(sender: Any) {
        self.callback()
    }
}

final class TextFieldDelegate: NSObject, UITextFieldDelegate {
    var didEnd: ((String?) -> ())?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        didEnd?(textField.text)
    }
}

enum ContentElement {
    case label(String)
    case button(String, () -> ())
    case image(UIImage)
    case textField(placeholder: String?, didEnd: (String?) -> ())
}

extension ContentElement {
    func render() -> (UIView, Any?) {
        switch self {
        case .label(let text):
            let label = UILabel()
            label.numberOfLines = 0
            label.text = text
            return (label, nil)
        case .button(let title, let callback):
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            let target = TargetAction(callback: callback)
            button.addTarget(target, action: #selector(TargetAction.action(sender:)), for: .touchUpInside)
            return (button, target)
        case .image(let image):
            return (UIImageView(image: image), nil)
        case let .textField(placeholder: placeholder, callback):
            let field = UITextField()
            field.borderStyle = .roundedRect
            field.placeholder = placeholder
            let delegate = TextFieldDelegate()
            delegate.didEnd = callback
            field.delegate = delegate
            return (field, delegate)
        }
    }
}

final class StackViewController: UIViewController {
    let elements: [ContentElement]
    var strongReferences: [Any] = []
    
    init(elements: [ContentElement]) {
        self.elements = elements
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        for (view, strongReference) in elements.map({ $0.render() }) {
            stack.addArrangedSubview(view)
            if let s = strongReference { strongReferences.append(s) }
        }
        view.addSubview(stack)
        stack.constrainEqual(.width, to: view)
        stack.center(in: view)
    }
}


let elements: [ContentElement] = [
    .label("Please login"),
    .textField(placeholder: "Name", didEnd: {
        print("name: \($0)")
    }),
    .textField(placeholder: "Password", didEnd: {
        print("password: \($0)")
    }),
    .button("Login", {
        print("Button tapped")
    }),
]

let vc = StackViewController(elements: elements)
vc.view.frame = CGRect(x: 0, y: 0, width: 320, height: 300)


import PlaygroundSupport
PlaygroundPage.current.liveView = vc
