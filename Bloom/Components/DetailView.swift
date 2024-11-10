//
//  DetailView.swift
//  Bloom
//
//  Created by vzhu on 11/10/24.
//

import SwiftUI

struct DetailView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(post.title)
                .font(.largeTitle)
                .padding(.bottom)
            
            Text(post.fullDescription)
                .font(.body)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Detail")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailView(post: Post(
                title: "Sample Post",
                briefDescription: "This is a brief description of the sample post for preview.",
                fullDescription: "This is the full content of the sample post, used to showcase the preview of the DetailView in SwiftUI."
            ))
        }
    }
}

