//
//  GPSRequestView.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 10/09/23.
//

import SwiftUI

struct GPSRequestView: View {
    @EnvironmentObject var locationViewModel: LocationManager
    
    var body: some View {
        VStack {
            Image(systemName: "location.circle")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(.blue)
            Button(action: {
                locationViewModel.liveLocation = locationViewModel.getCurrentLocation()
            }, label: {
                Label("Allow tracking", systemImage: "location")
            })
            .padding(10)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8)).tint(.blue)
        }.toolbar {
            /*ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button {
                   //
                } label: {
                    Label("UP", systemImage: "arrow.up.arrow.down")
                }
            }*/
        }
    }
}

struct GPSRequestView_Previews: PreviewProvider {
    static var previews: some View {
        GPSRequestView().environmentObject(LocationManager())
    }
}
