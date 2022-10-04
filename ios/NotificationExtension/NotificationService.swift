//
//  NotificationService.swift
//  Runner
//
//  Created by Hieu Bui Van  on 22/12/2021.
//

import UserNotifications
import RxSwift
import Resolver
import NotificationComponent

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    private var disposeBag = DisposeBag()
    @LazyInjected private var notificationRepo: NotificationComponent
    
    override init() {
        super.init()
        
        notificationRepo.initialize()
    }
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            notificationRepo.replace(oldContent: bestAttemptContent)
                .do(onSuccess: { (newContent) in
                    contentHandler(newContent)
                })
                .subscribe()
                .disposed(by: disposeBag)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(
                notificationRepo.expired(oldContent: bestAttemptContent)
            )
        }
    }

}

