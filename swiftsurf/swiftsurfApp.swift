//
//  NavigatorApp.swift
//  Navigator
//
//  Created by Federico Filì on 12/07/24.
//

import SwiftUI

@main
struct swiftsurfApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
