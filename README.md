# MobileGarage
An app that uses info about your vehicles to alert you to probable maintenance dates

The app features a handful of views for the user to view their 'garage', add vehicles to it, view service events, and schedule new events.

The code largely consists of the necessary view controllers and model classes.  To enforce a separation of concerns, PList operations are refactored to PListUtils.swift, which also dictates the markup schema.  iOS 8-compatible Cloudkit key-value storage logic is still in AddVehicleViewController.swift.  That logic is not complete because there was no practical iOS 8 device to work with.
