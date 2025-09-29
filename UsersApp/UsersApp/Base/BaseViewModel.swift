//
//  BaseViewModel.swift
//  UsersApp
//
//  Created by Oguz Tandogan on 5.09.2023.
//

import Foundation
import Combine

class BaseViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func setLoading(_ loading: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = loading
        }
    }

    func setError(_ message: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = message
        }
    }

    func clearError() {
        setError(nil)
    }
}
