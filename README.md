# GitHub Repos App

## Overview

The GitHub Repos App is a Flutter application that lists the most starred GitHub repositories created in the last 30 days.
The app fetches data from the GitHub API and stores it locally using SQLite (`sqflite`) for offline access.
It supports pagination and displays relevant repository details, including the repository name, description, number of stars, and the owner's username and avatar.

## Features

- **List Most Starred Repositories**: Displays repositories with the most stars, created in the last 30 days.
- **Offline Access**: Uses SQLite (`sqflite`) to cache data locally, allowing users to view previously fetched repositories even without an internet connection.
- **Pagination**: Handles paginated results from the GitHub API.
- **Repository Details**: Shows repository name, description, star count, owner's username, and avatar.
- **Unit Testing**: Includes unit tests for models, services, and providers.

## Technologies Used

- Flutter
- Provider
- sqflite
- Dio

## Setup Instructions

### Prerequisites

Ensure you have the following installed:
- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- An IDE like [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)

### Clone the Repository

```bash
git clone https://github.com/your-username/github_repos_app.git
cd github_repos_app
## Live Demo

Check out the live version of the app here: [Live GitHub Repos App](https://www.amazon.com/gp/product/B0DG3JM5FK)
