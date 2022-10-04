import UIKit
import Flutter
import Firebase
import AppsFlyerLib
import FBSDKCoreKit
import NetAloFull
import NetAloLite
import XCoordinator
import NATheme
import RxCocoa
import RxSwift
import NADomain

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, TestDelegate {
    var currentResult:FlutterResult?
    
    //SDK V2
    public var netAloFull: NetAloFull!
    private var disposeBag = DisposeBag()
    
    private lazy var mainWindow = UIWindow(frame: UIScreen.main.bounds)

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.netAloFull = NetAloFull(config: BuildConfig.config)
        
        // Only show SDK after start success, Waiting maximun 10s
        self.netAloFull
            .start()
            .timeout(.seconds(10), scheduler: MainScheduler.instance)
            .catchAndReturn(())
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .do(onNext: { (owner, _) in
                // Init rooter
                owner.netAloFull.buildSDKModule()
            })
            .subscribe()
            .disposed(by: disposeBag)
        
                FirebaseApp.configure()
                
                let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
                MethodChannel.instance.initChannel(messenger: controller.binaryMessenger)
                
                MethodChannel.instance.receiveChannel?.setMethodCallHandler({
                    (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                    self.currentResult = result
                    switch (call.method){
                    case "showTestScreen":
                        print("showTestScreen")
                    case "openChatConversation":
                        self.openChatConversation(result: result)
                    case "initNetAloSDK":
                        result(true)
                        print("initNetAloSDK")
                    case "openChatWithUser":
                        self.openChatWithUser(call:call,result: result)
                    case "setNetaloUser":
                        self.setNetaloUser(call: call,result: result)
                        self.registerRemoteToken()
                    case "setEnvironmentNetAloSdk":
                        let env = call.arguments as! String
                        self.setEnviroment(env,result: result)
                        result(true)
                        print("setEnvironmentNetAloSdk")
                    case "pickImages":
                        self.openImagePicker(call: call,result: result)
                    case "blockUser":
                        self.blockUser(call: call,result: result)
                    case "unBlockUser":
                        self.unBlockUser(call: call,result: result)
                    case "setDomainLoadAvatarNetAloSdk":
                        self.setImageDomain(call: call, result: result)
                    case "sendMessage" :
                        self.sendMessage(call: call, result: result)
                    case "closeNetAloChat": break
                        //                self.closeSDK()
                    case "checkGroupChatExist":
                        self.checkGroupChatExist(call: call, result: result)
                    case "facebookTracking":
                        self.facebookTracking(call: call, result: result)
                    case "shareLink":
                        self.shareLink(call: call, result: result)
                    case "getNumbersOfBadgesChat":
                        self.getNumbersOfBages(call: call, result: result)
                    case "logOutNetAloSDK":
                        self.logout()
                    case "setFollowUser":
                        self.setFollowUser(call: call, result: result)
                    case "setHasFollowByUser":
                        self.setHasFollowByUser(call: call, result: result)
                    case "deleteAccount":
                        self.deleteAccount(call: call, result: result)
                    case "activeUser":
                        self.activeUser(call: call, result: result)
                    default:
                        result(FlutterMethodNotImplemented)
                    }
                })
                
                GeneratedPluginRegistrant.register(with: self)
                
                let _ = netAloFull.application(application, didFinishLaunchingWithOptions: launchOptions)
                
                if #available(iOS 10.0, *) {
                    UNUserNotificationCenter.current().delegate = self
                }
        
        if #available(iOS 14.0, *) {
            Settings.setAdvertiserTrackingEnabled(true)
        }
        
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func activeUser(call: FlutterMethodCall,result: @escaping FlutterResult){
        guard let args = call.arguments else {
            return
        }
        
        let myArgs = args as! [String: Any]
        
        let status = myArgs["status"] as? Int ?? 0
        let targetUser = myArgs["user"] as! [String: Any]
        
        let netaloId = targetUser["id"] as? Int64 ?? 0
        let username = targetUser["name"] as? String ?? ""
        let avatar = targetUser["avatar"] as? String ?? ""
    
        netAloFull.updateDeactiveUser(userId:netaloId,deactiveId:status){ _status, error in
            dump("updateDeactiveUser 💪💪💪 : \(_status) - \(status) - \(netaloId)======> \(error?.description ?? "")")
        }
        
        print("activeUser: \(status) - \(netaloId)")
    }
    
    
    
    func setFollowUser(call: FlutterMethodCall,result: @escaping FlutterResult){
        guard let args = call.arguments else {
            return
        }
        
        let myArgs = args as! [String: Any]

        let isFollow  = myArgs["isFollow"] as? Bool ?? false
        let targetUser = myArgs["targetUser"] as! [String: Any]
        let netaloId = targetUser["netAloId"] as? Int64 ?? 0
        let username = targetUser["name"] as? String ?? ""
        let avatar = targetUser["avatar"] as? String ?? ""
    
        
        print("setFollowUser: \(isFollow) - \(netaloId) - \(username) - \(avatar) -")
        
        if isFollow {
            netAloFull.setFollow(contactId: netaloId) { status, error in
                dump("IOS-Test Followed 💪💪💪 : \(status) ======> \(error)")
            }
        }else {
            netAloFull.setUnFollow(contactId: netaloId) { status, error in
                dump("IOS-Test UnFollowed 💪💪💪 : \(status) ======> \(error)")
            }
        }
    }
    
    func setHasFollowByUser(call: FlutterMethodCall,result: @escaping FlutterResult){
        guard let args = call.arguments else {
            return
        }
        
        let myArgs = args as! [String: Any]

        let isFollow  = myArgs["isFollow"] as? Bool ?? false
        let targetUser = myArgs["targetUser"] as! [String: Any]
        let netaloId = targetUser["netAloId"] as? Int64 ?? 0
        let username = targetUser["name"] as? String ?? ""
        let avatar = targetUser["avatar"] as? String ?? ""
    
        
        print("setHasFollowByUser: \(isFollow) - \(netaloId) - \(username) - \(avatar) -")
        
        netAloFull.setUserInFriend(status: isFollow)
    }
    
    func deleteAccount(call: FlutterMethodCall,result: @escaping FlutterResult){
        guard let args = call.arguments else {
            return
        }
        
        let myArgs = args as! [String: Any]
        let reasonId = myArgs["reasonId"] as? String ?? "4"
        let reasonText = myArgs["reasonText"] as? String ?? ""
        //
        netAloFull.requestDeleteAccountSDK(with: reasonText, id: reasonId) { [weak self] err in
            print("Error \(err?.description)")
            guard let _ = err else {
                //Error
                return
            }
            
        }
    }
    
    func shareLink(call: FlutterMethodCall,result: @escaping FlutterResult){
        guard let link = call.arguments as? String else {
            return
        }
        
        let items:[Any] = [URL(string: link)!]
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.window?.rootViewController?.present(activity, animated: true, completion: nil)
        activity.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            if completed  {
                self.window?.rootViewController?.dismiss(animated: true, completion: nil)
                result(true)
            }else{
                if (error != nil){
                    self.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    print("errorShare")
                    result(false)
                }else{
                    if (activityType?.rawValue == "vn.com.vng.zingalo.shareext"){
                        self.window?.rootViewController?.dismiss(animated: true, completion: nil)
                        result(true)
                    }else{
                        result(false)
                    }
                }
            }
        }
    }
    
    func facebookTracking(call: FlutterMethodCall,result: @escaping FlutterResult){
        guard let args = call.arguments else {
            return
        }
        
        let myArgs = args as! [String: Any]
        let event  = myArgs["event"] as? String ?? ""
        FacebookTracking.instance.tracking(event: event)
    }

    private func formatPhone(phone:String) -> String{
        var result = phone
        if (phone.starts(with: "0")){
            result = phone.replacingCharacters(in: ...phone.startIndex, with: "+84")
        }
        return result
    }
    
    //  getName test
    internal func getTestName(name: String) {
        self.currentResult!(name)
    }

    // MARK: - Application Delegates
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")
        MethodChannel.instance.sendEventAppToForeground()
        netAloFull.applicationDidBecomeActive(application)
    }
    
    override func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
        netAloFull.applicationWillTerminate(application)
    }
    
    override func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")
        netAloFull.applicationWillResignActive(application)
        MethodChannel.instance.sendEventAppToBackground()
    }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        netAloFull.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        UserDefaults.standard.setValue(deviceToken, forKey: "deviceToken")
        //Messaging.messaging().apnsToken = deviceToken
        //super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        return netAloFull.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
    
    @objc func didBecomeActiveNotification() {
        AppsFlyerLib.shared().start()
    }
    
    override func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("urlDeeppLink:")
        sendDeepLink(url: url)
        return true
    }
    // Report Push Notification attribution data for re-engagements
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("urlDeeppLink:")
        sendDeepLink(url: url)
        return true
    }
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        AppsFlyerLib.shared().handlePushNotification(userInfo)
    }
    
    func sendDeepLink(url: URL){
        print("vaoDeepLinkNe")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard self != nil else { return }
            print("vaoLoopNe")
            //            MethodChannel.instance.sendEventShowToast(message: url.absoluteString)
            MethodChannel.instance.sendEventDeepLink(url:url.absoluteString)
        }
        
    }
    
}

//MARK: SDK public
extension AppDelegate {
    func checkGroupChatExist(call: FlutterMethodCall,result: @escaping FlutterResult){
        guard let args = call.arguments,
              let userId = args as? Int64
        else {
            result(false)
            return
        }
        
        netAloFull.isChatted(targetUserID: String(userId)) { isChatted in
            print("User has chattes with: \(isChatted)")
            result(isChatted)
        }
    }
    
    func sendMessage(call: FlutterMethodCall,result: @escaping FlutterResult){
        guard let args = call.arguments else {
            result(false)
            return
        }
        
        let myArgs = args as! [String: Any]
        
        let message  = myArgs["message"] as? String ?? ""
        let receiver = myArgs["receiver"] as? [String: Any]
        let receiverId = receiver?["id"] as? Int64 ?? 0
        print("receiverId 🤌 🤌 🤌 🤌 \(receiverId)")
        
        netAloFull.sendMessage(content: message, targetUserID: String(receiverId)) { (isSuccess) in
            print("sendMessage 🤌 🤌 🤌 🤌 : \(isSuccess)")
            result(isSuccess)
        }
    }
    
    func openChatConversation(result: FlutterResult?) -> Void {
        self.netAloFull.showListGroup { err in
            result?(true)
        }
    }
    
    private func setEnviroment(_ env: String,result: @escaping FlutterResult) {
        result(true)
    }
    
    private func setNetaloUser(call: FlutterMethodCall,result: @escaping FlutterResult) {
        guard let args = call.arguments,
              let myArgs = args as? [String: Any],
              let id = myArgs["id"] as? Int64
        else {
            result(false)
            return
        }
        
        
        let phoneNumber = formatPhone(phone: myArgs["phone"] as? String ?? "")
        let fullName = myArgs["username"] as? String ?? ""
        let avatar = myArgs["avatar"] as? String ?? ""
        let token = myArgs["token"] as? String ?? ""
        
        //Set user
        let user = NetAloUserHolder(id: id,
                                    phoneNumber: phoneNumber,
                                    email: "",
                                    fullName: fullName,
                                    avatarUrl: avatar,
                                    session: token)
        dump("myLog user 💪💪💪 \(user)")
        do {
            try self.netAloFull.set(user: user)
        } catch let e {
            print("Error \(e)")
        }
        
        self.bindingService()
        
        result(true)
    }
    
    private func registerRemoteToken() {
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
            guard let deviceToken = UserDefaults.standard.data(forKey: "deviceToken") else { return }
            self.netAloFull.application(UIApplication.shared, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
    private func openChatWithUser(call: FlutterMethodCall,result: @escaping FlutterResult){
        guard let args = call.arguments,
              let myArgs = args as? [String: Any]
        else {
            result(false)
            return
        }
        
        let targetUserArgs = myArgs["target"] as! [String: Any]
//        let isChatWithOA = myArgs["isChatWithOA"] as? Bool ?? false
        //
        let id = targetUserArgs["id"] as? Int64 ?? 0
        let phoneNumber = formatPhone(phone: targetUserArgs["phone"] as? String ?? "")
        let fullName = targetUserArgs["username"] as? String ?? ""
        let avatar = targetUserArgs["avatar"] as? String ?? ""
        
        let contact = NAContact(id: id,
                                phone: phoneNumber,
                                fullName: fullName,
                                profileUrl: avatar)
        self.netAloFull.showChat(with: contact) { err in
            result(true)
        }
    }
    
    private func blockUser(call: FlutterMethodCall,result: @escaping FlutterResult) {
        guard let args = call.arguments,
              let id = args as? Int
        else {
            result(false)
            return
        }
        
        netAloFull.blockUser(blockedID: String(id)) { isSuccess in
            print("Block user \(isSuccess)")
            result(isSuccess)
        }
    }
    
    private func unBlockUser(call: FlutterMethodCall,result: @escaping FlutterResult) {
        guard let args = call.arguments,
              let id = args as? Int
        else {
            result(false)
            return
        }
        
        netAloFull.unblockUser(blockedID: String(id)) { isSuccess in
            print("Block user \(isSuccess)")
            result(isSuccess)
        }
    }
    
    private func setImageDomain(call: FlutterMethodCall,result: @escaping FlutterResult) {
        guard let urlString = call.arguments as? String else { return }
        // TODO: Need recheck, must set domain after init sdk
        self.netAloFull.setUserProfileUrl(with: urlString)
        print("DomainAvatarLomo:\(urlString) -  \(self.netAloFull.getUserProfileUrl())")
        
        result(true)
    }
    
    private func openImagePicker(call: FlutterMethodCall,result: @escaping FlutterResult) {
        guard let args = call.arguments,
              let myArgs = args as? [String: Any]
        else { return }
        
        let type = MultiImagePickerConfig.AssetMediaType(rawValue: myArgs["type"] as? Int ?? 0) ?? .all
        let maxSelection = myArgs["maxImages"] as? Int ?? 1
        let autoDismiss = myArgs["autoDismissOnMaxSelections"] as? Bool ?? false
        
        let config = MultiImagePickerConfig(
            resultType: .url,
            autoDismiss: true,
            maxSelections: maxSelection,
            autoDismissOnMaxSelections: autoDismiss,
            showDoneButton: true,
            assetMediaType: type
        )
        
        netAloFull.showMedia(pickerConfig: config)
    }
    
    private func getNumbersOfBages(call: FlutterMethodCall,result: @escaping FlutterResult) {
        netAloFull.getNumberOfBadge { (bages) in
            result(bages)
        }
    }
}

//MARK: SDK callback and send event to Client
extension AppDelegate {
    //SDK binding service
    private func bindingService() {
        self.netAloFull.eventObservable
            .asDriverOnErrorJustSkip()
            .drive(onNext: { [weak self] event in
                guard let self = self else { return }
                dump("Event 🤟🏻🤟🏻🤟🏻🤟🏻🤟🏻🤟🏻 \(event)")
                switch event {
                case .mediaURL(let imageUrls, let videoUrls):
                    dump("Images 💪💪💪: \(imageUrls)")
                    dump("Video 💪💪💪: \(videoUrls)")
                    let imageUrls = imageUrls.map {$0.path}
                    if let cb = self.currentResult {cb(imageUrls)}
                case .checkUserIsFriend(let userId):
                    dump("Check Chat with 💪💪💪 : \(userId)")
                    self.checkChatFunctions(with: "\(userId)")
                case .didCloseSDK:
                    self.didCloseSDK()
                    dump("didCloseSDK 💪💪💪")
                case .pressedCall(let type):
                    dump("pressedCall 💪💪💪 type \(type)")
                    self.didPressed(callEvent: type)
                case .socketError(let error):
                    switch error {
                    case .expired:
                        dump("socketError 💪💪💪 \(error.description)")
                        self.sessionExpired()
                    default:
                        dump("socketError 💪💪💪 \(error.description)")
                    }
                case .updateBadge(let badge):
                    dump("updateBadge 💪💪💪 \(badge)")
                    MethodChannel.instance.sendEventUpdateBadgeChat(badges: badge)
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    private func checkChatFunctions(with userId: String) {
        MethodChannel.instance.sendEventCheckIsFriend(targetNetAloId: userId, completion: { [self]
            (isFriend:Bool)->() in
            print("CheckFriend: \(isFriend)")
            
            netAloFull.setUserInFriend(status: isFriend)
        })
    }
    
    private func didCloseSDK() {
        MethodChannel.instance.sendEventNetAloExit()
    }
    
    private func sessionExpired() {
        MethodChannel.instance.sendEventNetAloSessionExpire()
    }
    
    private func logout() {
        netAloFull.logout()
    }
    
    private func didPressed(url: String) {
        print("DidPressed URL: \(url)")
        MethodChannel.instance.sendEventHandleLinkFromNetAlo(url: url)
    }
    
    private func didPressed(callEvent: CallType) {
        switch callEvent {
        case .voice:
            MethodChannel.instance.sendEventPressCallChat()
            print("Audio Call")
        case .video:
            MethodChannel.instance.sendEventPressVideoCallChat()
            print("Video Call")
        }
    }
}

//MARK: - NOTIFICATION
extension AppDelegate {
    public override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        super.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
        
        self.netAloFull.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
    }
    
    public override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
        
        self.netAloFull.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
    }
    
}


