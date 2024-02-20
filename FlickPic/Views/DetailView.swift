//
//  DetailView.swift
//  FlickPic
//
//  Created by Wade Weitzel on 2/19/24.
//

import SwiftUI
import WebKit

struct DetailView: View {
    let photo: Photo
    
    var body: some View {
        VStack(spacing: 20) {
            Text(photo.title)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .font(.title)
            
            AsyncImage(url: photo.photoURL)
            NameValueLabel(name: "Author:", value: photo.author)
            NameValueLabel(name: "Date Taken:", value: "\(photo.dateTakenString)")
            Divider()
            Color.clear
                .overlay() {
                    WebView(html: photo.description)
                }
        }
        .padding()
    }
}

struct HeadlineImage: View {
    let url: URL
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 250, maxHeight: 250)
        } placeholder: {
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray)
                .frame(maxWidth: 250, maxHeight: 250)
        }
        .transaction { transaction in
            transaction.animation = .spring()
        }
    }
}

struct NameValueLabel: View {
    let name: String
    let value: String
    
    var body: some View {
        HStack {
            Text(name)
                .fontWeight(.bold)
            Text(value)
                .multilineTextAlignment(.center)
        }
    }
}

struct WebView: UIViewRepresentable {
    let html: String
    
    func makeUIView(context: Context) -> WKWebView  {
        let webView = WKWebView()
        webView.loadHTMLString(html, baseURL: nil)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

#Preview {
    guard let link = URL(string: "https://picsum.photos/300/200"),
          let mediaLink = URL(string: "https://picsum.photos/300/200"),
          let dateTaken = Date.createDate(month: 12, day: 25, year: 2023) else {
        fatalError("Could not create URLs, should never happen")
    }
    
    let photo = Photo.fixture(link: link, mediaLink: mediaLink, dateTaken: dateTaken)
    return DetailView(photo: photo)
}

