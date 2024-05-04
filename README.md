# Rick and Morty Character Browser

## Overview
This application is designed to showcase characters from the "Rick and Morty" series using the public Rick and Morty API. It allows users to browse through characters, view detailed profiles, and save their favorite characters using Realm for local storage.

## Features
- Fetch and display characters from the Rick and Morty API.
- Pagination to load more characters as the user scrolls.
- Search functionality to find characters by name.
- Option to favorite characters, which saves them locally using Realm.
- Detailed view of each character including their image, name, status, species, and more.
- Tabbed navigation for browsing all characters and viewing favorites.

## Requirements
- iOS 13.0+
- Xcode 11+
- Swift 5+

## Installation
To run this project, clone the repo and ensure that you have Swift Package Manager configured with the necessary packages.

```bash
git clone https://github.com/yourusername/rick-and-morty-character-browser.git
```

## Setup
Open the `.xcodeproj` file in Xcode. Swift Package Manager should automatically resolve and download the dependencies. Build and run the application on your simulator or a real device.

## Usage
1. The main screen presents a list of characters loaded from the Rick and Morty API.
2. Scroll down to load more characters automatically.
3. Use the search bar to filter characters by name.
4. Tap on any character to view their detailed information.
5. In the character detail view, you can tap the heart icon to add/remove a character from your favorites.
6. Switch to the Favorites tab to view all characters you have marked as favorites.
7. Favorite characters are stored locally and can be viewed offline.

## Libraries Used
- Kingfisher for loading and caching images.
- RealmSwift for local database management.
- SnapKit for programmatically creating UI constraints.

## Contributions
Contributions are welcome. Please fork the repository and submit a pull request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

```

Make sure to replace `https://github.com/yourusername/rick-and-morty-character-browser.git` with the actual URL of your repository. This README provides a comprehensive guide for anyone looking to understand or contribute to your project. Adjust any specific details as necessary to match your project's setup and capabilities.
