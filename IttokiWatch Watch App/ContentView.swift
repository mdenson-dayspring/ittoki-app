import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = SolarTimeViewModel()
    var body: some View {
        switch viewModel.authorizationStatus {
        case .notDetermined:
            AnyView(RequestLocationView())
                    .environmentObject(viewModel)
        case .restricted:
            ErrorView(errorText: "Location use is restricted.")
        case .denied:
            ErrorView(errorText: "The app does not have location permissions. Please enable them in settings.")
        case .authorizedAlways, .authorizedWhenInUse:
            TimeView()
                    .environmentObject(viewModel)
        default:
            Text("Unexpected status")
        }
    }
}

struct RequestLocationView: View {
    @EnvironmentObject var viewModel: SolarTimeViewModel

    var body: some View {
        VStack {
            Image(systemName: "location.circle")
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            Button(action: {
                viewModel.requestPermission()
            }, label: {
                Label("Allow tracking", systemImage: "location")
            })
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            Text("In order to find sunrise/sunset times\nwe need permission to get your location.")
                    .foregroundColor(.gray)
                    .font(.caption)
        }
    }
}

struct ErrorView: View {
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

struct TimeView: View {
    @EnvironmentObject var viewModel: SolarTimeViewModel

    var body: some View {
        VStack {
            if let curr = viewModel.current {
                ZStack {
                    CircularProgressView(value: Double(curr.partial), total: 1000, strokeColor: Color(hex: "F1D6AF"))
                    Text("\(curr.toki)\n\(curr.zodiacChar)")
                            .font(.largeTitle)
                }
                        .padding(10)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
