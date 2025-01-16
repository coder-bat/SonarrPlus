import SwiftUI

struct StatsDashboardView: View {
    @StateObject private var viewModel = SonarrPlusViewModel.shared

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if let stats = viewModel.stats {
                        Spacer()
                        ScrollView {
                            VStack(spacing: 20) {
                                StatsCardView(
                                    iconName: "tv",
                                    title: "Total Shows",
                                    value: "\(stats.totalShows ?? 0)"
                                )

                                StatsCardView(
                                    iconName: "externaldrive.fill",
                                    title: "Disk Space Used",
                                    value: "\(String(format: "%.2f", stats.diskSpaceUsed ?? 0.0)) GB"
                                )

                                StatsCardView(
                                    iconName: "internaldrive.fill",
                                    title: "Disk Space Free",
                                    value: "\(String(format: "%.2f", stats.diskSpaceFree ?? 0.0)) GB"
                                )
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        ProgressView("Loading stats...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    }
                }
                .navigationTitle("Server Stats")
                .onAppear {
                    Task {
                        await viewModel.fetchStats()
                    }
                }
            }
        }
    }
}

struct StatsCardView: View {
    let iconName: String
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .center) {
            SwiftUI.Image(systemName: iconName)
                .font(.title)
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
                .background(Color.blue.opacity(0.2))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.title3)
                    .bold()
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}

struct StatsDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        StatsDashboardView()
    }
}
