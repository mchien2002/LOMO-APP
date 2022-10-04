//
//  Injection.swift
//  Runner
//
//  Created by Hieu Bui Van  on 22/12/2021.
//

import Resolver
import NotificationComponent

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register {
            NotificationComponentImpl(enviroment: BuildConfig.enviroment,
                                      appGroupId: BuildConfig.appGroupId) as NotificationComponent }
            .scope(.cached)
    }
}
