import UIKit

final class LoginViewController: UIViewController {
    var onLoginSuccess: (() -> Void)?
    var onForgotPasswordRequested: (() -> Void)?
    var onRegisterDeviceRequested: (() -> Void)?

    private let viewModel: LoginViewModel

    private let welcomeLabel = AppLabel(
        style: AppTextStyles.screenTitle,
        color: AppColors.textPrimary,
        alignment: .center
    )
    private let quickActionsPagerView = QuickActionPagerView()
    private let pageIndicatorView = LoginPageIndicatorView()
    private let formCardView = UIView()
    private let formScrollView = UIScrollView()
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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyFormCardAppearance()
    }

    private func setupUI() {
        view.backgroundColor = AppColors.background

        welcomeLabel.text = "Welcome"
        pageIndicatorView.accessibilityIdentifier = "loginQuickActionsPageIndicator"
        pageIndicatorView.accessibilityLabel = "Quick actions page"
        pageIndicatorView.configure(pageCount: 2)
        pageIndicatorView.setCurrentPage(0, animated: false)

        setupQuickActions()
        setupForm()

        view.addSubview(welcomeLabel)
        view.addSubview(quickActionsPagerView)
        view.addSubview(pageIndicatorView)
        view.addSubview(formCardView)

        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spacing.lg),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.lg),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.lg),

            quickActionsPagerView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 42),
            quickActionsPagerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            quickActionsPagerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),

            pageIndicatorView.topAnchor.constraint(equalTo: quickActionsPagerView.bottomAnchor, constant: 18),
            pageIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            formCardView.topAnchor.constraint(equalTo: pageIndicatorView.bottomAnchor, constant: 54),
            formCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            formCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            formCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupQuickActions() {
        quickActionsPagerView.accessibilityIdentifier = "loginQuickActionsPager"
        quickActionsPagerView.delegate = self
        quickActionsPagerView.configure(
            with: [
                QuickActionPagerView.Page(
                    rows: [
                        [
                            QuickActionPagerView.Card(title: "EasyCollect", iconSystemName: "shippingbox.fill"),
                            QuickActionPagerView.Card(title: "Open an", subtitle: "Account", iconSystemName: "shield.fill")
                        ],
                        [
                            QuickActionPagerView.Card(title: "CAC Business", subtitle: "Registration", iconSystemName: "doc.on.doc.fill"),
                            QuickActionPagerView.Card(title: "Contact", subtitle: "Support", iconSystemName: "person.crop.circle.badge.questionmark")
                        ]
                    ]
                ),
                QuickActionPagerView.Page(
                    rows: [
                        [
                            QuickActionPagerView.Card(
                                title: "Maplerad",
                                subtitle: "Virtual Cards",
                                iconSystemName: "creditcard.fill",
                                style: .highlighted
                            ),
                            QuickActionPagerView.Card(title: "Insurance", subtitle: "Coming soon...", iconSystemName: "shield.fill")
                        ],
                        [
                            QuickActionPagerView.Card(
                                title: "NCTO Card",
                                subtitle: "Activation",
                                iconSystemName: "creditcard.trianglebadge.exclamationmark",
                                style: .mutedSuccess
                            ),
                            nil
                        ]
                    ]
                )
            ]
        )
    }

    private func setupForm() {
        formCardView.translatesAutoresizingMaskIntoConstraints = false
        formCardView.layer.cornerRadius = 28
        formCardView.layer.cornerCurve = .continuous
        formCardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        formCardView.clipsToBounds = true
        applyFormCardAppearance()

        formScrollView.translatesAutoresizingMaskIntoConstraints = false
        formScrollView.showsVerticalScrollIndicator = false
        formScrollView.alwaysBounceVertical = true
        formScrollView.keyboardDismissMode = .interactive

        phoneLabel.text = "Phone Number"
        phoneField.placeholder = "802 123 4567"
        phoneField.keyboardType = .phonePad
        phoneField.returnKeyType = .done
        phoneField.textContentType = .telephoneNumber
        phoneField.accessibilityIdentifier = "loginPhoneTextField"
        phoneField.delegate = self
        phoneField.inputAccessoryView = makeDoneAccessoryToolbar()
        phoneField.applyLeftAccessoryView(PhonePrefixView())

        passwordLabel.text = "Password"
        passwordField.placeholder = "********"
        passwordField.returnKeyType = .done
        passwordField.textContentType = .password
        passwordField.isSecureTextEntry = true
        passwordField.accessibilityIdentifier = "loginPasswordTextField"
        passwordField.delegate = self
        passwordField.inputAccessoryView = makeDoneAccessoryToolbar()
        passwordField.applyRightAccessoryView(passwordAccessoryContainer)
        passwordField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)

        passwordToggleButton.accessibilityIdentifier = "loginPasswordVisibilityButton"
        passwordToggleButton.addTarget(self, action: #selector(passwordVisibilityTapped), for: .touchUpInside)

        errorContainerView.translatesAutoresizingMaskIntoConstraints = false
        errorContainerView.layer.cornerRadius = 12
        errorContainerView.isHidden = true
        errorContainerView.accessibilityIdentifier = "loginErrorLabel"
        errorLabel.accessibilityIdentifier = "loginErrorLabel"
        errorLabel.isAccessibilityElement = false

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
        contentStack.setCustomSpacing(46, after: rememberForgotRow)
        contentStack.setCustomSpacing(48, after: loginButton)
        contentStack.setCustomSpacing(14, after: registerDeviceButton)

        formCardView.addSubview(formScrollView)
        formScrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            formScrollView.topAnchor.constraint(equalTo: formCardView.topAnchor),
            formScrollView.leadingAnchor.constraint(equalTo: formCardView.leadingAnchor),
            formScrollView.trailingAnchor.constraint(equalTo: formCardView.trailingAnchor),
            formScrollView.bottomAnchor.constraint(equalTo: formCardView.safeAreaLayoutGuide.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: formScrollView.contentLayoutGuide.topAnchor, constant: 48),
            contentStack.leadingAnchor.constraint(equalTo: formScrollView.frameLayoutGuide.leadingAnchor, constant: 18),
            contentStack.trailingAnchor.constraint(equalTo: formScrollView.frameLayoutGuide.trailingAnchor, constant: -18),
            contentStack.bottomAnchor.constraint(equalTo: formScrollView.contentLayoutGuide.bottomAnchor, constant: -28)
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
            formScrollView.contentInset.bottom = bottomInset
            formScrollView.verticalScrollIndicatorInsets.bottom = bottomInset
            scrollActiveInputIntoView(animated: false)
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
        errorContainerView.backgroundColor = AppColors.errorBackground
        errorContainerView.isHidden = !hasError
        errorContainerView.isAccessibilityElement = hasError
        errorContainerView.accessibilityLabel = viewState.errorMessage
        errorLabel.text = viewState.errorMessage
    }

    private func applyFormCardAppearance() {
        formCardView.backgroundColor = AppColors.surfacePrimary
        formCardView.layer.shadowOpacity = 0
        formCardView.layer.shadowRadius = 0
        formCardView.layer.shadowOffset = .zero
        formCardView.layer.shadowColor = nil
    }

    private func updatePasswordFieldVisibility(isHidden: Bool) {
        guard passwordField.isSecureTextEntry != isHidden else { return }

        let existingText = passwordField.text
        passwordField.isSecureTextEntry = isHidden
        passwordField.text = existingText
    }

    private func makeDoneAccessoryToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneInputTapped))
        ]
        return toolbar
    }

    private func scrollActiveInputIntoView(animated: Bool) {
        guard let activeInput = activeInputView else { return }

        let inputRect = activeInput.convert(activeInput.bounds, to: formScrollView)
        let paddedRect = inputRect.insetBy(dx: 0, dy: -24)
        formScrollView.scrollRectToVisible(paddedRect, animated: animated)
    }

    private var activeInputView: UIView? {
        if phoneField.isFirstResponder {
            return phoneField
        }

        if passwordField.isFirstResponder {
            return passwordField
        }

        return nil
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

    @objc private func doneInputTapped() {
        view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollActiveInputIntoView(animated: true)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField === phoneField,
              let currentText = textField.text,
              let textRange = Range(range, in: currentText)
        else {
            return true
        }

        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        let formattedText = LoginViewModel.formatPhoneInput(updatedText)

        phoneField.text = formattedText
        viewModel.updatePhone(formattedText)

        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension LoginViewController: QuickActionPagerViewDelegate {
    func quickActionPagerView(_ pagerView: QuickActionPagerView, didChangePage page: Int) {
        pageIndicatorView.setCurrentPage(page)
    }
}
