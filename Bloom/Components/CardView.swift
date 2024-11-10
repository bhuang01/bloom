//
//  CardView.swift
//  Bloom
//
//  Created by vzhu on 11/10/24.
//

import SwiftUI

struct CardView: View {
    let post: Post
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(post.title)
                .font(.headline)
            
            if isExpanded {
                Text(post.fullDescription)
                    .font(.body)
            } else {
                Text(post.briefDescription)
                    .font(.subheadline)
                    .lineLimit(3)
            }
            
            Button(action: {
                isExpanded.toggle()
            }) {
                Text(isExpanded ? "Show Less" : "Read More")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            if isExpanded {
                NavigationLink(destination: DetailView(post: post)) {
                    Text("Go to Detail")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(post: Post(
            title: "Sample Post",
            briefDescription: "This is a brief description of the sample post for preview.",
            fullDescription: "This is the full content of the sample post, used to showcase the preview of the CardView in SwiftUI."
        ))
    }
}

