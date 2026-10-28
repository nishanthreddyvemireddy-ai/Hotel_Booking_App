
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  final double price;
  final double rating;
  final String image;
  final int id;

  const Hotel({
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.image,
    required this.id,
  });
}

final List<Hotel> hotels = [
  const Hotel(
    id: 1,
    name: 'Taj Falaknuma Palace',
    location: 'Hyderabad',
    price: 12000,
    rating: 4.9,
    image: 'https://picsum.photos/id/164/600/400',
  ),
  const Hotel(
    id: 2,
    name: 'ITC Kohenur',
    location: 'HITEC City, Hyderabad',
    price: 8500,
    rating: 4.8,
    image: 'https://picsum.photos/id/1040/600/400',
  ),
  const Hotel(
    id: 3,
    name: 'Novotel Hyderabad',
    location: 'HITEC City, Hyderabad',
    price: 6500,
    rating: 4.5,
    image: 'https://picsum.photos/id/1018/600/400',
  ),
  const Hotel(
    id: 4,
    name: 'Trident Hyderabad',
    location: 'Madhapur, Hyderabad',
    price: 7800,
    rating: 4.7,
    image: 'https://picsum.photos/id/1031/600/400',
  ),
];

class FavoritesProvider extends ChangeNotifier {
  final Set<int> _favorites = {};

  Set<int> get favorites => _favorites;

  bool isFavorite(int id) => _favorites.contains(id);

  void toggleFavorite(int id) {
    if (!_favorites.add(id)) {
      _favorites.remove(id);
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
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        cardTheme: const CardThemeData(
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
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
    ApiPage(),
    FavoritesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.hotel_outlined),
            selectedIcon: Icon(Icons.hotel),
            label: 'Hotels',
          ),
          NavigationDestination(
            icon: Icon(Icons.cloud_download_outlined),
            selectedIcon: Icon(Icons.cloud_download),
            label: 'API Demo',
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filteredHotels = hotels.where((hotel) {
      return hotel.name.toLowerCase().contains(search.toLowerCase()) ||
          hotel.location.toLowerCase().contains(search.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('StayEase Hotels'),
        actions: [
          IconButton(
            tooltip: 'Book a hotel',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BookingPage()),
            ),
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => search = value),
              decoration: InputDecoration(
                hintText: 'Search hotels or locations',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Popular hotels',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: filteredHotels.isEmpty
                ? const Center(child: Text('No hotels found'))
                : ListView.builder(
                    itemCount: filteredHotels.length,
                    itemBuilder: (context, index) {
                      return HotelCard(hotel: filteredHotels[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class HotelCard extends StatelessWidget {
  final Hotel hotel;

  const HotelCard({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final favorite = context.watch<FavoritesProvider>().isFavorite(hotel.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            hotel.image,
            height: 170,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 170,
              color: Colors.teal.shade50,
              child: const Center(
                child: Icon(Icons.hotel, size: 60, color: Colors.teal),
              ),
            ),
          ),
          ListTile(
            title: Text(
              hotel.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${hotel.location}\n₹${hotel.price.toStringAsFixed(0)} / night'),
            isThreeLine: true,
            trailing: IconButton(
              tooltip: 'Toggle favorite',
              icon: Icon(
                favorite ? Icons.favorite : Icons.favorite_border,
                color: favorite ? Colors.red : null,
              ),
              onPressed: () => context
                  .read<FavoritesProvider>()
                  .toggleFavorite(hotel.id),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 5),
                Text('${hotel.rating} rating'),
                const Spacer(),
                FilledButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingPage(hotel: hotel),
                    ),
                  ),
                  child: const Text('Book now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Experiment 9: Fetch REST API data and display it in the UI.
class ApiPage extends StatefulWidget {
  const ApiPage({super.key});

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  late Future<List<Map<String, dynamic>>> postsFuture;

  @override
  void initState() {
    super.initState();
    postsFuture = fetchPosts();
  }

  Future<List<Map<String, dynamic>>> fetchPosts() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=10'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }

    throw Exception('Failed to load API data: ${response.statusCode}');
  }

  void retry() {
    setState(() {
      postsFuture = fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REST API Demo'),
        actions: [
          IconButton(
            tooltip: 'Refresh data',
            onPressed: retry,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Fetching data from REST API...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 55, color: Colors.red),
                    const SizedBox(height: 12),
                    const Text(
                      'Could not load API data.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return const Center(child: Text('No API data available.'));
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Card(
                color: Colors.teal.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live REST API Request',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Data is requested from JSONPlaceholder and displayed below.',
                      ),
                      SizedBox(height: 8),
                      SelectableText(
                        'GET https://jsonplaceholder.typicode.com/posts',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${posts.length} posts fetched successfully',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...posts.map((post) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      child: Text('${post['id']}'),
                    ),
                    title: Text(
                      '${post['title']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('${post['body']}'),
                    ),
                    isThreeLine: true,
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoritesProvider>();
    final favoriteHotels = hotels
        .where((hotel) => provider.isFavorite(hotel.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Hotels')),
      body: favoriteHotels.isEmpty
          ? const Center(
              child: Text(
                'No favorites yet.\nAdd hotels using the heart icon.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: favoriteHotels.length,
              itemBuilder: (context, index) {
                return HotelCard(hotel: favoriteHotels[index]);
              },
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 42,
              child: Icon(Icons.person, size: 48),
            ),
            SizedBox(height: 16),
            Text(
              'StayEase Guest',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Welcome to StayEase!'),
          ],
        ),
      ),
    );
  }
}

class BookingPage extends StatefulWidget {
  final Hotel? hotel;

  const BookingPage({super.key, this.hotel});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  String? selectedHotel;
  DateTime? checkInDate;
  int guests = 1;

  @override
  void initState() {
    super.initState();
    selectedHotel = widget.hotel?.name;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> chooseDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: checkInDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => checkInDate = picked);
    }
  }

  void submitBooking() {
    if (!formKey.currentState!.validate()) return;

    if (checkInDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a check-in date')),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking submitted'),
        content: Text(
          'Guest: ${nameController.text}\n'
          'Hotel: $selectedHotel\n'
          'Guests: $guests\n'
          'Check-in: ${checkInDate!.day}/${checkInDate!.month}/${checkInDate!.year}\n\n'
          'This is a demo booking. No real reservation was made.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hotel Booking Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Book your stay',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Guest name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter your name'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(value.trim())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedHotel,
                decoration: const InputDecoration(
                  labelText: 'Select hotel',
                  border: OutlineInputBorder(),
                ),
                items: hotels
                    .map(
                      (hotel) => DropdownMenuItem(
                        value: hotel.name,
                        child: Text(
                          hotel.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => selectedHotel = value),
                validator: (value) =>
                    value == null ? 'Select a hotel' : null,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: chooseDate,
                icon: const Icon(Icons.calendar_month),
                label: Text(
                  checkInDate == null
                      ? 'Choose check-in date'
                      : 'Check-in: ${checkInDate!.day}/${checkInDate!.month}/${checkInDate!.year}',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Guests', style: TextStyle(fontSize: 16)),
                  const Spacer(),
                  IconButton(
                    onPressed: guests > 1
                        ? () => setState(() => guests--)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('$guests'),
                  IconButton(
                    onPressed: guests < 10
                        ? () => setState(() => guests++)
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: submitBooking,
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Text('Submit booking'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
