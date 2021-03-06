import Defaults
import KeyboardShortcuts
import LaunchAtLogin
import SwiftUI

struct PreferencesView: View {
    @Default(.colorFormat) var colorFormat

    var body: some View {
        HStack(spacing: 0) {
            Group {
                AppVersion()
            }
            .frame(maxWidth: 180.0, maxHeight: .infinity)
            .background(VisualEffect(
                material: NSVisualEffectView.Material.sidebar,
                blendingMode: NSVisualEffectView.BlendingMode.behindWindow
            ))

            Divider()

            VStack(alignment: .leading, spacing: 10.0) {
                // Colour Format
                Section(header: Text("Colour Format").font(.system(size: 16))) {
                    VStack(alignment: .leading, spacing: 15.0) {
                        Text("Set your preferred display format for colors.")
                        Picker("Colour Format", selection: $colorFormat) {
                            ForEach(ColorFormatKeys.allCases, id: \.self) { value in
                                Text(value.rawValue)
                            }
                        }
                        .pickerStyle(RadioGroupPickerStyle())
                        .horizontalRadioGroupLayout()
                        .labelsHidden()
                    }
                }
                .padding(.horizontal, 24.0)

                Divider()
                    .padding(.vertical, 10.0)

                // Global Shortcut
                Section(header: Text("Global Shortcut").font(.system(size: 16))) {
                    VStack(alignment: .leading, spacing: 15.0) {
                        Text("Set a global hot key shortcut to invoke Pika.")
                        KeyboardShortcuts.Recorder(for: .togglePika)
                    }
                }
                .padding(.horizontal, 24.0)

                Divider()
                    .padding(.vertical, 10.0)

                // Launch at login
                Section(header: Text("Startup Settings").font(.system(size: 16))) {
                    LaunchAtLogin.Toggle {
                        Text("Launch at login")
                    }
                }
                .padding(.horizontal, 24.0)
            }
            .padding(.all, 0.0)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
