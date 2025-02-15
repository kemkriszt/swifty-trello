//
//  TrelloAuthenticator.swift
//  Briefed
//
//  Created by Krisztián Kemenes on 08.02.2025.
//

#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif

import WebKit
import SecureStore

/// An actor responsible for managing authentication with trello
actor Authenticator {
    private static let messageHandler = "trelloOpener"
    private static let postMessageOrigin = "https://yenovi.com"
    private static let authURL = URL(string: "https://trello.com/1/authorize")!
    
    /// API key identifying the power up associated with this client
    private let apiKey: String
    private let accountKey: String
    private let secureStore: SecureStore
    
    private var currentToken: String?
    private var authenticationTask: Task<Void, Error>?
    
    init(apiKey: String, accountKey: String, secureStore: SecureStore = SecureStore()) {
        self.apiKey = apiKey
        self.accountKey = accountKey
        self.secureStore = secureStore
        self.currentToken = secureStore.retrieveString(for: Self.secretKey(for: accountKey))
#if DEBUG
        print("Trello Client: Restored token \(String(describing: self.currentToken))")
#endif
    }
    
#if canImport(AppKit)
    public func authenticate() async throws {
        
    }
#else
    
    /// Checks if there is a token and if not it will present the user with a webview to log into trello
    /// - Parameter context: View controller to present the login window on. If nil, the root view controller will be used
    public func authenticate(in context: UIViewController? = nil) async throws {
        guard currentToken == nil else { return }
        
        var madeTheTask: Bool = false
        if self.authenticationTask == nil {
            self.authenticationTask = getAuthenticationTask(in: context)
            madeTheTask = true
        }
        
        defer {
            if madeTheTask {
                self.authenticationTask = nil
            }
        }
        try await self.authenticationTask?.value
    }
#endif
    
    /// Create a request that is prepared from an authentication perspective
    public func prepareRequest(for url: URL) async throws -> URLRequest {
        try await self.authenticate()
        
        let finalURL = url.appending(queryItems: [
            URLQueryItem(name: "apiKey", value: self.apiKey),
            URLQueryItem(name: "token", value: self.currentToken!)
        ])
        
        return URLRequest(url: finalURL)
    }
    
    /// Remove the saved token
    public func resetToken() throws {
        try secureStore.delete(for: secretKey)
    }
}

// MARK: - Helpers

extension Authenticator {
    /// Tag used for storing the account token
    private var secretKey: String {
        Self.secretKey(for: self.accountKey)
    }
    
    private static func secretKey(for accountKey: String) -> String {
        "briefed.account.\(accountKey)"
    }
    
    /// Store the token in keychain
    private func store(token: String) throws {
        #if DEBUG
        print("Trello: Storing token: \(token)")
        #endif
        try secureStore.store(secret: token, for: secretKey)
        self.currentToken = token
    }
    
    /// Attempt to load any existing token form the keychain
    private func loadToken() {
        self.currentToken = secureStore.retrieveString(for: secretKey)
    }
    
    /// Create the web view presented for authentication
    @MainActor
    private func getWebView(handler: @escaping AuthMessageHandler.Handler) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.addUserScript(self.getScript())
        contentController.add(AuthMessageHandler(handler: handler), name: Self.messageHandler)
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        
        let finalUrl = Self.authURL.appending(queryItems: [
            URLQueryItem(name: "callback_method", value: "postMessage"),
            URLQueryItem(name: "return_url", value: Self.postMessageOrigin),
            URLQueryItem(name: "scope", value: "read"),
            URLQueryItem(name: "expiration", value: "never"),
            URLQueryItem(name: "key", value: self.apiKey)
        ])
        
        webView.load(URLRequest(url: finalUrl))
        webView.allowsBackForwardNavigationGestures = false

        return webView
    }
    
    /// Create the custom script that catches the Trello token as web view doesn't support listening
    /// to `opener.postMessage` natively
    @MainActor
    private func getScript() -> WKUserScript{
        let js = """
                (function() {
                    window.opener = {
                        postMessage: function(message, targetOrigin) {
                            window.webkit.messageHandlers.\(Self.messageHandler).postMessage(message);
                        }
                    };
                })();
                """
        
        return WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false)
    }
    
#if canImport(UIKit)
    private func getAuthenticationTask(in context: UIViewController?) -> Task<Void, Error> {
        Task {
            guard let presentationContext = await getPresentationContext(context)
            else { throw TrelloError.noPresentationContext }
            
            let result = await withCheckedContinuation { continuation in
                DispatchQueue.main.async {
                    let viewController = self.setupViewController {
                        continuation.resume(returning: $0)
                    }
                    presentationContext.present(viewController, animated: true)
                }
            }
            Task { @MainActor in presentationContext.presentedViewController?.dismiss(animated: true) }
            
            if case .success(let token) = result {
                try self.store(token: token)
            } else if case .failure(let error) = result {
                throw error
            }
        }
    }
    
    /// Create a view controller to host the authentication web view
    @MainActor
    private func setupViewController(handler: @escaping AuthMessageHandler.Handler) -> UIViewController {
        let viewController = DismissReportingViewController()
        
        viewController.dismissHandler = {
            handler(.failure(TrelloError.userCancelled))
        }
        
        let webView = getWebView(handler: handler)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.frame = viewController.view.frame

        viewController.view.addSubview(webView)

        return viewController
    }
    
    /// Get the view controller to present the authentication on
    /// - Parameter context: If a context is given, it will always be the presentation context
    /// - Returns: If no context is given, the root view controller of the first active scene will be used.
    /// If it is already presenting, the presented view controller will be the presentation context
    @MainActor
    private func getPresentationContext(_ context: UIViewController?) -> UIViewController? {
        return if let context {
            context
        } else if let firstRoot = UIApplication.shared.firstKeyWindow?.rootViewController {
            firstRoot.presentedViewController ?? firstRoot
        } else {
            nil
        }
    }
#endif
}
