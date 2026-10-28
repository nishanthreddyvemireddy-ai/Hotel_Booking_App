
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

// Provider manages favorite hotels and notifies listening widgets.
class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteNames = {};

  bool isFavorite(Hotel hotel) => _favoriteNames.contains(hotel.name);

  List<Hotel> get favoriteHotels =>
      hotels.where((hotel) => _favoriteNames.contains(hotel.name)).toList();

  void toggleFavorite(Hotel hotel) {
    if (!_favoriteNames.add(hotel.name)) {
      _favoriteNames.remove(hotel.name);
    }
    notifyListeners();
  }
}

class StayEaseApp extends StatelessWidget {
  const StayEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StayEase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}

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
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            label: 'Favorites',
          ),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StayEase'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Find your perfect stay',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Explore hotels for your next trip.'),
          const SizedBox(height: 20),
          const Text(
            'Popular hotels',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...hotels.map((hotel) => HotelCard(hotel: hotel)),
        ],
      ),
    );
  }
}

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
      appBar: AppBar(title: const Text('Search Hotels')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => setState(() => searchText = value),
              decoration: InputDecoration(
                hintText: 'Search by hotel or location',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('${filteredHotels.length} hotels found'),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filteredHotels.isEmpty
                  ? const Center(child: Text('No hotels found.'))
                  : ListView.builder(
                      itemCount: filteredHotels.length,
                      itemBuilder: (_, index) =>
                          HotelCard(hotel: filteredHotels[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class HotelCard extends StatelessWidget {
  final Hotel hotel;

  const HotelCard({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoritesProvider, bool>(
      (provider) => provider.isFavorite(hotel),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(hotel.icon, size: 34),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(hotel.location),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      Text(' ${hotel.rating}'),
                    ],
                  ),
                  Text(
                    '₹${hotel.price} / night',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () =>
                  context.read<FavoritesProvider>().toggleFavorite(hotel),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteHotels = context.watch<FavoritesProvider>().favoriteHotels;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Hotels')),
      body: favoriteHotels.isEmpty
          ? const Center(child: Text('No favorites yet. Tap a heart on a hotel.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: favoriteHotels
                  .map((hotel) => HotelCard(hotel: hotel))
                  .toList(),
            ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Icon(Icons.account_circle, size: 100)),
    );
  }
}
