//
//  TTProgressHUD.swift
//  TTProgressHUD
//
//  Created by Tobias Tiemerding on 29.07.20.
//

import SwiftUI
import SwiftUIVisualEffects

public enum TTProgressHUDType {
    case loading
    case success
    case warning
    case error
}

private struct IndefiniteAnimatedView: View {
    var animatedViewSize: CGSize
    var animatedViewForegroundColor: Color
    
    var lineWidth: CGFloat
    
    @State private var isAnimating = false
    
    private var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        let gradient = Gradient(colors: [animatedViewForegroundColor, .clear])
        let radGradient = AngularGradient(gradient: gradient, center: .center, angle: .degrees(-5))
        
        Circle()
            .trim(from: 0.0, to: 0.97)
            .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .fill(radGradient)
            .frame(width: animatedViewSize.width-lineWidth/2, height: animatedViewSize.height-lineWidth/2)
            .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
            .animation(self.isAnimating ? foreverAnimation : .default)
            .padding(lineWidth/2)
            .onAppear {
                self.isAnimating = true
            }
            .onDisappear {
                self.isAnimating = false
            }
    }
}

private struct ImageView: View {
    var type: TTProgressHUDType
    
    var imageViewSize: CGSize
    var imageViewForegroundColor: Color
    
    var successImage: String
    var warningImage: String
    var errorImage: String
    
    var body: some View {
        imageForHUDType?
            .resizable()
            .frame(width: imageViewSize.width, height: imageViewSize.height)
            .foregroundColor(imageViewForegroundColor.opacity(0.8))
    }
    
    var imageForHUDType: Image? {
        switch type {
        case .success:
            return Image(systemName: successImage)
        case .warning:
            return Image(systemName: warningImage)
        case .error:
            return Image(systemName: errorImage)
        default:
            return nil
        }
    }
}

private struct LabelView: View {
    var title: String?
    var caption: String?
    
    var body: some View {
        VStack(spacing: 4) {
            if let title = title {
                Text(title)
                    .font(.system(size: 21.0, weight: .semibold))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .foregroundColor(.primary)
            }
            if let caption = caption {
                Text(caption)
                    .font(.headline)
                    .lineLimit(2)
                    .fixedSize(horizontal: true, vertical: false)
                    .foregroundColor(.secondary)
            }
        }
        .multilineTextAlignment(.center)
        .vibrancyEffect()
        .vibrancyEffectStyle(.fill)
    }
}

public struct TTProgressHUD: View {
    @Binding var isVisible: Bool
    var config: TTProgressHUDConfig
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(_ isVisible: Binding<Bool>, config: TTProgressHUDConfig) {
        self._isVisible = isVisible
        self.config = config
    }
    
    public init(
        _ isVisible: Binding<Bool>,
        title: String?          = nil,
        caption: String?        = nil,
        type: TTProgressHUDType = .loading
    ) {
        self._isVisible = isVisible
        self.config = TTProgressHUDConfig(
            type: type,
            title: title,
            caption: caption
        )
    }
    
    public var body: some View {
        let hideTimer = Timer.publish(every: config.autoHideInterval, on: .main, in: .common).autoconnect()
        
        GeometryReader { geometry in
            ZStack {
                if isVisible {
                    config.backgroundColor
                        .edgesIgnoringSafeArea(.all)
                    
                    ZStack {
                        Color.white
                            .blurEffect()
                            .blurEffectStyle(.systemChromeMaterial)
                        
                        VStack(spacing: 20) {
                            if config.type == .loading {
                                IndefiniteAnimatedView(
                                    animatedViewSize: config.imageViewSize,
                                    animatedViewForegroundColor: config.imageViewForegroundColor,
                                    lineWidth: config.lineWidth
                                )
                            } else {
                                ImageView(
                                    type: config.type,
                                    imageViewSize: config.imageViewSize,
                                    imageViewForegroundColor: config.imageViewForegroundColor,
                                    successImage: config.successImage,
                                    warningImage: config.warningImage,
                                    errorImage: config.errorImage
                                )
                            }
                            LabelView(title: config.title, caption: config.caption)
                        }.padding()
                    }
                    .cornerRadius(config.cornerRadius)
                    .overlay(
                        // Fix required since .border can not be used with
                        // RoundedRectangle clip shape
                        RoundedRectangle(cornerRadius: config.cornerRadius)
                            .stroke(config.borderColor, lineWidth: config.borderWidth)
                    )
                    .aspectRatio(1, contentMode: .fit)
                    .padding(geometry.size.width / 7)
                    .shadow(color: config.shadowColor, radius: config.shadowRadius)
                }
            }
            .animation(.spring())
            .onTapGesture {
                if config.allowsTapToHide {
                    withAnimation {
                        isVisible = false
                    }
                }
            }
            .onReceive(hideTimer) { _ in
                if config.shouldAutoHide {
                    withAnimation {
                        isVisible = false
                    }
                }
                // Only one call required
                hideTimer.upstream.connect().cancel()
            }
            .onAppear {
                if config.hapticsEnabled {
                    generateHapticNotification(for: config.type)
                }
            }
        }
    }
    
    func generateHapticNotification(for type: TTProgressHUDType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        
        switch type {
        case .success:
            generator.notificationOccurred(.success)
        case .warning:
            generator.notificationOccurred(.warning)
        case .error:
            generator.notificationOccurred(.error)
        default:
            return
        }
    }
}
