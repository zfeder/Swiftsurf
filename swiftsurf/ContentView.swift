//
//  ContentView.swift
//  Navigator
//
//  Created by Federico Filì on 12/07/24.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State private var urlString: String = "https://www.google.it"
    @StateObject private var webViewStore = WebViewStore()
    @AppStorage("homePage") private var homePage: String = "https://www.google.it"

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        goBack()
                    }) {
                        Image(systemName: "arrow.left")
                    }
                    .padding(.leading, 8)

                    Button(action: {
                        goHome()
                    }) {
                        Image(systemName: "house")
                    }
                    .padding(.leading, 8)

                    TextField("Enter URL", text: $urlString, onCommit: {
                        loadURL()
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity)
                    .padding([.leading, .trailing], 8)

                    Button(action: {
                        reloadPage()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .padding(.trailing, 8)

                    Button(action: {
                        setHomePage()
                    }) {
                        Image(systemName: "star")
                    }
                    .padding(.trailing, 8)
                }
                .frame(height: 40)
                .padding([.top, .leading, .trailing])

                WebView(webView: webViewStore.webView)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .onAppear {
                loadURL(urlString: homePage)
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ResizableHandle()
                        .frame(width: 20, height: 20)
                        .background(Color.clear)
                        .padding(5)
                }
            }
        }
    }

    func loadURL(urlString: String? = nil) {
        if let urlString = urlString, let url = URL(string: urlString) {
            webViewStore.loadUrl(url)
        } else if let url = URL(string: self.urlString) {
            webViewStore.loadUrl(url)
        }
    }

    func reloadPage() {
        webViewStore.webView.reload()
    }

    func goBack() {
        if webViewStore.webView.canGoBack {
            webViewStore.webView.goBack()
        }
    }

    func goHome() {
        loadURL(urlString: homePage)
    }

    func setHomePage() {
        homePage = webViewStore.webView.url?.absoluteString ?? homePage
    }
}

struct WebView: NSViewRepresentable {
    let webView: WKWebView

    func makeNSView(context: Context) -> WKWebView {
        webView.autoresizingMask = [.width, .height]
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {}
}

class WebViewStore: ObservableObject {
    @Published var webView: WKWebView

    init() {
        let config = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: config)
        self.webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Safari/605.1.15"
        self.webView.configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
    }

    func loadUrl(_ url: URL) {
        webView.load(URLRequest(url: url))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
