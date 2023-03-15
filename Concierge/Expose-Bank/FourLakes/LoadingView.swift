//
//  LoadingView.swift
//  FourLakes
//
//  Created by Michael Hollis on 2023-03-14.
//

import SwiftUI

struct LoadingView: View {
    @State var isShowing: Bool
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Loading...")
                ActivityIndicator(isAnimating: $isShowing, style: .large)
            }.frame(width: geometry.size.width / 2,
                    height: geometry.size.height / 5)
            .background(Color.secondary.colorInvert()).cornerRadius(20).foregroundColor(Color.primary)
        }

    }
}

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isShowing: true)
    }
}
