//
//  InputView.swift
//  Bloom
//
//  Created by vzhu on 11/10/24.
//

import SwiftUI

struct InputView: View {
    @Binding var ext: String
    let title: String
    let placeholder: String
    var isSecurefield = false
    
    var body: some View {
        VStack {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            if isSecurefield {
                SecureField(placeholder, text: $ext)
                    .font(.system(size: 14))
            } else {
                TextField(placeholder, text: $ext)
                    .font(.system(size: 14))
            }
            
            Divider()
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(ext: .constant(""), title: "Email Address", placeholder: "name@example.com")
    }
}
