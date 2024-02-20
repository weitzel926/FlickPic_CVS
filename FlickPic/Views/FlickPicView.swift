//
//  FlickPicView.swift
//  FlickPic
//
//  Created by Wade Weitzel on 2/19/24.
//

import SwiftUI

struct FlickPicView: View {
    @State var photoList: PhotoList
    
    @State private var searchTerm: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("FlickPic")
                    .font(.title2)
                    .fontWeight(.semibold)
                TextEntryBar(placeholderText: "Search for photos", searchTerm: $searchTerm)
                    .onChange(of: searchTerm) {
                        photoList.loadPhotos(key: searchTerm)
                    }
                ZStack {
                    PhotoGridView(photos: photoList.photos)
                    StyledProgressView()
                        .opacity(photoList.inProgress ? 1 : 0)
                }
            }
            .padding()
            .alert(photoList.lastError ?? "", isPresented: $photoList.showError) {
                Button("OK", role: .cancel) {
                    photoList.clearError()
                }
            }
        }
    }
}

struct TextEntryBar: View {
    let placeholderText: String
    @Binding var searchTerm: String
    
    var body: some View {
        TextField(placeholderText, text: $searchTerm)
            .textInputAutocapitalization(.never)
            .textFieldStyle(.roundedBorder)
    }
}

struct StyledProgressView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .strokeBorder(Color.gray, lineWidth: 2)
                .frame(width: 100, height: 100)
            ProgressView()
                .padding(4)
                .controlSize(.large)
        }
    }
}

struct PhotoGridView: View {
    let photos: [Photo]
    
    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 120))
    ]
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(photos, id: \.self) { photo in
                    NavigationLink {
                        DetailView(photo: photo)
                    } label: {
                        AsyncImageCell(url: photo.photoURL)
                    }
                }
            }
        }
    }
}

struct AsyncImageCell: View {
    let url: URL
    
    var body: some View {
        Color.clear
            .aspectRatio(1, contentMode: .fill)
            .overlay(
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle()
                        .fill(.gray)
                        .aspectRatio(1, contentMode: .fill)
                }
            ).cornerRadius(10)
    }
}

#Preview {
    let photoList = PhotoList(manager: PhotoListManager())
    return FlickPicView(photoList: photoList)
}
