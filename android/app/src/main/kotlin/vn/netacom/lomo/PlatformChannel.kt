package vn.netacom.lomo

import com.asia.sdkcore.entity.ui.user.NeUser
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.*
import vn.netacom.lomo.callback.OnCheckFriendListener

class PlatformChannel {
    private var sendChannel: MethodChannel? = null
    private val sendChannelName = "callbacks"
    lateinit var receiveChannel: MethodChannel
    private val receiveChannelName = "vn.netacom.lomo/flutter_channel"
    var isInit = false

    companion object {
        var instance = PlatformChannel()
    }

    fun init(binaryMessenger: BinaryMessenger) {
        sendChannel = MethodChannel(binaryMessenger, sendChannelName)
        receiveChannel = MethodChannel(binaryMessenger, receiveChannelName)
        isInit = true
    }

    fun sendEventNetAloSessionExpire() {
        sendChannel?.invokeMethod("netAloSessionExpire", null)
    }

    fun sendEventNetAloExit() {
        sendChannel?.invokeMethod("netAloExit", null)
    }

    fun sendEventNetAloPushNotification(data: Map<String, String>) {
        sendChannel?.invokeMethod("netAloPushNotification", data)
    }

    fun sendEventNetAloChatPushNotification(data: NeUser) {
        sendChannel?.invokeMethod("netAloChatPushNotification", data)
    }

    fun sendEventDeepLink(url:String?){
        sendChannel?.invokeMethod("sendEventDeepLink", url)
    }

    fun sendEventHandleLinkFromNetAlo(url:String?){
        sendChannel?.invokeMethod("sendEventHandleLinkFromNetAlo", url)
    }

    fun sendEventAppToBackground(){
        sendChannel?.invokeMethod("appToBackground", null)
    }

    fun sendEventAppToForeground(){
        sendChannel?.invokeMethod("appToForeground", null)
    }

    fun sendEventUpdateBadgeChat(badges:Int){
        sendChannel?.invokeMethod("updateBadgeChat", badges)
    }

    fun sendEventPressVideoCallChat(){
        sendChannel?.invokeMethod("pressVideoCallChat", null)
    }

    fun sendEventPressCallChat(){
        sendChannel?.invokeMethod("pressCallChat", null)
    }

    fun sendEventCheckIsFriend(targetNetAloId: Long? = 0L, callBack: OnCheckFriendListener){
        sendChannel?.invokeMethod("checkIsFriend", targetNetAloId, object : Result {
            override fun success(result: Any?) {
                result?.let {
                    callBack.onChecked(it as Boolean)
                }
            }

            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                callBack.onChecked(false)
            }

            override fun notImplemented() {
            }

        })
    }
}