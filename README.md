# [DEPRECATED] PIAPIEnvironmentManager #

⚠️ **This repository is no longer maintained or supported. New pull requests will not be reviewed. For an alternative in Swift, check out [Yoshi](https://github.com/prolificinteractive/yoshi).** ⚠️

## Summary 

PiOS PIAPIEnvironmentManager POD to help iOS Engineers manage API Environments within their iOS app. 
Easily switch environments with the shake of your device and the current environment is retained, even after closing the app.

![PIAPIEnvironmentManager](https://www.dropbox.com/s/k6lxr5ndz57wwjx/apienvironmentmanager.gif?raw=1)

## Requirements

This project is compatible with Xcode 6.4+ and Swift 2.0. All previous versions are not supported.

## Installation

To install PIAPIEnvironmentManager, simply add the following line to your Podfile:

    pod "PIAPIEnvironmentManager"
	

## Usage

PIAPIEnvironmentManager provides an interface that makes it simple to create your own API Environments and use them with the core manager
without much fuss. 

First, create an object (class or struct) that implements the `PIAPIEnvironmentObject` protocol; this protocol defines an interface for
an object to be considered a valid PIAPIEnvironment object. Objects implementing this protocol should make an attempt to be as stateless
as possible to maintain maximum compatibility with the manager. 

Next, create an instance of `PIAPIEnvironmentManager` by passing to it all possible environments as defined by your custom implementation of
`PIAPIEnvironmentObject`. That's it! The APIEnvironmentManager is ready to use.

This project also comes with a few additional bells and whistles as well.

### Caching

`PIAPIEnvironmentManager`, by default, caches the currently selected environment to disk and remembers it between sessions; while you 
still need to create the manager and pass to it your environments when the application launches, `PIAPIEnvironmentManager` is built to be
smart enough to automatically select the cached environment on load without having to do it manually. 

By default, `PIAPIEnvironmentManager` uses `NSUserDefaults` to store this information.

If you do not want to use `NSUserDefaults`, then you're in luck! Simply create an object that implements the `PIAPIEnvironmentCacheProvider` protocol
and pass it to `PIAPIEnvironmentManager` using `initWithEnvironments: cacheProvider:`. That's it! `PIAPIEnvironmentManager` will now use
your cache to store and retrieve stored information, allowing you to use any storage you want: `NSKeyedArchiver`, `CoreData`, `Realm`, etc.

### Changing Environments

While `PIAPIEnvironmentManager` makes it easy to manage your environments between sessions, `PIAPIEnvironmentViewController` provides a simple,
default interface for managing them while in the application. Simply create a new instance using `initWithEnvironmentManager:` and that's it! The
view controller will now allow any user to change API environments with minimum work.

### Built-In Gestures

While you can create and display `PIAPIEnvironmentManager` easily on your own, this framework also contains a simple way to view
the environment switcher from anywhere in your application. Simply use `PIInvokeManager setInvokeEvent: forManager:` to set a gesture
for automatically displaying this user interface anywhere in your application. Usage of this is completely optional, but adds a 
quick and easy interface for managing environments right out of the box.

Supported gestures:

* Shake
* Two-Finger Swipe to the Left

## Author 

Julio,      julio@prolificinteractive.com
Chris,      c.jones@prolificinteractive.com
Max,        max@prolificinteractive.com
Thibault,   thibault@prolificinteractive.com

## License

PIAPIEnvironmentManager is available under the MIT license. See the LICENSE file for more info.
