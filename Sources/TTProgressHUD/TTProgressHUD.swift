//
//  ContentView.swift
//  TTProgressHUD
//
//  Created by Tobias Tiemerding on 29.07.20.
//

import SwiftUI
import SwiftUIVisualEffects

public enum TTProgressHUDType {
    case Loading
    case Success
    case Warning
    case Error
}

struct IndefiniteAnimatedView: View {
    var animatedViewSize: CGSize
    var animatedViewForegroundColor:Color
    
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
            .onAppear { self.isAnimating = true }
            .onDisappear { self.isAnimating = false }
    }
}

struct ImageView: View {
    var type: TTProgressHUDType
    
    var imageViewSize:CGSize
    var imageViewForegroundColor:Color
    
    var successImage: String
    var warningImage: String
    var errorImage: String

    var body: some View {
        imageForHUDType()!
            .resizable()
            .frame(width: imageViewSize.width, height: imageViewSize.height)
            .foregroundColor(imageViewForegroundColor.opacity(0.8))
    }
    
    func imageForHUDType() -> Image? {
        switch type {
        case .Success:
            return Image(systemName: successImage)
        case .Warning:
            return Image(systemName: warningImage)
        case .Error:
            return Image(systemName: errorImage)
        default:
            return nil
        }
    }
}

struct LabelView: View {
    var title:String?
    var caption:String?
    
    var body: some View {
        VStack(spacing: 4) {
            if let title = title {
                Text(title)
                    .font(.system(size: 21.0, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .foregroundColor(.primary)
            }
            if let caption = caption {
                Text(caption)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
        .vibrancyEffect()
        .vibrancyEffectStyle(.fill)
    }
}

public struct TTProgressHUD: View {
    @Binding var isVisible: Bool
    var config: TTProgressHUDConfig
    
    @Environment(\.colorScheme) var colorScheme
    
    public init(_ isVisible:Binding<Bool>, config: TTProgressHUDConfig){
        self._isVisible = isVisible
        self.config = config
    }
    
    public var body: some View {
        let hideTimer = Timer.publish(every: config.autoHideInterval, on: .main, in: .common).autoconnect()
        
        GeometryReader { geometry in
            ZStack{
                if isVisible {
                    config.backgroundColor
                        .edgesIgnoringSafeArea(.all)
                    
                    ZStack {
                        Color.white
                            .blurEffect()
                            .blurEffectStyle(.systemChromeMaterial)
                        
                        VStack(spacing: 20) {
                            if config.type == .Loading {
                                IndefiniteAnimatedView(animatedViewSize: config.imageViewSize,
                                                       animatedViewForegroundColor: config.imageViewForegroundColor,
                                                       lineWidth: config.lineWidth)
                            } else {
                                ImageView(type: config.type,
                                          imageViewSize: config.imageViewSize,
                                          imageViewForegroundColor: config.imageViewForegroundColor,
                                          successImage: config.successImage,
                                          warningImage: config.warningImage,
                                          errorImage: config.errorImage)
                            }
                            LabelView(title: config.title, caption: config.caption)
                        }.padding()
                    }
                    .overlay(
                        // Fix reqired since .border can not be used with
                        // RoundedRectangle clip shape
                        RoundedRectangle(cornerRadius: config.cornerRadius)
                            .stroke(config.borderColor, lineWidth: config.borderWidth)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
                    .aspectRatio(1, contentMode: .fit)
                    .padding(geometry.size.width / 7)
                    .shadow(color: config.shadowColor, radius: config.shadowRadius)
                }
                
            }
            .animation(.spring())
            .onTapGesture {
                if config.allowTapToHide {
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
            .onAppear(){
                if config.hapticsEnabled {
                    generateHapticNotification(for: .Success)
                }
            }
        }
    }
    
    func generateHapticNotification(for type: TTProgressHUDType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        
        switch type {
        case .Success:
            generator.notificationOccurred(.success)
        case .Warning:
            generator.notificationOccurred(.warning)
        case .Error:
            generator.notificationOccurred(.error)
        default:
            return
        }
    }
}
