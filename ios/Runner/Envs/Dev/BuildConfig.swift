//
//  BuildConfig.swift
//  Runner-Dev
//
//  Created by Hieu Bui Van  on 22/12/2021.
//

import NetAloLite
import NetAloFull

struct BuildConfig {
    static var config = NetaloConfiguration(
        enviroment: .testing,
        appId: 2,
        appKey: "lomokey",
        accountKey: "adminkey",
        appGroupIdentifier: "group.vn.netacom.lomo-dev",
        analytics: [],
        mailSupport: "",
        featureConfig: FeatureConfig(
            user: FeatureConfig.UserConfig(
                forceUpdateProfile : true,
                allowCustomUsername: true,
                allowCustomProfile : true,
                allowCustomAlert   : true,
                allowAddContact    : false,
                allowBlockContact  : true,
                allowSetUserProfileUrl   : true,
                allowEnableLocationFeature: true,
                allowTrackingUsingSDK: true,
                allowTrackingBadgeNumber: true,
                allowRecieverChatInOA: false,
            ),
            chat: FeatureConfig.ChatConfig(isVideoCallEnable: false,
                                           isVoiceCallEnable: false),
            isSyncDataInApp: true
        ), userProfileUrl: "http://128.199.69.106:9000"
    )
}







