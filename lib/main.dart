
import 'package:flutter/material.dart';

void main() {
  runApp(const StayEaseApp());
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StayEase'),
        centerTitle: true,
      ),
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
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
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
                  ? const Center(child: Text('No hotels found. Try another search.'))
                  : ListView.builder(
                      itemCount: filteredHotels.length,
                      itemBuilder: (context, index) {
                        return HotelCard(hotel: filteredHotels[index]);
                      },
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
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                hotel.icon,
                size: 36,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(hotel.location),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 17, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(hotel.rating.toString()),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '₹${hotel.price} / night',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: const Center(
        child: Text('Your favorite hotels will appear here.'),
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
      body: const Center(
        child: Icon(Icons.account_circle, size: 100),
      ),
    );
  }
}
