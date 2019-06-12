import UIKit

protocol ObserverProtocol: class {
    func updateSubscriber(_ notification: CustomNotificationManager)
}

class CustomNotificationManager {
    static let shared = CustomNotificationManager()
    var textForSubscriber = ""

    private var subscribersArray: [ObserverProtocol] = [ObserverProtocol]()

    func subscribe(_ subscriber: ObserverProtocol) {
        self.subscribersArray.append(subscriber)
    }

    func unsubscribe(_ subscriber: ObserverProtocol) {
        guard !subscribersArray.isEmpty else { return }
        if let index = subscribersArray.firstIndex(where: {$0 === subscriber}) {
            subscribersArray.remove(at: index)
        }
    }

    func notify() {
        for subscriber in subscribersArray {
            subscriber.updateSubscriber(self)
        }
    }

    func someBusinessLogic(message: String) {
        textForSubscriber = message
        notify()
    }
}

class SubscriberA: ObserverProtocol {
    func updateSubscriber(_ notification: CustomNotificationManager) {
        print("Subscriber A get message: \(notification.textForSubscriber)")
    }
}

class SubscriberB: ObserverProtocol {
    func updateSubscriber(_ notification: CustomNotificationManager) {
        print("Subscriber B get message: \(notification.textForSubscriber)")
    }
}

let subscriberA = SubscriberA()
let subscriberB = SubscriberB()
CustomNotificationManager.shared.subscribe(subscriberA)
CustomNotificationManager.shared.subscribe(subscriberB)
CustomNotificationManager.shared.someBusinessLogic(message: "The new video was published! Check, please :)")
CustomNotificationManager.shared.unsubscribe(subscriberA)
CustomNotificationManager.shared.someBusinessLogic(message: "New message sent! Check, please :)")
