import 'package:flutter/material.dart';

void main() {
  runApp(const BakeryApp());
}

class BakeryItem {
  const BakeryItem({
    required this.name,
    required this.category,
    required this.price,
    required this.tagline,
    required this.description,
  });

  final String name;
  final String category;
  final int price;
  final String tagline;
  final String description;
}

class BasketEntry {
  const BasketEntry({required this.item, required this.quantity});

  final BakeryItem item;
  final int quantity;

  int get lineTotal => item.price * quantity;

  BasketEntry copyWith({int? quantity}) {
    return BasketEntry(item: item, quantity: quantity ?? this.quantity);
  }
}

class ChatMessage {
  const ChatMessage({required this.fromUser, required this.text});

  final bool fromUser;
  final String text;
}

class BakeryApp extends StatelessWidget {
  const BakeryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasty Bakery and Pastries',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7A4A2A)),
        scaffoldBackgroundColor: const Color(0xFFF6F0E8),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 44, fontWeight: FontWeight.w800),
          headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          bodyLarge: TextStyle(fontSize: 16, height: 1.45),
        ),
      ),
      home: const BakeryHomePage(),
    );
  }
}

class BakeryHomePage extends StatefulWidget {
  const BakeryHomePage({super.key});

  @override
  State<BakeryHomePage> createState() => _BakeryHomePageState();
}

class _BakeryHomePageState extends State<BakeryHomePage> {
  static const _allItems = <BakeryItem>[
    BakeryItem(
      name: 'Butter layered croissants',
      category: 'pastry',
      price: 300,
      tagline: 'Flaky, golden, and baked in small batches.',
      description:
          'Best for breakfast and tea time. Baked fresh throughout the day.',
    ),
    BakeryItem(
      name: 'Chocolate puff',
      category: 'pastry',
      price: 220,
      tagline: 'Crisp shell with a rich cocoa center.',
      description:
          'A quick sweet treat that pairs well with coffee and cold milk.',
    ),
    BakeryItem(
      name: 'Red velvet cake',
      category: 'cake',
      price: 4200,
      tagline: 'Velvety layers with cream cheese frosting.',
      description:
          'Popular for birthdays, anniversaries, and celebration orders.',
    ),
    BakeryItem(
      name: 'Chocolate celebration cake',
      category: 'cake',
      price: 5200,
      tagline: 'Dense chocolate sponge with smooth ganache.',
      description: 'A rich option for party tables and custom message toppers.',
    ),
    BakeryItem(
      name: 'Vanilla sponge cake',
      category: 'cake',
      price: 3600,
      tagline: 'Soft sponge with a light buttercream finish.',
      description:
          'Simple, elegant, and easy to customize with fruit or writing.',
    ),
    BakeryItem(
      name: 'Cheese danish',
      category: 'pastry',
      price: 260,
      tagline: 'Creamy center with a crisp, glossy crust.',
      description: 'A bakery counter favorite for grab-and-go snacking.',
    ),
  ];

  final List<BasketEntry> _basket = [];
  final List<String> _log = [];
  final TextEditingController _chatController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _category = 'all';
  bool _chatOpen = false;
  String _fulfillment = 'pickup';
  DateTime _dueTime = DateTime.now().add(const Duration(hours: 4));

  @override
  void initState() {
    super.initState();
    _log.add(
      'Hello. I can help with categories, prices, cart orders, and delivery timing.',
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  List<BakeryItem> get _visibleItems {
    if (_category == 'all') {
      return _allItems;
    }
    return _allItems.where((item) => item.category == _category).toList();
  }

  int get _itemCount =>
      _basket.fold<int>(0, (sum, entry) => sum + entry.quantity);

  int get _subtotal =>
      _basket.fold<int>(0, (sum, entry) => sum + entry.lineTotal);

  int get _deliveryFee =>
      _fulfillment == 'delivery' && _basket.isNotEmpty ? 450 : 0;

  int get _grandTotal => _subtotal + _deliveryFee;

  void _addItem(BakeryItem item) {
    setState(() {
      final index = _basket.indexWhere((entry) => entry.item.name == item.name);
      if (index == -1) {
        _basket.add(BasketEntry(item: item, quantity: 1));
      } else {
        _basket[index] = _basket[index].copyWith(
          quantity: _basket[index].quantity + 1,
        );
      }
    });
  }

  void _changeQuantity(BakeryItem item, int delta) {
    setState(() {
      final index = _basket.indexWhere((entry) => entry.item.name == item.name);
      if (index == -1) {
        return;
      }
      final updated = _basket[index].quantity + delta;
      if (updated <= 0) {
        _basket.removeAt(index);
      } else {
        _basket[index] = _basket[index].copyWith(quantity: updated);
      }
    });
  }

  void _clearBasket() {
    setState(() {
      _basket.clear();
    });
  }

  void _sendChat(String rawInput) {
    final input = rawInput.trim();
    if (input.isEmpty) {
      return;
    }

    setState(() {
      _log.add('You: $input');
      final lower = input.toLowerCase();

      if (lower.contains('cake categories')) {
        _log.add(
          'Assistant: Cake categories include red velvet cake, chocolate celebration cake, and vanilla sponge cake.',
        );
      } else if (lower.contains('pastry categories')) {
        _log.add(
          'Assistant: Pastry categories include croissants, chocolate puffs, and cheese danish.',
        );
      } else if (lower.contains('delivery') && lower.contains('fee')) {
        _log.add(
          'Assistant: Delivery fee is Rs. 450 for local delivery. Pickup is free.',
        );
      } else if (lower.contains('do you deliver')) {
        _log.add(
          'Assistant: Yes. Local delivery is available with a small fee.',
        );
      } else if (lower.startsWith('add ')) {
        final item = _matchItem(lower);
        if (item == null) {
          _log.add(
            'Assistant: I could not find that item. Try chocolate puff or red velvet cake.',
          );
        } else {
          _addItem(item);
          _log.add('Assistant: Added ${item.name} to the cart.');
        }
      } else if (lower.contains('recommend')) {
        _log.add(
          'Assistant: Try the chocolate celebration cake for parties or croissants for snacks.',
        );
      } else {
        _log.add(
          'Assistant: I can show categories, explain delivery, or add an item to the cart.',
        );
      }
    });

    _chatController.clear();
  }

  BakeryItem? _matchItem(String input) {
    for (final item in _allItems) {
      if (input.contains(item.name.toLowerCase())) {
        return item;
      }
    }
    if (input.contains('chocolate puff')) {
      return _allItems.firstWhere((item) => item.name == 'Chocolate puff');
    }
    if (input.contains('red velvet')) {
      return _allItems.firstWhere((item) => item.name == 'Red velvet cake');
    }
    return null;
  }

  Future<void> _pickDueTime() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (selectedDate == null || !mounted) {
      return;
    }
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueTime),
    );
    if (selectedTime == null || !mounted) {
      return;
    }
    setState(() {
      _dueTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    });
  }

  Future<void> _showConfirmation() async {
    final summary = _buildSummary();
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Order confirmation'),
          content: SingleChildScrollView(child: Text(summary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _buildSummary() {
    final buffer = StringBuffer();
    buffer.writeln(
      'Customer: ${_nameController.text.trim().isEmpty ? 'Guest customer' : _nameController.text.trim()}',
    );
    buffer.writeln(
      'Phone: ${_phoneController.text.trim().isEmpty ? 'Not provided' : _phoneController.text.trim()}',
    );
    buffer.writeln('Fulfillment: $_fulfillment');
    buffer.writeln('Needed by: ${_dueTime.toLocal()}');
    if (_addressController.text.trim().isNotEmpty) {
      buffer.writeln('Address / note: ${_addressController.text.trim()}');
    }
    if (_noteController.text.trim().isNotEmpty) {
      buffer.writeln('Special instructions: ${_noteController.text.trim()}');
    }
    buffer.writeln('');
    buffer.writeln('Items:');
    for (final entry in _basket) {
      buffer.writeln(
        '- ${entry.item.name} x${entry.quantity} = Rs. ${entry.lineTotal}',
      );
    }
    buffer.writeln('Subtotal: Rs. $_subtotal');
    buffer.writeln('Delivery fee: Rs. $_deliveryFee');
    buffer.writeln('Total: Rs. $_grandTotal');
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 980;

    return Scaffold(
      body: Stack(
        children: [
          const _DecorativeBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TopBar(
                        itemCount: _itemCount,
                        onOpenChat: () => setState(() => _chatOpen = true),
                      ),
                      const SizedBox(height: 20),
                      _HeroSection(
                        onStartOrder: () => Scrollable.ensureVisible(
                          context,
                          duration: const Duration(milliseconds: 250),
                        ),
                        onRecommend: () => _sendChat('recommend'),
                      ),
                      const SizedBox(height: 20),
                      _InfoStrip(isWide: isWide),
                      const SizedBox(height: 20),
                      _SectionHeader(
                        eyebrow: 'Menu',
                        title: 'Cakes and pastries',
                        subtitle:
                            'Filter by category, add items to cart, then review your order below.',
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ChoiceChip(
                            label: const Text('All'),
                            selected: _category == 'all',
                            onSelected: (_) =>
                                setState(() => _category = 'all'),
                          ),
                          ChoiceChip(
                            label: const Text('Cake categories'),
                            selected: _category == 'cake',
                            onSelected: (_) =>
                                setState(() => _category = 'cake'),
                          ),
                          ChoiceChip(
                            label: const Text('Pastry categories'),
                            selected: _category == 'pastry',
                            onSelected: (_) =>
                                setState(() => _category = 'pastry'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount = constraints.maxWidth >= 1050
                              ? 3
                              : constraints.maxWidth >= 700
                              ? 2
                              : 1;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _visibleItems.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                  childAspectRatio: 0.78,
                                ),
                            itemBuilder: (context, index) {
                              final item = _visibleItems[index];
                              return _MenuCard(
                                item: item,
                                onAdd: () => _addItem(item),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _SectionHeader(
                        eyebrow: 'Order',
                        title: 'Build your order',
                        subtitle:
                            'Live totals update as you add items. The confirmation is generated on the page.',
                      ),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final showTwoColumns = constraints.maxWidth >= 960;
                          final summary = _OrderSummary(
                            basket: _basket,
                            subtotal: _subtotal,
                            deliveryFee: _deliveryFee,
                            grandTotal: _grandTotal,
                            onIncrease: (item) => _changeQuantity(item, 1),
                            onDecrease: (item) => _changeQuantity(item, -1),
                            onClear: _clearBasket,
                          );

                          final form = _OrderForm(
                            nameController: _nameController,
                            phoneController: _phoneController,
                            addressController: _addressController,
                            noteController: _noteController,
                            fulfillment: _fulfillment,
                            dueTime: _dueTime,
                            onChangeFulfillment: (value) =>
                                setState(() => _fulfillment = value),
                            onPickDueTime: _pickDueTime,
                            onSubmit: _showConfirmation,
                            summaryText: _buildSummary(),
                          );

                          if (!showTwoColumns) {
                            return Column(
                              children: [
                                form,
                                const SizedBox(height: 16),
                                summary,
                              ],
                            );
                          }

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: form),
                              const SizedBox(width: 16),
                              Expanded(child: summary),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _SectionHeader(
                        eyebrow: 'Chatbot',
                        title: 'Ask the order assistant',
                        subtitle:
                            'Get instant answers about menu items, prices, delivery, allergens, and order timing.',
                      ),
                      const SizedBox(height: 12),
                      _AssistantCallout(
                        onOpenChat: () => setState(() => _chatOpen = true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_chatOpen)
            _ChatOverlay(
              log: _log,
              controller: _chatController,
              onClose: () => setState(() => _chatOpen = false),
              onSend: _sendChat,
              onQuickAction: _sendChat,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _chatOpen = true),
        label: const Text('Chat for orders'),
        icon: const Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}

class _DecorativeBackground extends StatelessWidget {
  const _DecorativeBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: const [
          Positioned(
            top: -40,
            right: -60,
            child: _Aura(size: 220, color: Color(0xFFF0C6A1)),
          ),
          Positioned(
            top: 220,
            left: -70,
            child: _Aura(size: 160, color: Color(0xFFE9D2B0)),
          ),
        ],
      ),
    );
  }
}

class _Aura extends StatelessWidget {
  const _Aura({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.18),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.itemCount, required this.onOpenChat});

  final int itemCount;
  final VoidCallback onOpenChat;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF7A4A2A),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Center(
            child: Text(
              'TB',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Daily oven-fresh',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Tasty Bakery and Pastries',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
        if (MediaQuery.sizeOf(context).width >= 700) ...[
          TextButton(onPressed: () {}, child: const Text('See menu')),
          const SizedBox(width: 8),
          FilledButton.tonal(
            onPressed: onOpenChat,
            child: const Text('Order now'),
          ),
          const SizedBox(width: 8),
        ],
        Badge(
          label: Text('$itemCount'),
          child: IconButton(
            tooltip: 'Cart',
            onPressed: onOpenChat,
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.onStartOrder, required this.onRecommend});

  final VoidCallback onStartOrder;
  final VoidCallback onRecommend;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 960;
        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hand-finished pastries and custom celebration cakes',
              style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.2),
            ),
            const SizedBox(height: 10),
            Text(
              'Order cakes and pastries with one click.',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 14),
            const Text(
              'Browse cake and pastry categories, add products to cart, and chat with our assistant to place faster orders.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: onStartOrder,
                  child: const Text('Start an order'),
                ),
                OutlinedButton(
                  onPressed: onRecommend,
                  child: const Text('Ask for recommendations'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                _StatChip(value: '8', label: 'Bakery picks'),
                _StatChip(value: '35 min', label: 'Local delivery window'),
                _StatChip(value: '6:30 AM', label: 'Fresh batch starts'),
              ],
            ),
          ],
        );

        final card = Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 24,
                offset: Offset(0, 14),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset(
                  'assets/images/bakery.png',
                  height: 260,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 260,
                      color: const Color(0xFFF4E6D8),
                      alignment: Alignment.center,
                      child: const Text('Bakery image'),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Today\'s special',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Butter layered croissants',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                'Flaky, golden, and baked in small batches throughout the day.',
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _Pill(text: 'Rs. 300 each'),
                  _Pill(text: 'Best before 8 PM'),
                ],
              ),
            ],
          ),
        );

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: content),
              const SizedBox(width: 20),
              Expanded(child: card),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [content, const SizedBox(height: 18), card],
        );
      },
    );
  }
}

class _InfoStrip extends StatelessWidget {
  const _InfoStrip({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final cards = const [
      _InfoCard(
        title: 'Category-first menu',
        body: 'Every item shows price, portion, and ingredient highlights.',
      ),
      _InfoCard(
        title: 'Easy add to cart',
        body:
            'Choose quantities, pickup or delivery, and confirm in one place.',
      ),
      _InfoCard(
        title: 'Order chatbot',
        body: 'Get instant details about allergens, timing, and suggestions.',
      ),
    ];

    if (!isWide) {
      return Column(
        children: [
          for (final card in cards) ...[card, const SizedBox(height: 12)],
        ],
      );
    }

    return Row(
      children: [
        for (final card in cards) ...[
          Expanded(child: card),
          if (card != cards.last) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x1A7A4A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(height: 1.4)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 6),
        Text(subtitle, style: const TextStyle(height: 1.4)),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.item, required this.onAdd});

  final BakeryItem item;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFF4E6D8),
            ),
            child: const Center(
              child: Icon(
                Icons.cake_outlined,
                size: 68,
                color: Color(0xFF7A4A2A),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            item.tagline,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(item.name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(item.description, style: const TextStyle(height: 1.4)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Rs. ${item.price}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              FilledButton(onPressed: onAdd, child: const Text('Add to cart')),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderForm extends StatelessWidget {
  const _OrderForm({
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.noteController,
    required this.fulfillment,
    required this.dueTime,
    required this.onChangeFulfillment,
    required this.onPickDueTime,
    required this.onSubmit,
    required this.summaryText,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController noteController;
  final String fulfillment;
  final DateTime dueTime;
  final ValueChanged<String> onChangeFulfillment;
  final VoidCallback onPickDueTime;
  final VoidCallback onSubmit;
  final String summaryText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Field(
            label: 'Full name',
            controller: nameController,
            hintText: 'Nadeesha Perera',
          ),
          const SizedBox(height: 12),
          _Field(
            label: 'Phone number',
            controller: phoneController,
            hintText: '077 123 4567',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: fulfillment,
            decoration: const InputDecoration(
              labelText: 'Fulfillment',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'pickup', child: Text('Store pickup')),
              DropdownMenuItem(
                value: 'delivery',
                child: Text('Local delivery'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                onChangeFulfillment(value);
              }
            },
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onPickDueTime,
            icon: const Icon(Icons.schedule),
            label: Text('Needed by: ${_formatDateTime(dueTime)}'),
          ),
          const SizedBox(height: 12),
          _Field(
            label: 'Delivery or pickup note',
            controller: addressController,
            hintText: 'Pickup at Union Place or deliver to 24 Flower Rd',
          ),
          const SizedBox(height: 12),
          _Field(
            label: 'Special instructions',
            controller: noteController,
            hintText:
                'Add candle request, message on cake, less sugar preference',
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton(
                onPressed: onSubmit,
                child: const Text('Generate order confirmation'),
              ),
              OutlinedButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Order summary'),
                    content: SingleChildScrollView(child: Text(summaryText)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
                child: const Text('Preview summary'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final suffix = local.hour >= 12 ? 'PM' : 'AM';
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} $hour:$minute $suffix';
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    required this.basket,
    required this.subtotal,
    required this.deliveryFee,
    required this.grandTotal,
    required this.onIncrease,
    required this.onDecrease,
    required this.onClear,
  });

  final List<BasketEntry> basket;
  final int subtotal;
  final int deliveryFee;
  final int grandTotal;
  final ValueChanged<BakeryItem> onIncrease;
  final ValueChanged<BakeryItem> onDecrease;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Cart',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              Text(
                '${basket.fold<int>(0, (sum, entry) => sum + entry.quantity)} items',
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (basket.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Your cart is empty. Add bakery items from the menu first.',
              ),
            )
          else
            ...basket.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F4EE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('Rs. ${entry.item.price} each'),
                            const SizedBox(height: 6),
                            Text('Line total: Rs. ${entry.lineTotal}'),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () => onIncrease(entry.item),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                          Text(
                            '${entry.quantity}',
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          IconButton(
                            onPressed: () => onDecrease(entry.item),
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const Divider(height: 24),
          _SummaryRow(label: 'Subtotal', value: 'Rs. $subtotal'),
          _SummaryRow(label: 'Delivery fee', value: 'Rs. $deliveryFee'),
          _SummaryRow(label: 'Total', value: 'Rs. $grandTotal', bold: true),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: onClear, child: const Text('Clear order')),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.w900 : FontWeight.w600,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _AssistantCallout extends StatelessWidget {
  const _AssistantCallout({required this.onOpenChat});

  final VoidCallback onOpenChat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF7A4A2A),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ordering support in one click',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Try: "Show cake categories", "Add 2 chocolate puffs", or "Do you deliver?"',
                  style: TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonal(
            onPressed: onOpenChat,
            child: const Text('Open chat'),
          ),
        ],
      ),
    );
  }
}

class _ChatOverlay extends StatelessWidget {
  const _ChatOverlay({
    required this.log,
    required this.controller,
    required this.onClose,
    required this.onSend,
    required this.onQuickAction,
  });

  final List<String> log;
  final TextEditingController controller;
  final VoidCallback onClose;
  final ValueChanged<String> onSend;
  final ValueChanged<String> onQuickAction;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.black54,
        child: SafeArea(
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.sizeOf(context).width >= 720
                  ? 420
                  : double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chatbot',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Order assistant',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: onClose,
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ActionChip(
                          label: const Text('Cake categories'),
                          onPressed: () =>
                              onQuickAction('Show cake categories'),
                        ),
                        ActionChip(
                          label: const Text('Pastry categories'),
                          onPressed: () =>
                              onQuickAction('Show pastry categories'),
                        ),
                        ActionChip(
                          label: const Text('Quick order'),
                          onPressed: () =>
                              onQuickAction('Add 2 chocolate puffs'),
                        ),
                        ActionChip(
                          label: const Text('Delivery fee'),
                          onPressed: () =>
                              onQuickAction('How much is delivery?'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: log.length,
                      itemBuilder: (context, index) {
                        final line = log[index];
                        final fromUser = line.startsWith('You:');
                        return Align(
                          alignment: fromUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: fromUser
                                  ? const Color(0xFF7A4A2A)
                                  : const Color(0xFFF6F0E8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              line
                                  .replaceFirst('You: ', '')
                                  .replaceFirst('Assistant: ', ''),
                              style: TextStyle(
                                color: fromUser ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText:
                                  'Ask about categories, prices, or say: Add 1 red velvet cake',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: onSend,
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () => onSend(controller.text),
                          child: const Text('Send'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x1A7A4A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4E6D8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
