import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to FitStory!")
                .font(.title)
                .padding()
            Text("This is the Home screen.")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
