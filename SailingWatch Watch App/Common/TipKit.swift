//
//  TipKit.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 12/06/24.
//

import TipKit

struct TipSetPointAB: Tip {
    
    var title: Text {
        Text("Set point of line")
    }
    
    
    var message: Text? {
        Text("Press the buttons of boat and flag to set line position.")
    }
}

struct TipSetLine: Tip {
    var title: Text {
        Text("Ready? Get line data")
    }
    
    
    var message: Text? {
        Text("Press the button LINE to start getting the data from the setted line.")
    }
}

struct MyTipStyle: TipViewStyle {
    @State var showAlert = false
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if let title = configuration.title {
                title
                    .bold()
                    .font(.headline)
                    .onTapGesture {
                        showAlert = true
                    }
            }
            Image(systemName: "multiply")
                .onTapGesture {
                    configuration.tip.invalidate(reason: .actionPerformed)
                }
            
        }.foregroundStyle(.white)
            .backgroundStyle(.yellow)
            .padding().alert(isPresented: $showAlert, content: {
                Alert(
                    title: configuration.title!,
                    message: configuration.message!,
                    dismissButton: .default(Text("OK"), action: {
                        configuration.tip.invalidate(reason: .actionPerformed)
                    })
                )
            })
    }
}

