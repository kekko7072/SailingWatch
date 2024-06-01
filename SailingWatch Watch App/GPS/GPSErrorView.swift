//
//  GPSErrorView.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 10/09/23.
//

import SwiftUI

struct GPSErrorView: View {
    var errorText: String
    
    var body: some View {
        VStack {
            Image(systemName: "xmark.octagon")
                    .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Text(errorText)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.red)
    }
}

struct GPSErrorView_Previews: PreviewProvider {
    static var previews: some View {
        GPSErrorView(errorText: "PREVIEW ERROR")
    }
}
