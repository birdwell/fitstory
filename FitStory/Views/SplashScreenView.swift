import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()

            VStack {
                Text("FitStory")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }
}
