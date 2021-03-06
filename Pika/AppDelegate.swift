import Cocoa
import Defaults
import KeyboardShortcuts
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var pikaWindow: NSWindow!
    var splashWindow: NSWindow!
    var aboutWindow: NSWindow!
    var preferencesWindow: NSWindow!

    func applicationDidFinishLaunching(_: Notification) {
        // Create the status item
        statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))

        if let button = statusBarItem.button {
            button.image = NSImage(named: "StatusBarIcon")
            button.action = #selector(togglePopover(_:))
        }

        // Define content view
        let contentView = ContentView()
            .frame(minWidth: 380,
                   idealWidth: 380,
                   maxWidth: 500,
                   minHeight: 150,
                   idealHeight: 180,
                   maxHeight: 350,
                   alignment: .center)

        pikaWindow = PikaWindow.createPrimaryWindow()
        pikaWindow.contentView = NSHostingView(rootView: contentView)

        // Define global keyboard shortcuts
        KeyboardShortcuts.onKeyUp(for: .togglePika) { [self] in
            if Defaults[.viewedSplash] {
                togglePopover(nil)
            }
        }

        // Open splash window, or main
        if !Defaults[.viewedSplash] {
            openSplashWindow(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    func applicationShouldHandleReopen(_: NSApplication, hasVisibleWindows: Bool) -> Bool {
        if !hasVisibleWindows {
            pikaWindow.makeKeyAndOrderFront(self)
        }
        return true
    }

    func startMainWindow() {
        if !pikaWindow.isVisible {
            pikaWindow.fadeIn(nil)
        }
        Defaults[.viewedSplash] = true
    }

    func showMainWindow() {
        pikaWindow.makeKeyAndOrderFront(nil)
    }

    func hideMainWindow() {
        pikaWindow.orderOut(nil)
    }

    @objc func closeSplashWindow() {
        splashWindow.fadeOut(sender: nil, duration: 0.25, closeSelector: .close, completionHandler: startMainWindow)
    }

    @objc func togglePopover(_: AnyObject?) {
        if pikaWindow.isVisible {
            hideMainWindow()
        } else {
            showMainWindow()
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    @IBAction func openAboutWindow(_: Any?) {
        if aboutWindow == nil {
            aboutWindow = PikaWindow.createSecondaryWindow(
                title: "About",
                size: NSRect(x: 0, y: 0, width: 300, height: 380),
                styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView]
            )
            aboutWindow.contentView = NSHostingView(rootView: AboutView())
        }
        aboutWindow.makeKeyAndOrderFront(nil)
    }

    @IBAction func openPreferencesWindow(_: Any?) {
        if preferencesWindow == nil {
            preferencesWindow = PikaWindow.createSecondaryWindow(
                title: "Preferences",
                size: NSRect(x: 0, y: 0, width: 550, height: 380),
                styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView]
            )
            preferencesWindow.contentView = NSHostingView(rootView: PreferencesView())
        }
        preferencesWindow.makeKeyAndOrderFront(nil)
    }

    @IBAction func openSplashWindow(_: Any?) {
        if splashWindow == nil {
            splashWindow = PikaWindow.createSecondaryWindow(
                title: "Splash",
                size: NSRect(x: 0, y: 0, width: 600, height: 260),
                styleMask: [.titled, .fullSizeContentView]
            )
            if #available(OSX 11.0, *) {
                splashWindow.titleVisibility = .visible
                splashWindow.title = "Pika"
            }
            splashWindow.contentView = NSHostingView(rootView: SplashView().edgesIgnoringSafeArea(.all))
        }
        splashWindow.fadeIn(nil)
    }
}
