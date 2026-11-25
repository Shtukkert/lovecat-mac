import SwiftUI
import AppKit

@main
struct LoveCatApp: App {
    var body: some Scene {
        MenuBarExtra {
            ContentView()
        } label: {
            Image(systemName: "heart.fill")
        }
        .menuBarExtraStyle(.window)
    }
}

struct ContentView: View {
    // 1. УКАЖИ ВАШУ ДАТУ (Год, Месяц, День)
    private let startDateComponents = DateComponents(year: 2025, month: 5, day: 14)
    
    // 2. ПУЛ КОМПЛИМЕНТОВ
    private let compliments = [
        "Ты делаешь каждый мой день намного лучше ❤️",
        "У тебя самая красивая улыбка во всей вселенной",
        "С тобой даже самый обычный вечер становится особенным",
        "Ты невероятно умная, нежная и потрясающая",
        "Я очень горжусь тобой и тем, как ты со всем справляешься",
        "Просто напоминание: я тебя безумно люблю!",
        "Ты моё самое любимое место на земле"
    ]
    
    @State private var currentCompliment: String = ""
    @State private var frameIndex: Int = 0
    @State private var isAnimating: Bool = false
    
    // Таймер для смены кадров (0.16 сек на кадр)
    let timer = Timer.publish(every: 0.16, on: .main, in: .common).autoconnect()
    let totalFrames = 6 // cat_0 ... cat_5
    
    var daysTogether: Int {
        let calendar = Calendar.current
        guard let start = calendar.date(from: startDateComponents) else { return 0 }
        let components = calendar.dateComponents([.day], from: start, to: Date())
        return max(0, components.day ?? 0)
    }
    
    var body: some View {
        VStack(spacing: 14) {
            // Счётчик дней
            VStack(spacing: 2) {
                Text("Мы вместе уже")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(daysTogether) дн.")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.pink)
            }
            
            // Пиксельный котик
            catImage(index: frameIndex)
                .interpolation(.none) // Сохраняет чёткие пиксели без мыла!
                .resizable()
                .scaledToFit()
                .frame(width: 96, height: 96)
                .onTapGesture {
                    triggerKissAnimation()
                }
                .help("Нажми на котика!")
            
            // Карточка с комплиментом
            Text(currentCompliment)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(Color.pink.opacity(0.12))
                .cornerRadius(10)
            
            // Кнопки управления
            HStack {
                Button(action: {
                    pickRandomCompliment()
                    triggerKissAnimation()
                }) {
                    Label("Ещё комплимент", systemImage: "sparkles")
                        .font(.caption)
                }
                .buttonStyle(.borderedProminent)
                .tint(.pink)
                
                Spacer()
                
                Button("Выйти") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.plain)
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .frame(width: 260)
        .onAppear {
            pickRandomCompliment()
            triggerKissAnimation()
        }
        .onReceive(timer) { _ in
            guard isAnimating else { return }
            if frameIndex < totalFrames - 1 {
                frameIndex += 1
            } else {
                frameIndex = 0
                isAnimating = false
            }
        }
    }
    
    private func pickRandomCompliment() {
        let filtered = compliments.filter { $0 != currentCompliment }
        currentCompliment = filtered.randomElement() ?? compliments.first ?? ""
    }
    
    private func triggerKissAnimation() {
        frameIndex = 1
        isAnimating = true
    }
    
    // Загрузка картинки из бандла ресурсов Swift Package
    private func catImage(index: Int) -> Image {
        if let url = Bundle.module.url(forResource: "cat_\(index)", withExtension: "png"),
           let nsImage = NSImage(contentsOf: url) {
            return Image(nsImage: nsImage)
        }
        return Image(systemName: "cat.fill") // Запасная иконка, если картинка не найдена
    }
}