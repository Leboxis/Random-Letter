import SwiftUI

struct CategoryIdeasView: View {
    @Environment(\.dismiss) private var dismiss

    private let categories: [CategoryIdea] = [
        .init(title: "Prénom fille", icon: "person.fill", color: .pink),
        .init(title: "Prénom garçon", icon: "person.fill", color: .blue),
        .init(title: "Fruits et légumes", icon: "carrot.fill", color: .orange),
        .init(title: "Pays / ville", icon: "globe.europe.africa.fill", color: .indigo),
        .init(title: "Fleurs", icon: "camera.macro", color: .purple),
        .init(title: "Marques", icon: "tag.fill", color: .red),
        .init(title: "Célébrités", icon: "star.fill", color: .yellow),
        .init(title: "Personnages fictifs", icon: "theatermasks.fill", color: .mint),
        .init(title: "Films / séries", icon: "film.fill", color: .teal),
        .init(title: "Parties du corps humain", icon: "figure.stand", color: .cyan),
        .init(title: "Métiers", icon: "briefcase.fill", color: .brown)
    ]

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Idées de colonnes")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))

                    Text("Choisis celles qui vous inspirent pour votre feuille de petit bac.")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)

                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(categories) { category in
                            categoryCard(category)
                        }
                    }
                    .padding(.top, 12)
                }
                .padding(20)
            }
            .navigationTitle("Catégories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func categoryCard(_ category: CategoryIdea) -> some View {
        VStack(spacing: 14) {
            Image(systemName: category.icon)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(category.color)
                .frame(width: 46, height: 46)
                .background(Circle().fill(category.color.opacity(0.14)))
                .frame(maxWidth: .infinity)

            Text(category.title)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, minHeight: 132)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
    }
}

private struct CategoryIdea: Identifiable {
    let title: String
    let icon: String
    let color: Color

    var id: String { title }
}
