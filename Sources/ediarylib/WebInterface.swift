import WebKit

public class WebInterface: NSObject {
  private weak var webView: WKWebView?
  private var bluetoothEnabled = false
  private var scanner: BleScanner?
  private var devices = [BleDevice]()

  public func attach(webView: WKWebView) {
    let controller = webView.configuration.userContentController
    controller.add(self, name: "ediarylibDebug")
    controller.add(self, name: "search")
    controller.add(self, name: "requestPairing")
    controller.add(self, name: "requestUnpair")
    controller.add(self, name: "startCamera")

    webView.navigationDelegate = self
    webView.uiDelegate = self

    // UAを設定する
    webView.evaluateJavaScript("navigator.userAgent") { result, error in
      guard let userAgent = result as? String else { return }
      webView.customUserAgent = "iOSApp/eDiary/0.7 " + userAgent
    }

    self.webView = webView

    let scanner = BleScanner()
    scanner.mBleScanDelegate = self
    scanner.mBleScanFilter = self

    self.scanner = scanner
  }

  public func detach() {
    guard let webView = webView else { return }

    let controller = webView.configuration.userContentController
    controller.removeScriptMessageHandler(forName: "ediarylibDebug")
    controller.removeScriptMessageHandler(forName: "search")
    controller.removeScriptMessageHandler(forName: "requestPairing")
    controller.removeScriptMessageHandler(forName: "requestUnpair")
    controller.removeScriptMessageHandler(forName: "startCamera")

    webView.navigationDelegate = nil
    webView.uiDelegate = nil

    self.webView = nil
  }

  private func debug(_ payload: Any?) -> Any {
    return ["sdkVersion": "20221227", "libVersion": "0.7", "payload": payload]
  }

  private func encodeJavaScript(_ source: Any) -> String? {
    guard let resultData = try? JSONSerialization.data(withJSONObject: source),
      let resultString = String(data: resultData, encoding: .utf8)
    else { return nil }
    return
      resultString
      .replacingOccurrences(of: "\u{007F}", with: "\\u007F")
      .replacingOccurrences(of: "\u{2028}", with: "\\u2028")
      .replacingOccurrences(of: "\u{2029}", with: "\\u2029")
  }

  private func search() {
    if bluetoothEnabled,
      let scanner = scanner
    {
      scanner.scan(!scanner.isScanning)
    }
  }

  private func requestPairing(_ identifier: String) {
    let connector = BleConnector.shared
    connector.setTargetIdentifier(identifier)
    connector.connect(true)
    result("donePairing", nil)
  }

  private func getViewController() -> UIViewController? {
    var responder: UIResponder? = webView
    while let next = responder?.next {
      if let viewController = next as? UIViewController {
        return viewController
      }
      responder = next
    }
    return nil
  }

  private func startCamera() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .camera
    imagePicker.delegate = self
    getViewController()?.present(imagePicker, animated: true)
  }

  private func result(_ messageId: String, _ result: Any?, _ error: String?) {
    guard let webView = webView, let messageIdJs = encodeJavaScript([messageId]) else { return }

    var script =
      "(globalThis.ediarylib && globalThis.ediarylib.handleResult || (()=>{}))(...\(messageIdJs),"

    if let result = result, let resultJs = encodeJavaScript(result) {
      script += resultJs + ",undefined"
    } else if let error = error, let errorJs = encodeJavaScript(error) {
      script += "undefined," + errorJs
    } else {
      script += "undefined,\"unknown error\""
    }

    script += ");"

    webView.evaluateJavaScript(script)
  }

  private func result(_ function: String, _ result: Any?) {
    guard let webView = webView else { return }

    var script = "(globalThis." + function + " || (()=>{}))("
    if let result = result, let resultJs = encodeJavaScript(result) {
      script += resultJs
    }
    script += ");"
    webView.evaluateJavaScript(script)
  }
}

extension WebInterface: WKScriptMessageHandler {
  public func userContentController(
    _ userContentController: WKUserContentController, didReceive message: WKScriptMessage
  ) {
    switch message.name {
    case "ediarylibDebug":
      guard let bodyString = message.body as? String,
        let bodyData = bodyString.data(using: .utf8),
        let bodyObject = try? JSONSerialization.jsonObject(with: bodyData) as? [String: Any],
        let messageId = bodyObject["messageId"] as? String
      else { return }
      result(messageId, debug(bodyObject["payload"]), nil)

    case "search":
      search()

    case "requestPairing":
      guard let bodyObject = message.body as? [String: Any],
        let identifier = bodyObject["identifier"] as? String
      else { return }
      requestPairing(identifier)

    case "requestUnpair":
      UIApplication.shared.open(URL(string: "App-Prefs:root=Bluetooth")!)

    case "startCamera":
      startCamera()

    default:
      print("not implemented", message.name, message.body)
      guard let bodyString = message.body as? String,
        let bodyData = bodyString.data(using: .utf8),
        let bodyObject = try? JSONSerialization.jsonObject(with: bodyData) as? [String: Any],
        let messageId = bodyObject["messageId"] as? String
      else { return }
      result(messageId, nil, "not implemented")
    }
  }
}

extension WebInterface: WKNavigationDelegate {
  // 必要に応じて実装します。
}

extension WebInterface: WKUIDelegate {
  // 必要に応じて実装します。
}

extension WebInterface: BleScanDelegate {
  func onBluetoothDisabled() {
    print("onBluetoothDisabled")
    bluetoothEnabled = false
  }

  func onBluetoothEnabled() {
    print("onBluetoothEnabled")
    bluetoothEnabled = true
  }

  func onScan(_ scan: Bool) {
    if scan {
      // スキャン開始
    } else {
      // スキャン終了
      // ある程度以上（5秒×2）経過したらタイムアウトとしてリストをクリアする
    }
  }

  func onDeviceFound(_ bleDevice: BleDevice) {
    guard !devices.contains(bleDevice) else { return }
    devices.append(bleDevice)
    let searchResult = ["name": bleDevice.name, "identifier": bleDevice.identifier]
    result("searched", searchResult)
  }
}

extension WebInterface: BleScanFilter {
  func match(_ bleDevice: BleDevice) -> Bool {
    return bleDevice.name.contains("eDiary Watch")
  }
}

extension WebInterface: UIImagePickerControllerDelegate {
  public func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    getViewController()?.dismiss(animated: true)
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
      let imageData = image.jpegData(compressionQuality: 0.8)
    else {
      return
    }
    let resultData = ["data": imageData.base64EncodedString(), "name": "ediarylib.jpg"]
    result("pictured", resultData)
  }

  public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    getViewController()?.dismiss(animated: true)
    let resultData = ["error": "canceled"]
    result("pictured", resultData)
  }
}

extension WebInterface: UINavigationControllerDelegate {

}
