import SwiftUI

struct WelcomeView: View {
    var onContinue: () -> Void

    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [.navyBlue, .black, .black]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(15)
                    .padding()
                
                VStack {
                    Text("Welcome to \n Flight Log Scan")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary.opacity(0.75))
                        .multilineTextAlignment(.center)
                }
                
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Image(systemName: "doc.viewfinder.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                            .foregroundStyle(.white)

                        Text("Digitize your handwritten flight logs with a simple scan")
                            .fixedSize(horizontal: false , vertical: true)
                            .fontWeight(.light)
                            .padding(.leading)
                    }
                    .padding(.top)

                    HStack(alignment: .center) {
                        Image(systemName: "square.and.arrow.up.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                            .foregroundStyle(.white)

                        Text("Export your logs anytime as CSV files")
                            .fixedSize(horizontal: false , vertical: true)
                            .fontWeight(.light)
                            .padding(.leading)
                    }
                    .padding(.top)
                }
                .font(.headline)

                Spacer()
                Spacer()
                Spacer()
                Spacer()

                Text("Flight Log Scan processes images of your handwritten flight logs to extract and digitize the data for your personal records. Handwriting recognition is used solely for this purpose.  [See how your data is managed...](https://www.flightlogscan.com/privacy)")
                    .foregroundStyle(.secondary)
                    .tint(.accentColor)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)

                HStack {
                    Button(action: onContinue) {
                        Text("Continue")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }
                }
                Spacer()
            }
            .padding()
            .padding([.leading, .trailing])
            .padding([.leading, .trailing])

        }
    }
}

#Preview {
    WelcomeView(onContinue: {})
}
