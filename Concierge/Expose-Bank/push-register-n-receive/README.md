# Push Register N Receive

This project is to show how simple it is to register for Push, receive a Push from Flybits and handle it.

The [MainViewController](/MainViewController.swift) file has two buttons, one to connect and the second to request the push permission from the user.

Once the sample is setup, it will be required to trigger the push notification from Experience Studio 2.0

This sample shows how to request the device's push permission and handle a push notification to display a Concierge with the content.

The handling portion of the push is inside the [AppDelegate](/AppDelegate.swift) file starting on line 54.
