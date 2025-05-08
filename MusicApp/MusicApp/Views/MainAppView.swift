//
//  MainAppView.swift
//  MusicApp
//
//  Created by Jack Miller on 5/6/25.
//

import SwiftUI

struct MainAppView: View {
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        if viewModel.userSession != nil {
            ContentView(authVM: viewModel)
        } else {
            LoginView(viewModel: viewModel)
        }
    }
}
