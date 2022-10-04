package vn.netacom.lomo.tracking

import android.content.Context
import com.facebook.appevents.AppEventsLogger

class FacebookTracking {
    lateinit var logger:AppEventsLogger

    companion object {
        var instance = FacebookTracking()
    }

    fun init(context: Context){
         logger = AppEventsLogger.newLogger(context)
    }

    fun tracking(event:String){
        logger.logEvent(event)
    }
}