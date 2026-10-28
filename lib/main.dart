
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

// -------------------- FAVORITES PROVIDER --------------------

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
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
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
            borderRadius: BorderRadius.circular(12),
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

// -------------------- HOME PAGE --------------------

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StayEase')),
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
          ...hotels.map((hotel) => HotelCard(hotel: hotel)),
          StayEaseButton(
            text: 'Make a Booking Request',
            icon: Icons.calendar_month,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BookingFormPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// -------------------- SEARCH PAGE --------------------

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
              decoration: const InputDecoration(
                hintText: 'Search by hotel or location',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('${filteredHotels.length} hotels found'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredHotels.isEmpty
                  ? const Center(child: Text('No hotels found.'))
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

// -------------------- CUSTOM HOTEL CARD --------------------

class HotelCard extends StatelessWidget {
  final Hotel hotel;

  const HotelCard({super.key, required this.hotel});

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
                  Text(hotel.name, style: AppStyles.hotelName),
                  const SizedBox(height: 4),
                  Text(hotel.location, style: AppStyles.subtitle),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                      Text(' ${hotel.rating}'),
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
              tooltip: isFavorite ? 'Remove favorite' : 'Add favorite',
              onPressed: () {
                context.read<FavoritesProvider>().toggleFavorite(hotel);
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

// -------------------- CUSTOM BUTTON --------------------

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

// -------------------- CUSTOM TEXT STYLES --------------------

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

// -------------------- BOOKING FORM: EXPERIMENT 7 --------------------

class BookingFormPage extends StatefulWidget {
  const BookingFormPage({super.key});

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedHotel;
  DateTime? _checkInDate;
  int _guestCount = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _chooseDate() async {
    final today = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? today,
      firstDate: DateTime(today.year, today.month, today.day),
      lastDate: DateTime(today.year + 2, today.month, today.day),
    );

    if (pickedDate != null && mounted) {
      setState(() {
        _checkInDate = pickedDate;
      });
    }
  }

  void _submitForm() {
    final isValid = _formKey.currentState!.validate();

    if (_checkInDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a check-in date.'),
        ),
      );
      return;
    }

    if (!isValid) return;

    final guestName = _nameController.text.trim();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Booking Request Submitted'),
          content: Text(
            'Thank you, $guestName!\n\n'
            'Hotel: $_selectedHotel\n'
            'Check-in: ${_checkInDate!.day}/'
            '${_checkInDate!.month}/${_checkInDate!.year}\n'
            'Guests: $_guestCount\n\n'
            'This is a demo confirmation, not a real reservation.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Booking Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Plan Your Stay',
                style: AppStyles.heading,
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your details to submit a booking request.',
                style: AppStyles.subtitle,
              ),
              const SizedBox(height: 24),

              // Guest name
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your full name.';
                  }
                  if (value.trim().length < 3) {
                    return 'Name must contain at least 3 characters.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';
                  final emailPattern =
                      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                  if (email.isEmpty) {
                    return 'Please enter your email address.';
                  }
                  if (!emailPattern.hasMatch(email)) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone number
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                  counterText: '',
                ),
                validator: (value) {
                  final phone = value?.trim() ?? '';

                  if (phone.isEmpty) {
                    return 'Please enter your phone number.';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
                    return 'Enter a valid 10-digit phone number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Hotel dropdown
              DropdownButtonFormField<String>(
                value: _selectedHotel,
                decoration: const InputDecoration(
                  labelText: 'Select Hotel',
                  prefixIcon: Icon(Icons.hotel_outlined),
                ),
                items: hotels.map((hotel) {
                  return DropdownMenuItem<String>(
                    value: hotel.name,
                    child: Text(
                      hotel.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedHotel = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a hotel.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Check-in date
              OutlinedButton.icon(
                onPressed: _chooseDate,
                icon: const Icon(Icons.calendar_month),
                label: Text(
                  _checkInDate == null
                      ? 'Select Check-in Date'
                      : 'Check-in: ${_checkInDate!.day}/'
                          '${_checkInDate!.month}/'
                          '${_checkInDate!.year}',
                ),
              ),
              const SizedBox(height: 20),

              // Number of guests
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.people_outline),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Number of Guests',
                          style: AppStyles.hotelName,
                        ),
                      ),
                      IconButton(
                        onPressed: _guestCount > 1
                            ? () {
                                setState(() {
                                  _guestCount--;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '$_guestCount',
                        style: AppStyles.sectionTitle,
                      ),
                      IconButton(
                        onPressed: _guestCount < 10
                            ? () {
                                setState(() {
                                  _guestCount++;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit
              StayEaseButton(
                text: 'Submit Booking Request',
                icon: Icons.check_circle_outline,
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- FAVORITES PAGE --------------------

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteHotels =
        context.watch<FavoritesProvider>().favoriteHotels;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Hotels')),
      body: favoriteHotels.isEmpty
          ? const Center(
              child: Text('No favorites yet. Tap a heart on a hotel.'),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: favoriteHotels
                  .map((hotel) => HotelCard(hotel: hotel))
                  .toList(),
            ),
    );
  }
}

// -------------------- PROFILE PAGE --------------------

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 48,
                child: Icon(Icons.person, size: 55),
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
                text: 'Make a Booking Request',
                icon: Icons.calendar_month,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BookingFormPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
