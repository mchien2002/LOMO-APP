@file:OptIn(InternalCoroutinesApi::class)

package vn.netacom.lomo

import android.content.Context
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent
import androidx.lifecycle.ProcessLifecycleOwner
import androidx.work.Configuration
import com.asia.sdkcore.entity.ui.theme.NeTheme
import com.asia.sdkcore.sdk.SdkConfig
import com.asia.sdkui.ui.sdk.NetAloSDK
import com.asia.sdkui.ui.sdk.NetAloSdkCore
import dagger.hilt.android.HiltAndroidApp
import io.flutter.app.FlutterApplication
import io.realm.Realm
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.InternalCoroutinesApi
import vn.netacom.lomo.tracking.FacebookTracking
import javax.inject.Inject

@ExperimentalCoroutinesApi
@FlowPreview
@HiltAndroidApp
class MyApp : FlutterApplication(),
        Configuration.Provider, LifecycleObserver {
    @Inject
    lateinit var netAloSdkCore: NetAloSdkCore

    override fun getWorkManagerConfiguration() =
            Configuration.Builder()
                    .setWorkerFactory(netAloSdkCore.workerFactory)
                    .build()


    private val sdkConfig = SdkConfig(
            appId = 2,
            appKey = "lomokey",
            accountKey = "adminkey",
            isSyncContact = false,
            hidePhone = true,
            hideCreateGroup = true,
            hideAddInfoInChat = true,
            hideInfoInChat = true,
            hideCallInChat = true,
            classMainActivity = MainActivity::class.java.name
    )

    private val sdkTheme = NeTheme(
            mainColor = "#9c5aff",
            subColorLight = "#ebdeff",
            subColorDark = "#683A00",
            toolbarDrawable = "#9c5aff"
    )

    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        Realm.init(this)
    }

    override fun onCreate() {
        super.onCreate()
        NetAloSDK.initNetAloSDK(
                context = this,
                netAloSdkCore = netAloSdkCore,
                sdkConfig = sdkConfig,
                neTheme = sdkTheme
        )
        ProcessLifecycleOwner.get().lifecycle.addObserver(this)
        FacebookTracking.instance.init(this)
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_START)
    fun onStart() {
        try{
            if (PlatformChannel.instance.isInit)
                PlatformChannel.instance.sendEventAppToForeground()
        }catch (e:Exception){

        }
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
    fun onStop() {
        try{
            if (PlatformChannel.instance.isInit)
                PlatformChannel.instance.sendEventAppToBackground()
        }catch (e:Exception){

        }
    }

}