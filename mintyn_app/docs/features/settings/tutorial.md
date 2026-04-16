# Tutorial: Settings
> **Type:** Tutorial — learning-oriented.

## What You Will Learn
- How the Settings tab is assembled inside the app's existing UIKit tab flow
- How the inline accordion sections expand and collapse
- How the theme switcher persists light, dark, and system appearance

## Prerequisites
- Open `mintyn_app.xcodeproj`
- Run the app in the simulator
- Log in with the demo credentials used by the existing UI tests

## Step 1 — Open the Settings Tab
- Launch the app and sign in.
- Tap the `Settings` tab in the custom bottom navigation.
- Confirm the root screen shows `Profile`, `Account Management`, `Referrals`, `Legal`, `Help and Support`, `System`, `Create Business Account`, and `Logout`.

## Step 2 — Expand an Inline Section
- Tap `Profile`.
- The section expands in place and reveals the five child options shown in the design.
- Tap `Help and Support` next.
- `Profile` collapses and the help items expand, preserving accordion behavior.

## Step 3 — Open a Static Destination
- Tap a non-expandable row such as `Account Management`.
- A detail screen is pushed on the shared navigation stack.
- Use the back button to return to the tabbed interface.

## Step 4 — Change the App Appearance
- Expand `System`.
- Tap `Appearance`.
- Select `System Default`, `Light`, or `Dark`.
- The interface style updates immediately and is retained on the next app launch.

## What to Do Next
- Read [How-To](./how-to.md) to extend the screen.
- Read [Reference](./reference.md) for the main files, routes, and identifiers.
- Read [Explanation](./explanation.md) for the design and architectural choices.
