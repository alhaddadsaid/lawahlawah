import UserNotifications

/// Downloads the picture of a push notification (the "image" value the admin
/// sends) and attaches it, so the notification shows it like a series poster.
/// Without a picture, or if the download fails, the notification shows as is.
class NotificationService: UNNotificationServiceExtension {
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var content: UNMutableNotificationContent?
    private var task: URLSessionDownloadTask?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        content = request.content.mutableCopy() as? UNMutableNotificationContent
        guard let content = content,
            let text = imageLink(in: request.content.userInfo),
            let url = URL(string: text), url.scheme == "https"
        else {
            contentHandler(request.content)
            return
        }
        task = URLSession.shared.downloadTask(with: url) { [weak self] file, response, _ in
            defer { self?.finish() }
            guard let file = file else { return }
            let ext = url.pathExtension.isEmpty ? "jpg" : url.pathExtension
            let target = FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString).appendingPathExtension(ext)
            do {
                try FileManager.default.moveItem(at: file, to: target)
                let attachment = try UNNotificationAttachment(identifier: "image", url: target)
                content.attachments = [attachment]
            } catch {
                /* Shown without the picture. */
            }
        }
        task?.resume()
    }

    override func serviceExtensionTimeWillExpire() {
        task?.cancel()
        finish()
    }

    private func finish() {
        guard let handler = contentHandler, let content = content else { return }
        contentHandler = nil
        handler(content)
    }

    private func imageLink(in info: [AnyHashable: Any]) -> String? {
        if let value = info["image"] as? String { return value }
        if let options = info["fcm_options"] as? [String: Any], let value = options["image"] as? String {
            return value
        }
        return nil
    }
}
