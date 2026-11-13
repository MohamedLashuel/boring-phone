# Plan

This project will be an iOS app named BoringPhone. The app is meant to be a "dumb phone" app, but since iOS apps are quite limited in how they can affect the phone, a large portion of it will be walking people through system settings they can change to make their phone less appealing and distracting.

## User Experience (Pending)

The first time the user opens the app, they will be greeted by an onboarding slideshow explaining the app - details pending, so a placeholder should be made for now. When that slideshow is complete, the app's main tabbed layout will take over.

The UI should have the tabs in a bottom bar, as typical for iOS apps. Each tab will have a header with the tab name.

### Tab 1: Guide

This tab contains a list of tasks one can do to make their phone "dumber". When a task is clicked, it takes the user to a slideshow with images or animations showing how to change the required settings. The animations will mostly utilize the search bar in Settings to not make navigation complex. Tasks are marked with a check once completed, but can be reviewed at any time.

The UI should be a minimal scroll list grouped by topic. A "Help" button at the top will display the onboarding slideshow again.

These are the tasks:

#### Appearance

- **Grayscale**: Enabling the grayscale color filter (Becomes checked if it sees grayscale enabled with the UiKit API)

- **Reduce Motion**: Enabling the "reduce motion" accessibility option (Becomes checked if it sees reduce motion enabled with the UiKit API)

- **Wallpapers**: Change the Home and Lock Screen wallpapers to plain black

#### Friction

- **Home pages**: Clear the home pages and remove all widgets from the Today view. Set newly downloaded apps to only appear in the App Library

- **Turn off raise to wake, Face ID unlock and Raise to wake**

- **Require passcode**: A setting controls how long after locking the phone the password is required again - set this to "immediately". (Face ID requires "immediately", so make sure this is after Face ID)

- **Set a long password**: Create a long alphanumeric password to lengthen opening the phone

- **Reminder Widget**: Add a lock screen widget from this app that reminds you to ask yourself why you're using your phone

#### Other

- **Scheduled Summary**: Use the iOS scheduled summary feature to deliver non-urgent notifications in a block at once, rather than throughout the day

- **Screen Time Widget**: Add a Screen Time widget to the home screen to display how long the phone has been used that day

- **Clock mode Widget**: When pressed, opens Clock in guided access. Uses a Shortcut

### Tab 2: App Delays

- **App delays**: Adds an artificial load of 10 seconds before opening apps, either specified from a list or on all apps (with optional exclusions). Done with app shields - displays "Open (in 10 seconds)" and displays a message if clicked before the 10 seconds are up. Passing the shield enables apps for a custom amount of time, default 15 minutes.

### Tab 3: Device Features

This tab will inform the user about existing on-device features: Screen Time, Focus Mode, Guided Access, and Assistive Access in an article format with images and animations where necessary. Sections about each feature will inform the user on these points (but not limited to them):

- Features and how it works

- Potential drawbacks

- How to enable or disable it

- Use cases

For guided access, specifically mention using it with Clock or Google Maps on the go.