//
//  MethodChannel.swift
//  Runner
//
//  Created by Meo Luoi on 18/11/2020.
//

import Foundation

class MethodChannel{
    static let instance = MethodChannel()
    private var sendChannel:FlutterMethodChannel?
    private let sendChannelName = "callbacks"
    public var receiveChannel:FlutterMethodChannel?
    private let receiveChannelName = "vn.netacom.lomo/flutter_channel"
    
    init(){}
    
    func initChannel(messenger:FlutterBinaryMessenger){
        sendChannel = FlutterMethodChannel(name: sendChannelName,
                                           binaryMessenger: messenger)
        
        receiveChannel = FlutterMethodChannel(name: receiveChannelName,
                                              binaryMessenger:messenger)
    }
    
    func sendResult(){
        self.sendChannel?.invokeMethod("callListener", arguments: ["name":"hehe","age":1])
    }
    
    func sendEventNetAloSessionExpire(){
        self.sendChannel?.invokeMethod("netAloSessionExpire", arguments: [])
    }
    
    func sendEventNetAloExit() {
        self.sendChannel?.invokeMethod("netAloExit", arguments: [])
    }
    
    func sendEventShowToast(message:String){
        self.sendChannel?.invokeMethod("showToast", arguments: message)
    }
    
    func sendEventAppToBackground(){
        self.sendChannel?.invokeMethod("appToBackground", arguments: [])
    }
    
    func sendEventAppToForeground(){
        self.sendChannel?.invokeMethod("appToForeground", arguments: [])
    }
    
    func sendEventDeepLink(url:String?){
        print("urlDeepLinkIos: \(url ?? "")")
        self.sendChannel?.invokeMethod("sendEventDeepLink", arguments: url)
    }
    
    func sendEventHandleLinkFromNetAlo(url:String?){
        self.sendChannel?.invokeMethod("sendEventHandleLinkFromNetAlo", arguments: url)
    }
    
    func sendEventCheckIsFriend(targetNetAloId: String = "0", completion: @escaping (Bool) -> ()){
        self.sendChannel?.invokeMethod("checkIsFriend", arguments: targetNetAloId, result: {(r:Any?) -> () in
            let isFriend  = r as? Bool ?? false
            print("Check friend with targetNetAloId 💪💪💪 \(targetNetAloId) and lomo result 💪💪💪 \(isFriend)")
            completion(isFriend)
        })
    }
    
    func sendEventUpdateBadgeChat(badges:Int){
        self.sendChannel?.invokeMethod("updateBadgeChat", arguments: badges)
    }
    
    func sendEventPressCallChat(){
        self.sendChannel?.invokeMethod("pressCallChat", arguments: [])
    }
    
    func sendEventPressVideoCallChat(){
        self.sendChannel?.invokeMethod("pressVideoCallChat", arguments: [])
    }
}
