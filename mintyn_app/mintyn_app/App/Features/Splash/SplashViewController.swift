import UIKit

final class SplashViewController: UIViewController {
    var onFinish: (() -> Void)?

    private let displayDuration: TimeInterval
    private var hasScheduledFinish = false

    private let splashImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LaunchSplash"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    init(displayDuration: TimeInterval) {
        self.displayDuration = displayDuration
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(splashImageView)

        NSLayoutConstraint.activate([
            splashImageView.topAnchor.constraint(equalTo: view.topAnchor),
            splashImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            splashImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            splashImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard !hasScheduledFinish else { return }
        hasScheduledFinish = true

        guard displayDuration > 0 else {
            onFinish?()
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + displayDuration) { [weak self] in
            self?.onFinish?()
        }
    }
}
