public class ediarylib {
  public static let shared = ediarylib()
  private var initialized: Bool = false
  private var callback: (() -> FposCredential)?

  private init() {
  }

  private func initialize() {
    guard !initialized else { return }
    initialized = true

    BleConnector.shared.launch()
    BleConnector.shared.addBleHandleDelegate(String(obj: self), self)
  }

  public func newWebInterface() -> WebInterface {
    initialize()
    return WebInterface()
  }

  public func attach(callback: @escaping () -> FposCredential) {
    // callbackを登録
    self.callback = callback
  }

  public func detach() {
    // calbackを解除
    self.callback = nil
  }
}

extension ediarylib: BleHandleDelegate {
  func onIdentityCreate(_ status: Bool, _ deviceInfo: BleDeviceInfo?) {
    // サンプルコードから移植
    if status {
      _ = BleConnector.shared.sendData(.PAIR, .UPDATE)
    }
  }

  public func onSessionStateChange(_ status: Bool) {
    // サンプルコードから移植
    if status {
      _ = BleConnector.shared.sendObject(BleKey.TIME_ZONE, BleKeyFlag.UPDATE, BleTimeZone())
      _ = BleConnector.shared.sendObject(BleKey.TIME, BleKeyFlag.UPDATE, BleTime.local())
      _ = BleConnector.shared.sendData(BleKey.POWER, BleKeyFlag.READ)
      _ = BleConnector.shared.sendData(BleKey.FIRMWARE_VERSION, BleKeyFlag.READ)
    }
  }
}
