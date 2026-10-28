
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoritesProvider(),
      child: const StayEaseApp(),
    ),
  );
}

// -------------------- HOTEL MODEL --------------------

class Hotel {
  final String name;
  final String location;
  final double rating;
  final int price;
  final IconData icon;

  const Hotel({
    required this.name,
    required this.location,
    required this.rating,
    required this.price,
    required this.icon,
  });
}

const List<Hotel> hotels = [
  Hotel(
    name: 'Taj Falaknuma Palace',
    location: 'Hyderabad',
    rating: 4.8,
    price: 12500,
    icon: Icons.castle,
  ),
  Hotel(
    name: 'ITC Kohenur',
    location: 'HITEC City, Hyderabad',
    rating: 4.7,
    price: 9800,
    icon: Icons.apartment,
  ),
  Hotel(
    name: 'Novotel Hyderabad',
    location: 'Gachibowli, Hyderabad',
    rating: 4.5,
    price: 7200,
    icon: Icons.hotel,
  ),
  Hotel(
    name: 'Trident Hyderabad',
    location: 'HITEC City, Hyderabad',
    rating: 4.6,
    price: 8900,
    icon: Icons.business,
  ),
];

// -------------------- PROVIDER STATE --------------------

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteNames = {};

  bool isFavorite(Hotel hotel) => _favoriteNames.contains(hotel.name);

  List<Hotel> get favoriteHotels =>
      hotels.where((hotel) => _favoriteNames.contains(hotel.name)).toList();

  void toggleFavorite(Hotel hotel) {
    if (_favoriteNames.contains(hotel.name)) {
      _favoriteNames.remove(hotel.name);
    } else {
      _favoriteNames.add(hotel.name);
    }

    notifyListeners();
  }
}

// -------------------- APP THEME --------------------

class StayEaseApp extends StatelessWidget {
  const StayEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3949AB);

    return MaterialApp(
      title: 'StayEase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 13,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

// -------------------- NAVIGATION --------------------

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    SearchPage(),
    FavoritesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// -------------------- HOME SCREEN --------------------

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StayEase'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Find your perfect stay',
            style: AppStyles.heading,
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore comfortable hotels for your next trip.',
            style: AppStyles.subtitle,
          ),
          const SizedBox(height: 24),
          const Text(
            'Popular Hotels',
            style: AppStyles.sectionTitle,
          ),
          const SizedBox(height: 14),
          ...hotels.map(
            (hotel) => HotelCard(hotel: hotel),
          ),
          const SizedBox(height: 8),
          StayEaseButton(
            text: 'Explore Hotels',
            icon: Icons.explore,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AllHotelsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// -------------------- SEARCH SCREEN --------------------

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final filteredHotels = hotels.where((hotel) {
      final query = searchText.toLowerCase();

      return hotel.name.toLowerCase().contains(query) ||
          hotel.location.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Hotels'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search by hotel or location',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filteredHotels.length} hotels found',
                style: AppStyles.subtitle,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredHotels.isEmpty
                  ? const Center(
                      child: Text('No hotels found. Try another search.'),
                    )
                  : ListView.builder(
                      itemCount: filteredHotels.length,
                      itemBuilder: (context, index) {
                        return HotelCard(
                          hotel: filteredHotels[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- REUSABLE HOTEL CARD --------------------

class HotelCard extends StatelessWidget {
  final Hotel hotel;

  const HotelCard({
    super.key,
    required this.hotel,
  });

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoritesProvider, bool>(
      (provider) => provider.isFavorite(hotel),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                hotel.icon,
                size: 35,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: AppStyles.hotelName,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hotel.location,
                    style: AppStyles.subtitle,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 18,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text('${hotel.rating}'),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '₹${hotel.price} / night',
                    style: AppStyles.price,
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: isFavorite
                  ? 'Remove from favorites'
                  : 'Add to favorites',
              onPressed: () {
                context
                    .read<FavoritesProvider>()
                    .toggleFavorite(hotel);
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- REUSABLE CUSTOM BUTTON --------------------

class StayEaseButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;

  const StayEaseButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon = Icons.arrow_forward,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
    );
  }
}

// -------------------- REUSABLE TEXT STYLES --------------------

class AppStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: Colors.blueGrey,
  );

  static const TextStyle hotelName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle price = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Color(0xFF3949AB),
  );
}

// -------------------- ALL HOTELS SCREEN --------------------

class AllHotelsPage extends StatelessWidget {
  const AllHotelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Hotels'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: hotels.map((hotel) {
          return HotelCard(hotel: hotel);
        }).toList(),
      ),
    );
  }
}

// -------------------- FAVORITES SCREEN --------------------

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteHotels =
        context.watch<FavoritesProvider>().favoriteHotels;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Hotels'),
      ),
      body: favoriteHotels.isEmpty
          ? const Center(
              child: Text(
                'No favorites yet. Tap a heart on a hotel.',
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: favoriteHotels.map((hotel) {
                return HotelCard(hotel: hotel);
              }).toList(),
            ),
    );
  }
}

// -------------------- PROFILE SCREEN --------------------

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 48,
              child: Icon(
                Icons.person,
                size: 55,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to StayEase',
              style: AppStyles.sectionTitle,
            ),
            const SizedBox(height: 8),
            const Text(
              'Your hotel booking companion',
              style: AppStyles.subtitle,
            ),
            const SizedBox(height: 20),
            StayEaseButton(
              text: 'View Favorite Hotels',
              icon: Icons.favorite,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const FavoritesPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
