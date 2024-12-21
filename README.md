# Daily Laughs - Flutter Jokes App

A modern, feature-rich Flutter application that delivers jokes with a beautiful UI, offline support, and smooth animations. The app fetches jokes from the JokeAPI and provides a seamless experience for users to enjoy and share jokes.


## Features

- 🎯 Clean and modern Material Design UI
- 🌐 Online and offline support
- 💾 Local caching of jokes
- ❤️ Like/favorite functionality
- 📤 Share jokes with friends
- 🎨 Smooth animations and transitions
- 📱 Responsive design
- 🌙 Error handling and user feedback

## Prerequisites

Before you begin, ensure you have the following installed:
- Flutter (2.0.0 or higher)
- Dart (2.12.0 or higher)
- An IDE (VS Code, Android Studio, or IntelliJ)

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  shared_preferences: ^2.2.0
  connectivity_plus: ^5.0.0
```

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/daily-laughs.git
```

2. Navigate to the project directory:
```bash
cd daily-laughs
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart               # App entry point
├── screens/
│   └── jokes_screen.dart   # Main jokes screen
├── models/
│   └── joke.dart          # Joke data model
├── services/
│   ├── api_service.dart    # API handling
│   └── storage_service.dart # Local storage handling
└── widgets/
    └── joke_card.dart     # Reusable joke card widget
```

## API Integration

The app uses the [JokeAPI](https://v2.jokeapi.dev/) to fetch jokes. The API endpoint used is:
```
https://v2.jokeapi.dev/joke/Any?amount=5
```

## Key Components

### JokesApp
The main application widget that sets up the MaterialApp and defines the global theme.

### JokesScreen
The main screen of the app that handles:
- Joke fetching and display
- Offline mode management
- Animation controls
- User interactions (like, share)

### Features Implementation

#### Offline Support
The app uses the `connectivity_plus` package to detect network status and provide offline support. When offline, the app displays a message and allows users to retry fetching jokes.




## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

- [JokeAPI](https://v2.jokeapi.dev/) for providing the jokes API
- Flutter team for the amazing framework
- Contributors and maintainers

## Support

For support, email support@dailylaughs.com or create an issue in the repository.

## Future Enhancements

- [ ] Dark mode support
- [ ] Multiple joke categories
- [ ] Favorite jokes collection
- [ ] Social sharing integrations
- [ ] User accounts and preferences
- [ ] Custom joke submissions

## Performance Considerations

The app implements several performance optimizations:
- Efficient joke caching
- Minimal rebuilds using proper state management
- Optimized animations
- Lazy loading of resources

## Troubleshooting

Common issues and their solutions:

1. **App shows offline mode constantly**
    - Check your internet connection
    - Ensure permissions are granted
    - Restart the app

2. **Jokes not loading**
    - Check your internet connection
    - Verify API status at [JokeAPI Status](https://v2.jokeapi.dev/status)
    - Clear app cache and try again

## Security

The app implements several security measures:
- HTTPS API calls
- Secure storage of cached data
- Input sanitization
- No sensitive data collection

Feel free to contact us for any questions or suggestions!