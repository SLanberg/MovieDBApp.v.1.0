# Quick Setup

Go to the project root directory 
1. Create .env file 
2. Get yours API Key from here https://www.themoviedb.org/settings/api
3. Add API key write in your env file like this: API_KEY={Provide your API KEY in .env file}
4. In Android Studio Terminal: flutter pub get 
5. You are good to go!

# Flutter Movie App Documentation

## Introduction
The Flutter Movie App is a mobile application built using the Flutter framework. It consists of two screens: the Main Screen and the Details Screen. The Main Screen displays a vertical list with a collapsible toolbar and four collapsible sections. Each section contains a horizontally scrollable list of movies fetched from various APIs. The Details Screen is implemented as a bottom sheet and displays detailed information about a selected movie.

## Main Screen
The Main Screen is the landing screen of the app and provides an overview of different movie categories.

### Features:
1. Collapsible Toolbar: The Main Screen includes a collapsible toolbar with a random movie image. The toolbar can be expanded or collapsed by the user.

2. Collapsible Sections: There are four collapsible sections on the Main Screen, each representing a different movie category: Latest Movies, Popular Movies, Top Rated Movies, and Upcoming Movies. Initially, the first two sections are populated with data, while the remaining two are in a collapsed state. Each section displays a title and a horizontally scrollable list of movies.

3. API Integration: The app integrates with various APIs to fetch movie data for each collapsible section. The data is displayed as a horizontally scrollable list within the corresponding section. The APIs used are as follows:
   - Latest Movies: The Latest Movies API is polled every 30 seconds to fetch the latest movie data. This section is updated with the most recent movies available. If the Latest Movies section is collapsed, the polling is stopped.
   - Popular Movies: This section displays popular movies fetched from the API.
   - Top Rated Movies: This section displays top-rated movies fetched from the API.
   - Upcoming Movies: This section displays upcoming movies fetched from the API.

4. Movie Items: Each movie item in the horizontal lists consists of a movie image and its title. Clicking on any item opens the Details Screen as a bottom sheet.

5. Expand/Collapse Sections: Users can expand or collapse any of the four sections by interacting with the section title bar. Collapsing a section stops polling for new data.

## Details Screen
The Details Screen provides more detailed information about a selected movie.

### Features:
1. Bottom Sheet: The Details Screen is implemented as a bottom sheet, appearing as an overlay above the Main Screen.

2. Movie Information: The Details Screen displays the selected movie's image, along with other information obtained from an external API.

3. Video Play Icon: If a video is available for the selected movie, a play icon is shown. Clicking on this icon triggers a snackbar that displays the movie's name.

### External API
To fetch detailed movie information and check for video availability, the app utilizes an external API. The API provides data such as the movie's title, release date, duration, overview, and video availability.

## Conclusion
The Flutter Movie App provides users with a visually appealing interface to explore different movie categories. The Main Screen allows users to view and scroll through movies in collapsible sections. The Details Screen presents additional information about a selected movie and allows users to play available videos. With its intuitive design and smooth navigation, the Flutter Movie App offers an enjoyable movie browsing experience.

## Useful commands

To sort imports in alphabetical order we use https://pub.dev/packages/import_sorter:
Run in the terminal "flutter pub run import_sorter:main"