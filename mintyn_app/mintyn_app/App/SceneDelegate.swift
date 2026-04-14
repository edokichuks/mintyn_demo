import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let splashViewController = SplashViewController(
            displayDuration: AppLaunchArguments.isUITesting ? 0 : 0.9
        )
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()

        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true

        let appCoordinator = AppCoordinator(navigationController: navigationController)
        self.appCoordinator = appCoordinator

        splashViewController.onFinish = { [weak window] in
            appCoordinator.start()

            guard let window else { return }
            UIView.transition(
                with: window,
                duration: 0.25,
                options: [.transitionCrossDissolve, .curveEaseInOut]
            ) {
                window.rootViewController = navigationController
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
