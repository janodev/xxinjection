# Overview

Overview documentation for the project.

## Launch

![Launch](launch.png)

A main file 

- registers dependencies
- chooses a real or testing app delegate

The testing delegate is a NSObject subclass with a window variable.  

## Start

![Start](start.png)

MainCoordinator is a coordinator of coordinators. 

- It starts the login screen if accesss token is missing.
- It starts the home screen otherwise. 

## Home

![Home](home.png)

- HomeDomain: features.
- HomeViewController: view.

![TableViewController](tableViewController.png)
