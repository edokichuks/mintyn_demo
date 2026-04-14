# Mintyn Login Screen Solution

## Tutorial

### Launch and use the login flow
1. Build and run the `mintyn_app` scheme.
2. On the login screen, enter a Nigerian phone number in any of these forms:
   - `8021234567`
   - `08021234567`
   - `+2348021234567`
3. Enter the demo password: `password`.
4. Tap `Remember me` if you want the mock token persisted in Keychain.
5. Tap `Login` to enter the placeholder authenticated home screen.
6. Tap `Logout` on the home screen to return to login and clear persisted auth.

### Explore placeholder routes
1. Tap `Forgot password?` to open the coordinator-owned placeholder flow.
2. Tap `Register new device` to open the coordinator-owned placeholder flow.
3. Use the navigation back button to return to the login screen.

## How-to

### Change the mock credentials
- Update the credential check in `mintyn_app/mintyn_app/App/Core/Services/AuthService.swift`.
- Keep `LoginViewModel.normalizePhone(_:)` aligned with any phone-formatting changes.
- Update the reference section in this file if the credentials change.

### Change copy, spacing, or colors
- Update semantic colors in `mintyn_app/mintyn_app/App/Core/Utils/AppColors.swift`.
- Update shared typography in `mintyn_app/mintyn_app/App/Core/Utils/AppFonts.swift` and `mintyn_app/mintyn_app/App/Core/Utils/AppTextStyles.swift`.
- Update screen-specific layout in `mintyn_app/mintyn_app/App/Features/Login/LoginViewController.swift`.

### Extend the authenticated flow
- Add the real destination under `mintyn_app/mintyn_app/App/Features/Home/`.
- Replace the placeholder setup in `mintyn_app/mintyn_app/App/Coordinators/MainCoordinator.swift`.

### Run the test suite
- Unit tests:
  - `xcodebuild test -scheme mintyn_app -project mintyn_app/mintyn_app.xcodeproj -destination 'platform=iOS Simulator,id=19595D3F-1F49-43A0-A8EA-741DD4B39683' -only-testing:mintyn_appTests`
- UI tests:
  - `xcodebuild test -scheme mintyn_app -project mintyn_app/mintyn_app.xcodeproj -destination 'platform=iOS Simulator,id=19595D3F-1F49-43A0-A8EA-741DD4B39683' -only-testing:mintyn_appUITests`

## Explanation

### Coordinator routing
- `AppCoordinator` is the entry point for launch routing.
- It checks Keychain-backed auth state and decides between the auth flow and the authenticated placeholder flow.
- `AuthCoordinator` owns login plus the forgot-password and register-device placeholder routes.
- `MainCoordinator` owns the authenticated placeholder home and logout transition back to auth.

### MVVM state flow
- `LoginViewModel` exposes a single `LoginViewState` snapshot with form text, password visibility, remember-me state, loading state, submit availability, and inline error text.
- `LoginViewController` stays thin: it renders state, forwards input events, and delegates navigation to coordinator callbacks.
- The login form performs local validation before calling `AuthServiceProtocol`.

### Remember-me persistence
- `KeychainService` implements `AuthTokenStoreProtocol` using the Security framework.
- If `Remember me` is selected, a successful login stores the mock token in Keychain.
- If it is not selected, login still succeeds for the current session but any persisted token is cleared.

### Runtime behavior details
- Nigerian phone input is normalized by stripping non-digits, then accepting:
  - `+234` + 10 local digits
  - `0` + 10 local digits
  - plain 10 local digits
- Inline error messages are shown inside the form card instead of modal alerts.
- Keyboard avoidance adjusts the scroll view insets so the login button remains reachable while editing.
- Secure state restoration is disabled so fresh launches always honor coordinator state and do not restore stale placeholder screens.

## Reference

### Key files
- `mintyn_app/Info.plist`
- `mintyn_app/mintyn_app/App/AppDelegate.swift`
- `mintyn_app/mintyn_app/App/SceneDelegate.swift`
- `mintyn_app/mintyn_app/App/Coordinators/AppCoordinator.swift`
- `mintyn_app/mintyn_app/App/Coordinators/AuthCoordinator.swift`
- `mintyn_app/mintyn_app/App/Coordinators/MainCoordinator.swift`
- `mintyn_app/mintyn_app/App/Core/Services/AuthService.swift`
- `mintyn_app/mintyn_app/App/Core/Services/KeychainService.swift`
- `mintyn_app/mintyn_app/App/Features/Login/LoginViewModel.swift`
- `mintyn_app/mintyn_app/App/Features/Login/LoginViewController.swift`
- `mintyn_app/mintyn_app/App/Features/Login/Views/PhonePrefixView.swift`
- `mintyn_app/mintyn_app/App/Features/Login/Views/RememberMeCheckboxView.swift`
- `mintyn_app/mintyn_app/App/Features/Login/Views/LoginPageIndicatorView.swift`
- `mintyn_app/mintyn_app/App/Features/Home/HomeViewController.swift`
- `mintyn_app/mintyn_app/App/Features/Login/Placeholders/InfoPlaceholderViewController.swift`
- `mintyn_app/mintyn_appTests/LoginViewModelTests.swift`
- `mintyn_app/mintyn_appUITests/LoginFlowUITests.swift`

### Accessibility identifiers
- `loginPhoneTextField`
- `loginPasswordTextField`
- `loginPasswordVisibilityButton`
- `loginRememberMeToggle`
- `loginForgotPasswordButton`
- `loginSubmitButton`
- `registerDeviceButton`
- `loginErrorLabel`
- `homeTitleLabel`
- `homeLogoutButton`

### Mock auth contract
- Valid phone: `8021234567`
- Valid password: `password`
- Success token: `mintyn-demo-token`
- Auth failure message: `Invalid phone number or password.`

### Test coverage
- `LoginViewModelTests`
  - validation
  - remember-me behavior
  - password visibility state
  - success and failure auth paths
- `LoginFlowUITests`
  - base login screen rendering
  - invalid credentials
  - successful login and logout
  - forgot-password placeholder navigation
  - register-device placeholder navigation
