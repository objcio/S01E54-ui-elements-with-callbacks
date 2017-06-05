import UIKit

extension UIView {
    public func constrainEqual(_ attribute: NSLayoutAttribute, to: Any, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        constrainEqual(attribute, to: to, attribute, multiplier: multiplier, constant: constant)
    }
    
    public func constrainEqual(_ attribute: NSLayoutAttribute, to: Any, _ toAttribute: NSLayoutAttribute, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: to, attribute: toAttribute, multiplier: multiplier, constant: constant)
        ])
    }
    
    public func constrainEdges(to view: UIView) {
        constrainEqual(.top, to: view, .top)
        constrainEqual(.leading, to: view, .leading)
        constrainEqual(.trailing, to: view, .trailing)
        constrainEqual(.bottom, to: view, .bottom)
    }

    /// If the `view` is nil, we take the superview.
    public func center(in view: UIView? = nil) {
        guard let container = view ?? self.superview else { fatalError() }
        centerXAnchor.constrain(equalTo: container.centerXAnchor)
        centerYAnchor.constrain(equalTo: container.centerYAnchor)
    }
}

extension NSLayoutAnchor {
    public func constrain(equalTo anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat = 0) {
        constraint(equalTo: anchor, constant: constant).isActive = true
    }
}
