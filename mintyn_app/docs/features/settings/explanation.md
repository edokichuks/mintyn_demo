# Explanation: Settings
> **Type:** Explanation — understanding-oriented.

## Why use an accordion on the root screen?
- The supplied references show inline expansion rather than drill-down navigation for the three grouped categories.
- Keeping those sections inline preserves the exact browsing rhythm from the mockup and reduces extra navigation for common profile and support tasks.

## Why push detail screens for the child destinations?
- Every row in the design ends with a chevron, which implies a navigable destination.
- The project does not yet contain real flows for those destinations, so lightweight detail screens keep the navigation contract complete without inventing backend behavior.

## Why persist appearance at the window level?
- The project already uses dynamic colors extensively through `AppColors`.
- Applying `overrideUserInterfaceStyle` on the app window lets those colors update automatically across the whole interface.
- `UserDefaults` is the right persistence mechanism because appearance is a non-sensitive user preference.

## Why keep the Coordinator in charge?
- The codebase uses MVVM + Coordinator consistently.
- The Settings controllers only publish user intent and render state.
- `MainCoordinator` owns logout, detail routing, and theme application so navigation and app-wide side effects stay out of the view controllers.
