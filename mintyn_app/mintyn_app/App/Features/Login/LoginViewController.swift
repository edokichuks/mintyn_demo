import UIKit

final class LoginViewController: UIViewController {
    var onLoginSuccess: (() -> Void)?
    var onForgotPasswordRequested: (() -> Void)?
    var onRegisterDeviceRequested: (() -> Void)?

    private let viewModel: LoginViewModel

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let welcomeLabel = AppLabel(
        style: AppTextStyles.screenTitle,
        color: AppColors.textPrimary,
        alignment: .center
    )
    private let quickActionsStack = UIStackView()
    private let pageIndicatorView = LoginPageIndicatorView()
    private let formCardView = UIView()
    private let phoneLabel = AppLabel(style: AppTextStyles.fieldLabel, color: AppColors.textPrimary)
    private let phoneField = AppTextField()
    private let passwordLabel = AppLabel(style: AppTextStyles.fieldLabel, color: AppColors.textPrimary)
    private let passwordField = AppTextField()
    private let errorContainerView = UIView()
    private let errorLabel = AppLabel(
        style: AppTextStyles.inlineError,
        color: AppColors.error,
        alignment: .left,
        numberOfLines: 0
    )
    private let rememberMeView = RememberMeCheckboxView()
    private let forgotPasswordButton = AppTextButton(title: "Forgot password?")
    private let loginButton = AppButton()
    private let registerDeviceButton = AppTextButton(title: "Register new device")
    private let footerLabel = AppLabel(
        style: AppTextStyles.caption,
        color: AppColors.textTertiary,
        alignment: .center,
        numberOfLines: 0
    )
    private let passwordToggleButton = AppIconButton(symbolName: "eye")
    private var keyboardObservers = [NSObjectProtocol]()

    private lazy var passwordAccessoryContainer: UIView = {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        passwordToggleButton.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(passwordToggleButton)
        NSLayoutConstraint.activate([
            passwordToggleButton.topAnchor.constraint(equalTo: container.topAnchor),
            passwordToggleButton.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            passwordToggleButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            passwordToggleButton.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        return container
    }()

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerForKeyboardNotifications()
        bindViewModel()
        apply(viewState: viewModel.currentState)
    }

    deinit {
        keyboardObservers.forEach(NotificationCenter.default.removeObserver)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupUI() {
        view.backgroundColor = AppColors.background

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        contentView.translatesAutoresizingMaskIntoConstraints = false

        welcomeLabel.text = "Welcome"
        pageIndicatorView.setCurrentPage(0)

        setupQuickActions()
        setupForm()

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(welcomeLabel)
        contentView.addSubview(quickActionsStack)
        contentView.addSubview(pageIndicatorView)
        contentView.addSubview(formCardView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),

            welcomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.lg),
            welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.lg),
            welcomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.lg),

            quickActionsStack.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 42),
            quickActionsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            quickActionsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),

            pageIndicatorView.topAnchor.constraint(equalTo: quickActionsStack.bottomAnchor, constant: 18),
            pageIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            formCardView.topAnchor.constraint(equalTo: pageIndicatorView.bottomAnchor, constant: 40),
            formCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            formCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            formCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setupQuickActions() {
        let easyCollectButton = QuickActionButton(title: "EasyCollect", iconSystemName: "shippingbox.fill")
        let openAccountButton = QuickActionButton(title: "Open an\nAccount", iconSystemName: "shield.fill")
        let registrationButton = QuickActionButton(title: "CAC Business\nRegistration", iconSystemName: "doc.on.doc.fill")
        let supportButton = QuickActionButton(title: "Contact\nSupport", iconSystemName: "person.crop.circle.badge.questionmark")

        let topRow = UIStackView(arrangedSubviews: [easyCollectButton, openAccountButton])
        topRow.axis = .horizontal
        topRow.spacing = 14
        topRow.distribution = .fillEqually

        let bottomRow = UIStackView(arrangedSubviews: [registrationButton, supportButton])
        bottomRow.axis = .horizontal
        bottomRow.spacing = 14
        bottomRow.distribution = .fillEqually

        quickActionsStack.translatesAutoresizingMaskIntoConstraints = false
        quickActionsStack.axis = .vertical
        quickActionsStack.spacing = 14
        quickActionsStack.addArrangedSubview(topRow)
        quickActionsStack.addArrangedSubview(bottomRow)
    }

    private func setupForm() {
        formCardView.translatesAutoresizingMaskIntoConstraints = false
        formCardView.backgroundColor = AppColors.surfacePrimary
        formCardView.layer.cornerRadius = 28
        formCardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        phoneLabel.text = "Phone Number"
        phoneField.placeholder = "802 123 4567"
        phoneField.keyboardType = .phonePad
        phoneField.textContentType = .telephoneNumber
        phoneField.accessibilityIdentifier = "loginPhoneTextField"
        phoneField.applyLeftAccessoryView(PhonePrefixView())
        phoneField.addTarget(self, action: #selector(phoneChanged), for: .editingChanged)

        passwordLabel.text = "Password"
        passwordField.placeholder = "********"
        passwordField.textContentType = .password
        passwordField.isSecureTextEntry = true
        passwordField.accessibilityIdentifier = "loginPasswordTextField"
        passwordField.applyRightAccessoryView(passwordAccessoryContainer)
        passwordField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)

        passwordToggleButton.accessibilityIdentifier = "loginPasswordVisibilityButton"
        passwordToggleButton.addTarget(self, action: #selector(passwordVisibilityTapped), for: .touchUpInside)

        errorContainerView.translatesAutoresizingMaskIntoConstraints = false
        errorContainerView.backgroundColor = AppColors.errorBackground
        errorContainerView.layer.cornerRadius = 12
        errorContainerView.isHidden = true
        errorLabel.accessibilityIdentifier = "loginErrorLabel"

        errorContainerView.addSubview(errorLabel)

        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: errorContainerView.topAnchor, constant: 10),
            errorLabel.bottomAnchor.constraint(equalTo: errorContainerView.bottomAnchor, constant: -10),
            errorLabel.leadingAnchor.constraint(equalTo: errorContainerView.leadingAnchor, constant: 12),
            errorLabel.trailingAnchor.constraint(equalTo: errorContainerView.trailingAnchor, constant: -12)
        ])

        rememberMeView.accessibilityIdentifier = "loginRememberMeToggle"
        rememberMeView.addTarget(self, action: #selector(rememberMeTapped), for: .touchUpInside)

        forgotPasswordButton.accessibilityIdentifier = "loginForgotPasswordButton"
        forgotPasswordButton.contentHorizontalAlignment = .right
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)

        loginButton.setTitle("Login", for: .normal)
        loginButton.accessibilityIdentifier = "loginSubmitButton"
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        registerDeviceButton.accessibilityIdentifier = "registerDeviceButton"
        registerDeviceButton.contentHorizontalAlignment = .center
        registerDeviceButton.addTarget(self, action: #selector(registerDeviceTapped), for: .touchUpInside)

        footerLabel.text = "Powered by FINEX MFB\nVersion 1.4.09"

        let rememberForgotRow = UIStackView(arrangedSubviews: [rememberMeView, UIView(), forgotPasswordButton])
        rememberForgotRow.axis = .horizontal
        rememberForgotRow.alignment = .center
        rememberForgotRow.spacing = Spacing.md

        let contentStack = UIStackView(
            arrangedSubviews: [
                phoneLabel,
                phoneField,
                passwordLabel,
                passwordField,
                errorContainerView,
                rememberForgotRow,
                loginButton,
                registerDeviceButton,
                footerLabel
            ]
        )
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.setCustomSpacing(8, after: phoneLabel)
        contentStack.setCustomSpacing(20, after: phoneField)
        contentStack.setCustomSpacing(8, after: passwordLabel)
        contentStack.setCustomSpacing(16, after: passwordField)
        contentStack.setCustomSpacing(28, after: rememberForgotRow)
        contentStack.setCustomSpacing(36, after: loginButton)
        contentStack.setCustomSpacing(14, after: registerDeviceButton)

        formCardView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: formCardView.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: formCardView.leadingAnchor, constant: 18),
            contentStack.trailingAnchor.constraint(equalTo: formCardView.trailingAnchor, constant: -18),
            contentStack.bottomAnchor.constraint(equalTo: formCardView.safeAreaLayoutGuide.bottomAnchor, constant: -28)
        ])
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] viewState in
            self?.apply(viewState: viewState)
        }

        viewModel.onLoginSuccess = { [weak self] in
            self?.onLoginSuccess?()
        }
    }

    private func registerForKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default

        let changeFrameObserver = notificationCenter.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleKeyboard(notification: notification)
        }

        let hideObserver = notificationCenter.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleKeyboard(notification: notification)
        }

        keyboardObservers = [changeFrameObserver, hideObserver]
    }

    private func handleKeyboard(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }

        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.25
        let animationCurveRawValue = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt) ?? 7
        let options = UIView.AnimationOptions(rawValue: animationCurveRawValue << 16)

        let bottomInset: CGFloat
        if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let convertedKeyboardFrame = view.convert(keyboardFrame, from: nil)
            let intersection = view.bounds.intersection(convertedKeyboardFrame)
            bottomInset = max(0, intersection.height - view.safeAreaInsets.bottom) + Spacing.lg
        } else {
            bottomInset = 0
        }

        UIView.animate(withDuration: duration, delay: 0, options: options) { [weak self] in
            guard let self else { return }
            scrollView.contentInset.bottom = bottomInset
            scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
            view.layoutIfNeeded()
        }
    }

    private func apply(viewState: LoginViewState) {
        if phoneField.text != viewState.phoneText {
            phoneField.text = viewState.phoneText
        }

        updatePasswordFieldVisibility(isHidden: viewState.isPasswordHidden)
        rememberMeView.isChecked = viewState.isRememberMeSelected

        loginButton.setLoading(viewState.isLoading)
        loginButton.isEnabled = viewState.isLoginEnabled && !viewState.isLoading

        passwordToggleButton.setSymbol(viewState.isPasswordHidden ? "eye" : "eye.slash")
        passwordToggleButton.setTintColor(viewState.isPasswordHidden ? AppColors.textSecondary : AppColors.brandPrimary)

        let hasError = !(viewState.errorMessage?.isEmpty ?? true)
        errorContainerView.isHidden = !hasError
        errorLabel.text = viewState.errorMessage
    }

    private func updatePasswordFieldVisibility(isHidden: Bool) {
        guard passwordField.isSecureTextEntry != isHidden else { return }

        let existingText = passwordField.text
        passwordField.isSecureTextEntry = isHidden
        passwordField.text = existingText
    }

    @objc private func phoneChanged() {
        viewModel.updatePhone(phoneField.text ?? "")
    }

    @objc private func passwordChanged() {
        viewModel.updatePassword(passwordField.text ?? "")
    }

    @objc private func rememberMeTapped() {
        viewModel.toggleRememberMe()
    }

    @objc private func passwordVisibilityTapped() {
        viewModel.togglePasswordVisibility()
    }

    @objc private func forgotPasswordTapped() {
        onForgotPasswordRequested?()
    }

    @objc private func registerDeviceTapped() {
        onRegisterDeviceRequested?()
    }

    @objc private func loginTapped() {
        view.endEditing(true)
        viewModel.submit()
    }
}
