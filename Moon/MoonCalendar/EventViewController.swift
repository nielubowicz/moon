import EventKitUI
import SwiftUI

struct EventViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = EKEventEditViewController
    
    let event: EKEvent
    let eventStore: EKEventStore
    let delegate: EKEventEditViewDelegate
    
    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let controller = EKEventEditViewController()
        controller.event = event
        controller.eventStore = eventStore
        controller.editViewDelegate = delegate
        return controller
    }
    
    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}
}
