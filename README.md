# Table of Contents
1. [Description](#description)
2. [Getting started](#getting-started)
3. [Arhitecture](#arhitecture)
4. [Structure](#structure)
5. [Running the tests](#running-the-tests)
6. [API](#api)

# UsersApp
A simple project that fetches random users from web.

# Description
<p>The UsersApp project contains several design patterns.<br>
It is designed for developers with above average experience with coding and aims to familiarize them with the concepts 
of MVVM-C.<br> </p>

# Getting started
<p>
1. Make sure you have the Xcode version 14.0 or above installed on your computer.<br>
2. Download the UsersApp project files from the repository.<br>
3. Let the Swift Package Manager downloads the dependencies.<br>
4. Open the project files in Xcode.<br>
5. Run the active scheme.<br>

You should see the two tabs: "Users" & "Bookmarks".<br>
Application fetches random users from the web on the first tab.<br>
When you click one of the users, you'll navigate to the user details screen.<br>
Application saves users with heart button to the Core Data.<br>
You can see the saved users on the second tab. <br>

# Architecture
* UsersApp project is implemented using the <strong>Model-View-ViewModel-Coordinator (MVVM-C)</strong> architecture pattern.
* Model has any necessary data or business logic needed to generate the users.
* View displays the app’s user interface and communicates with the view model to update the UI based on the data model.
* View Model: The view model layer acts as an intermediary between the view and the data model.
* Coordinator: The coordinator layer handles the app’s navigation flow. It is responsible for instantiating and presenting view controllers, passing data between view controllers, and handling user actions.

# Notes
* Project is using a local database called Core Data.<br><br>
* Every view elements are created programmatically without using Storyboards.<br><br>
* Generic network layer is written with modern concurrency.


# Running the tests
<p>UsersApp can be tested using the built-in framework XCTest.</p>

# API 
* We are using a REST API
* List of API calls is [here](https://randomuser.me/api) 

# TODOs
* More unit tests will be added.
* Loading animation will be added.
