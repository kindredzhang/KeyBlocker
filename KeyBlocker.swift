import Foundation
import AppKit
import Quartz
import IOKit.hid

private var _isInternalKeyPressed = false
private var _globalIsBlocked = false

class KeyBlockerDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var hidManager: IOHIDManager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        setupHIDManager()
        setupEventTap()
        
        // 使用系统标准的长度，而不是 variableLength 可能会改善间距
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem?.button {
            let config = NSImage.SymbolConfiguration(pointSize: 14, weight: .regular)
            let image = NSImage(systemSymbolName: "keyboard", accessibilityDescription: nil)?
                .withSymbolConfiguration(config)
            image?.isTemplate = true // 必须设置为 true 以适配系统 UI
            button.image = image
        }
        
        setupMenu()
        print(">>> Minimalist Stable KeyBlocker Started")
    }

    // HID 识别：只识别，不操作
    func setupHIDManager() {
        hidManager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
        let matchingDict = [kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop, kIOHIDDeviceUsageKey: kHIDUsage_GD_Keyboard] as CFDictionary
        IOHIDManagerSetDeviceMatching(hidManager!, matchingDict)
        
        IOHIDManagerRegisterInputValueCallback(hidManager!, { (context, result, sender, value) in
            guard let sender = sender else { return }
            let device = Unmanaged<IOHIDDevice>.fromOpaque(sender).takeUnretainedValue()
            let name = (IOHIDDeviceGetProperty(device, kIOHIDProductKey as CFString) as? String) ?? ""
            let transport = (IOHIDDeviceGetProperty(device, kIOHIDTransportKey as CFString) as? String) ?? ""
            _isInternalKeyPressed = (transport == "Internal" || name.contains("Apple Internal"))
        }, nil)
        
        IOHIDManagerScheduleWithRunLoop(hidManager!, CFRunLoopGetCurrent(), CFRunLoopMode.commonModes.rawValue)
        IOHIDManagerOpen(hidManager!, IOOptionBits(kIOHIDOptionsTypeNone))
    }

    // Event Tap 拦截：逻辑精简到极致
    func setupEventTap() {
        let mask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.flagsChanged.rawValue)
        
        guard let tap = CGEvent.tapCreate(tap: .cgSessionEventTap, 
                                          place: .headInsertEventTap, 
                                          options: .defaultTap, 
                                          eventsOfInterest: CGEventMask(mask), 
                                          callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
            
            // 快捷键 Toggle: Cmd + Opt + Ctrl + B
            let flags = event.flags
            if flags.contains([.maskCommand, .maskAlternate, .maskControl]) {
                let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
                if keyCode == 11 { // 'B'
                    _globalIsBlocked = !_globalIsBlocked
                    if let refcon = refcon {
                        let delegate = Unmanaged<KeyBlockerDelegate>.fromOpaque(refcon).takeUnretainedValue()
                        DispatchQueue.main.async { delegate.setupMenu() }
                    }
                    return Unmanaged.passUnretained(event)
                }
            }

            if _globalIsBlocked && _isInternalKeyPressed {
                return nil
            }
            return Unmanaged.passUnretained(event)
        }, userInfo: Unmanaged.passUnretained(self).toOpaque()) else { return }
        
        let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)
    }

    func setupMenu() {
        let menu = NSMenu()
        let statusTitle = _globalIsBlocked ? "Status: BLOCKING 🚫" : "Status: ACTIVE ✅"
        menu.addItem(NSMenuItem(title: statusTitle, action: nil, keyEquivalent: ""))
        
        menu.addItem(NSMenuItem.separator())
        
        let toggleItem = NSMenuItem(title: _globalIsBlocked ? "Enable Internal Keyboard" : "Disable Internal Keyboard", action: #selector(toggle), keyEquivalent: "d")
        toggleItem.target = self
        menu.addItem(toggleItem)
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        self.statusItem?.menu = menu
    }

    @objc func toggle() {
        _globalIsBlocked = !_globalIsBlocked
        setupMenu()
    }
}

let app = NSApplication.shared
let delegate = KeyBlockerDelegate()
app.delegate = delegate
app.run()
