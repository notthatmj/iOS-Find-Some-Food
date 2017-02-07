# iOS-Business-Finder

This is an educational project. It's intended to help me improve my iOS
development skills, with a focus on testing and refactoring. It seemed like
"get the user's location, get some information from an API based on the user's
location, parse it, and display it in a tableview" is a pretty common
requirement, so I thought that working my way through that task would be
instructive. I'm using OCMock to make fakes for testing, and I'm using
Cocoapods to install OCMock. Information on nearby businesses comes from the
FourSquare API.

## Building

Because this project uses Cocoapods, you'll need to open the `Business Finder.xcworkspace` file using XCode in order to build it. The linker will complain about missing libraries if you try to build it using the `Business Finder.xcodeproj` file.

## Running in the simulator

If you're running the app in the simulator, you'll need to set a location under the the Debug -> Location menu to see any results. The simulator seems to be flaky with regards to location, especially when it comes to changing the simulated location once it has been set. So you may need to restart the simulator if you want to see results from multiple locations.

## Running the tests

Some of the integration tests in the `Slower Tests` target will fail unless the app has permission to access your location. If these tests are failing, try running the app and granting location access when prompted.

Tests in the `Fastest Tests` target/scheme should pass with or without location permission.
