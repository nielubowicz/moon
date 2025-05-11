import EventKitUI
import SwiftUI

final class EventViewControllerDelegate: NSObject, EKEventEditViewDelegate {
    var isShowingEventScreen: Binding<Bool>
    
    init(isShowingEventScreen: Binding<Bool>) {
        self.isShowingEventScreen = isShowingEventScreen
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        isShowingEventScreen.wrappedValue = false
    }
}
