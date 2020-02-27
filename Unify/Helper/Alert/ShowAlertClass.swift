import UIKit
import Foundation

typealias CompletionHandler = (_ buttonIndex: Int) -> Void

class ShowAlertClass: NSObject {
    var ActionHandler:CompletionHandler?

    class func instantiateClass() -> Any? {
        var singletonInstance: ShowAlertClass? = nil
        var onceToken: Int = 0
        if (onceToken == 0) {
            /* TODO: move below code to a static variable initializer (dispatch_once is deprecated) */
            if singletonInstance == nil {
                singletonInstance = ShowAlertClass()
            }
        }
        onceToken = 1
        return singletonInstance
    }

    func showAlert(withTitle strTitle: String?, message strMessage: String?, handler actionHandler: @escaping CompletionHandler, withAlertButtons arrAlertButtons: [Any]?, target: UIViewController?) {
        ActionHandler = actionHandler

        //iOS 8+
        let alertController = UIAlertController(title: strTitle, message: strMessage, preferredStyle: .alert)
        for i in 0..<(arrAlertButtons?.count ?? 0) {
            let aDoneAction = UIAlertAction(title: arrAlertButtons![i] as? String, style: .default, handler: {(_ action: UIAlertAction?) -> Void in
                if (self.ActionHandler != nil) {
                    self.ActionHandler!(i)
                }
            })
            alertController.addAction(aDoneAction)
        }
        target?.present(alertController, animated: true) {() -> Void in }

    }
}
