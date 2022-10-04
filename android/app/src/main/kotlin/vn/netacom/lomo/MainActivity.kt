@file:Suppress("UNREACHABLE_CODE")
@file:OptIn(ObsoleteCoroutinesApi::class, InternalCoroutinesApi::class)

package vn.netacom.lomo

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.ContentResolver
import android.content.Intent
import android.graphics.Bitmap
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.NotificationCompat
import com.asia.sdkbase.logger.Logger
import com.asia.sdkui.ui.sdk.NetAloSDK
import com.asia.sdkcore.config.EndPoint
import com.asia.sdkcore.define.*
import com.asia.sdkcore.entity.ui.local.LocalFileModel
import com.asia.sdkcore.entity.ui.user.NeUser
import com.asia.sdkcore.network.model.response.SettingResponse
import com.asia.sdkcore.sdk.*
import com.asia.sdkcore.util.CallbackResult
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.collect
import vn.netacom.lomo.callback.OnCheckFriendListener
import vn.netacom.lomo.tracking.FacebookTracking
import java.io.File
import java.util.concurrent.TimeUnit
import kotlin.coroutines.CoroutineContext


@InternalCoroutinesApi
@FlowPreview
@ExperimentalCoroutinesApi
class MainActivity : FlutterActivity(), CoroutineScope {
    override val coroutineContext: CoroutineContext
        get() = Dispatchers.Main

    companion object {
        val LAUNCH_SECOND_ACTIVITY = 1
        val SHARE_LINK = 2
    }

    var currentResult: MethodChannel.Result? = null
    var netAloSDKEnvironment = "" // dev,pro
    var deepLinkUri: Uri? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        deepLinkUri = intent?.data
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val audioAttributes = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                .build()
            val channel = NotificationChannel(
                "notification_lomo",
                "LOMO",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            channel.setShowBadge(true)
            channel.description = ""
            channel.enableVibration(true)
            channel.vibrationPattern = longArrayOf(400, 400)
            channel.lockscreenVisibility = NotificationCompat.VISIBILITY_PUBLIC
            channel.setSound(
                Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + packageName + "/raw/notification_sound"),
                audioAttributes
            )
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
        intent.extras?.getParcelable<NeUser>(NavigationDef.ARGUMENT_NEUSER)?.apply {
            val neUser = this
            Logger.e("MainActivity:neUser===$this")

            NetAloSDK.openNetAloSDK(
                this@MainActivity,
                false,
                null,
                NeUser(
                    id = neUser.id,
                    token = neUser.token ?: "",
                    username = neUser.username ?: "",
                    isOA = neUser.isOA ?: false
                )
            )

        }

        launch {
            try {
                NetAloSDK.netAloEvent?.receive<ArrayList<LocalFileModel>>()?.collect { listPhoto ->
                    Logger.e("SELECT_PHOTO_VIDEO==$listPhoto")
                    val photoPaths = listPhoto.map { it.filePath }
                    currentResult?.success(photoPaths)
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
        launch {
            try {
                NetAloSDK.netAloEvent?.receive<SdkStringSend>()?.collect { data ->
                    Logger.e("SdkStringSend:data==${data}")
                    when (data.type) {
                        SdkType.URL_PREVIEW -> runOnUiThread { PlatformChannel.instance.sendEventHandleLinkFromNetAlo(data.data) }
                        SdkType.BADGE -> {
                        }
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
        launch {
            try {
                NetAloSDK.netAloEvent?.receive<SdkIntSend>()?.collect { data ->
                    Logger.e("SdkIntSend:data==${data}")
                    runOnUiThread {
                        when (data.type) {
                            SdkType.URL_PREVIEW -> {
                            }
                            SdkType.BADGE -> PlatformChannel.instance.sendEventUpdateBadgeChat(data.data)
                            SdkType.CALL_VOICE -> {
                                PlatformChannel.instance.sendEventPressCallChat()
                            }
                            SdkType.CALL_VIDEO -> {
                                PlatformChannel.instance.sendEventPressVideoCallChat()
                            }
                        }
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
        launch {
            try {
                NetAloSDK.netAloEvent?.receive<LocalFileModel>()?.collect { document ->
                    Logger.e("SELECT_FILE==$document")
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        launch {
            try {
                NetAloSDK.netAloEvent?.receive<SdkCustomChatReceive>()?.collect { sdkCustomChat ->
                    Logger.e("sdkCustomChat11111==$sdkCustomChat")
                    // user for test
                    //id -> {Long@16613} 562949953692027  not friend
                    //id -> {Long@16783} 562949954465668 friend
                    withContext(Dispatchers.Main) {
                        PlatformChannel.instance.sendEventCheckIsFriend(
                            sdkCustomChat.partnerId,
                            object : OnCheckFriendListener {
                                override fun onChecked(isFriend: Boolean) {
                                    Logger.e("checkFriend: $isFriend")
                                    NetAloSDK.netAloEvent?.send(SdkCustomChatSend(isFriend = isFriend))
                                }
                            }
                        )
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        launch {
            try {
                NetAloSDK.netAloEvent?.receive<SdkClickNotification>()?.collect { sdkClickNoti ->
                    Logger.e("SdkClickNotification==$sdkClickNoti")
                    withContext(Dispatchers.Main) {

                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

//        launch {
//            try {
//                NetAloSDK.netAloEvent?.receive<Map<String, String>>()?.collect { notification ->
//                    Logger.e("Notification:data==$notification")
//                    if (notification.containsKey("ejson")) {
//                        Logger.e("lomoFirebase: $notification")
//                        PlatformChannel.instance.sendEventNetAloPushNotification(notification)
//                    }
//                }
//            } catch (e: Exception) {
//                e.printStackTrace()
//            }
//        }

        launch {
            try {
                NetAloSDK.netAloEvent?.receive<Int>()?.collect { errorEvent ->
                    Logger.e("Event:==$errorEvent")
                    try {
                        when (errorEvent) {
                            ErrorCodeDefine.ERRORCODE_FAILED_VALUE -> {
                                Logger.e("Event:Socket error")
                            }
                            ErrorCodeDefine.ERRORCODE_EXPIRED_VALUE -> {
                                Logger.e("Event:Session expired")
                                runOnUiThread { PlatformChannel.instance.sendEventNetAloSessionExpire() }
                            }
                            SdkCodeDefine.SDK_LOGOUT -> {
                                Logger.e("SdkCodeDefine:SDK_LOGOUT")
                            }
                            SdkCodeDefine.SDK_EXIT -> {
                                Logger.e("SdkCodeDefine: SDK_EXIT")
                                runOnUiThread { PlatformChannel.instance.sendEventNetAloExit() }
                            }
                        }
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        PlatformChannel.instance.init(flutterEngine.dartExecutor.binaryMessenger)
        PlatformChannel.instance.receiveChannel.setMethodCallHandler { call, result ->
            currentResult = result
            when (call.method) {
                "openChatConversation" -> openChatConversation(call, result)
                "getNameTest" -> result.success("heheChannel")
                "openChatWithUser" -> openChatWithUser(call, result)
                "setEnvironmentNetAloSdk" -> {
                    netAloSDKEnvironment = call.arguments as String
                    result.success(true)
                }
                "logOutNetAloSDK" -> NetAloSDK.logOut()
                "setNetaloUser" -> setNetaloUser(call, result)
                "pickImages" -> openImagePicker(call, result)
                "blockUser" -> blockUser(call, result, isBlock = true)
                "unBlockUser" -> blockUser(call, result, isBlock = false)
                "checkPermissionCall" -> {
                }
                "setDomainLoadAvatarNetAloSdk" -> setDomainLoadAvatarNetAloSdk(call, result)
                "sendMessage" -> sendMessage(call, result)
                "closeNetAloChat" -> closeNetAloChat()
                "checkGroupChatExist" -> checkGroupChatExist(call, result)
                "facebookTracking" -> facebookTracking(call, result)
                "shareLink" -> shareLink(call, result)
                "getNumbersOfBadgesChat" -> checkBadgeCount(call, result)
                "setFollowUser" -> setFollowUser(call, result)
                "setHasFollowByUser" -> setHasFollowByUser(call, result)
                "deleteAccount"-> deleteAccount(call,result)
                "activeUser"->activeUser(call,result)
            }
        }
    }

    private fun activeUser(call: MethodCall, result: MethodChannel.Result) {
        try {
            val targetUser: HashMap<String, Any> = call.argument("user")!!
            val status = call.argument("status") as? Int ?: 1

            Logger.e("statusUser: $status - userId: ${targetUser["id"]}")
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun deleteAccount(call: MethodCall, result: MethodChannel.Result) {
        try {
            val targetUser: HashMap<String, Any> = call.argument("user")!!
//            val netaloId = targetUser["netAloId"] as? Long ?: 1
            val reasonId = call.argument("reasonId") as? String ?: "4"
            val reasonText: String = call.argument("reasonText") as? String ?: ""
            NetAloSDK.deleteAccount(
                reasonId = reasonId.toInt(),
                reasonDescription = reasonText,
                callbackResult = object : CallbackResult<Boolean> {
                    override fun callBackError(error: String?) {
                        Logger.e("deleteAccount:error: $error")
                        result.success(false)
                    }

                    override fun callBackSuccess(isSuccess: Boolean) {
                        Logger.e("deleteAccount: $isSuccess")
                        result.success(isSuccess)
                    }
                }
            )
            Logger.e("reasonId: $reasonId - reasonText: $reasonText")
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun setFollowUser(call: MethodCall, result: MethodChannel.Result) {
        try {
            val targetUser: HashMap<String, Any> = call.argument("targetUser")!!
            val netaloId = targetUser["netAloId"] as? Long ?: 1
            val name = targetUser["name"] as? String ?: ""
            val isFollow = call.argument("isFollow") as? Boolean ?: false
            NetAloSDK.actionUser(
                userId = netaloId,
                action = if (isFollow) SDKDefine.ADD_USER else SDKDefine.REMOVE_USER,
                callbackResult = object : CallbackResult<Boolean> {
                    override fun callBackError(error: String?) {
                        Logger.e("setFollowUser:error: $error")
                        result.success(false)
                    }

                    override fun callBackSuccess(isSuccess: Boolean) {
                        Logger.e("setFollowUser: $isSuccess")
                        result.success(isSuccess)
                    }
                }
            )
            Logger.e("netaloId: $netaloId - isFollow: $isFollow")
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun setHasFollowByUser(call: MethodCall, result: MethodChannel.Result) {
        try {
            val targetUser: HashMap<String, Any> = call.argument("targetUser")!!
            val netaloId = targetUser["netAloId"] as? Long ?: 1
            val name = targetUser["name"] as? String ?: ""
            val isFollow = call.argument("isFollow") as? Boolean ?: false
            NetAloSDK.setFollow(
                userId = netaloId,
                isFollow = isFollow
            )
            Logger.e("netaloId: $netaloId - isFollow: $isFollow")
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun shareLink(call: MethodCall, result: MethodChannel.Result) {
        val link = (call.arguments as? String)?.let {
            val shareIntent = Intent()
            shareIntent.action = Intent.ACTION_SEND
            shareIntent.putExtra(Intent.EXTRA_TEXT, it)
            shareIntent.type = "text/plain"
            val chooserIntent = Intent.createChooser(shareIntent, null /* dialog title optional */)
            startActivityForResult(chooserIntent, SHARE_LINK)
        }
    }

    private fun facebookTracking(call: MethodCall, result: MethodChannel.Result) {
        val event = call.argument("event") as? String
        if (event != null)
            FacebookTracking.instance.tracking(event)
    }

    private fun checkBadgeCount(call: MethodCall, result: MethodChannel.Result) {
        NetAloSDK.checkBadgeCount(object : CallbackResult<Int> {
            override fun callBackError(error: String?) {
                runOnUiThread { result.success(0) }
            }

            override fun callBackSuccess(badges: Int) {
                Logger.e("checkBagesCount==$badges")
                runOnUiThread {
                    result.success(badges)
                }
            }
        })
    }

    private fun checkGroupChatExist(call: MethodCall, result: MethodChannel.Result) {
        val userId = call.arguments as? Long ?: 0
        NetAloSDK.checkGroupExist(userId) { isExist ->
            runOnUiThread {
                result.success(isExist)
            }
            Logger.e("isExistGroupChat==$isExist")
        }
    }

    private fun sendMessage(call: MethodCall, result: MethodChannel.Result) {
        try {
            val receiver: HashMap<String, Any> = call.argument("receiver")!!
            val message: String = call.argument("message") as? String ?: ""
            NetAloSDK.sendMessage(
                text = message,
                partnerUid = receiver["id"] as? Long ?: 0,
                callbackSuccess = { neSubMessages, tempMessageId, neMessage ->
                    try {
                        Logger.e("onSendMessage = $neMessage neSubMessages=$neSubMessages tempMessageId$tempMessageId")
                        runBlocking(Dispatchers.Main) {
                            currentResult?.success(true)
                        }
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                },
                callbackError = { error, tempMessageId ->
                    try {
                        Logger.e("onSendMessage:callbackError = $error")
                        runBlocking(Dispatchers.Main) {
                            currentResult?.success(false)
                        }
                    } catch (e: Exception) {
                    }
                }
            )
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun openImagePicker(call: MethodCall, result: MethodChannel.Result) {
        val type = when (call.argument("type") as? Int ?: 1) {
            0 -> GalleryType.GALLERY_ALL
            1 -> GalleryType.GALLERY_PHOTO
            2 -> GalleryType.GALLERY_VIDEO
            else -> GalleryType.GALLERY_ALL
        }
        NetAloSDK.openGallery(
            context = this,
            maxSelections = call.argument("maxImages") as? Int ?: 1,
            autoDismissOnMaxSelections = call.argument("autoDismissOnMaxSelections") ?: true,
            galleryType = type
        )
    }

    private fun blockUser(call: MethodCall, result: MethodChannel.Result, isBlock: Boolean) {
        NetAloSDK.blockUser(
            userId = call.arguments as? Long ?: 0,
            isBlock = isBlock,
            callbackResult = object : CallbackResult<Boolean> {
                override fun callBackError(error: String?) {
                    Logger.e("blockUserError: $error")
                    result.success(false)
                }

                override fun callBackSuccess(isSuccess: Boolean) {
                    Logger.e("blockUserSuccess: $isSuccess")
                    result.success(isSuccess)
                }
            }
        )
    }

    private fun setDomainLoadAvatarNetAloSdk(call: MethodCall, result: MethodChannel.Result) {
        NetAloSDK.initSetting(
            settingResponse = SettingResponse(
                apiEndpoint = EndPoint.URL_API,//string
                cdnEndpoint = EndPoint.URL_CDN,
                cdnEndpointSdk = call.arguments as? String ?: "",
                chatEndpoint = EndPoint.URL_SOCKET,
                turnserverEndpoint = EndPoint.URL_TURN
            )
        )
        result.success(true)
    }

    private fun setNetaloUser(call: MethodCall, result: MethodChannel.Result) {
        NetAloSDK.setNetAloUser(
            NeUser(
                id = call.argument("id") as? Long ?: 0,
                token = call.argument("token") as? String ?: "",
                username = call.argument("username") ?: "",
                avatar = call.argument("avatar") as? String ?: ""
            )
        )
        result.success(true)
    }

    private fun openChatConversation(call: MethodCall, result: MethodChannel.Result) {
        NetAloSDK.openNetAloSDK(this)
        result.success(true)
    }

    private fun openChatWithUser(call: MethodCall, result: MethodChannel.Result) {
        val target: HashMap<String, Any> = call.argument("target")!!
        val isChatWithOA = call.argument("isChatWithOA") as? Boolean ?: false
        Log.e("isChatWithOA:", "$isChatWithOA")
        NetAloSDK.openNetAloSDK(
            this,
            false,
            null,
            NeUser(
                id = target["id"] as? Long ?: 0,
                token = target["token"] as? String ?: "",
                username = target["username"] as? String ?: "",
                avatar = target["avatar"] as? String ?: "",
                isOA = isChatWithOA
            )
        )
        result.success(true)
    }

    private fun closeNetAloChat() {
        NetAloSDK.exit()
    }

//    override fun eventFirebase(data: Map<String, String>) {
//        Logger.e("eventFirebase: $data")
//        if (data.containsKey("ejson")) {
//            Logger.e("lomoFirebase: $data")
//            runOnUiThread {
//                PlatformChannel.instance.sendEventNetAloPushNotification(data)
//            }
//        }
//    }

    override fun onStart() {
        super.onStart()
        Logger.e("${this::class.java.simpleName}:onStart")

        if (deepLinkUri?.host != null) {
            launch {
                delay(300)
                runOnUiThread {
                    PlatformChannel.instance.sendEventDeepLink(deepLinkUri.toString())
                    deepLinkUri = null
                }
            }

        }
        Logger.e("dataDeepLink: ${deepLinkUri?.toString()}")
    }

    override fun onStop() {
        super.onStop()
        Logger.e("${this::class.java.simpleName}:onStop")
    }

    override fun onDestroy() {
        super.onDestroy()
        NetAloSDK.exit()
        Logger.e("${this::class.java.simpleName}:onDestroy")
    }

//    override fun eventLogOut(callbackSuccess: () -> Unit) {
//    }
//
//    override fun eventNetAloSessionExpire() {
//        Logger.e("eventNetAloSessionExpire")
//        PlatformChannel.instance.sendEventNetAloSessionExpire()
//    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, intent: Intent?) {
        super.onActivityResult(requestCode, resultCode, intent)
        when (requestCode) {
            SHARE_LINK -> {
                currentResult?.success(true)
            }
            LAUNCH_SECOND_ACTIVITY -> if (resultCode == RESULT_OK) {
                currentResult?.success(intent?.getStringExtra("result"))
            }
        }

    }

}
