import 'package:flutter/material.dart';

void main() {
  runApp(const EngHasan99App());
}

class EngHasan99App extends StatelessWidget {
  const EngHasan99App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eng_Hasan99',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
    );
  }
}

// ------------------- شاشة تسجيل الدخول -------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> meState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    // التحقق من الإنترنت والدخول (أو الدخول أوفلاين في حال وجود بيانات مسجلة سابقاً)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.storefront, size: 80, color: Colors.green),
                const SizedBox(height: 10),
                const Text('Eng_Hasan99', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const Text('تطبيق محاسبة المواد الغذائية', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'البريد الإلكتروني / رقم الجوال', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'كلمة السر', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  child: const Text('تسجيل الدخول', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------- الشاشة الرئيسية (المخزن والمبيعات) -------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double dollarRate = 15000; // سعر الصرف الافتراضي (يتحدث تلقائياً)
  bool isOnline = true;

  // نموذج بيانات للجدول
  List<Map<String, dynamic>> inventory = [
    {"id": 1, "name": "أرز كبسة 1كغ", "category": "بقوليات", "qty": 50, "priceUSD": 2.5},
    {"id": 2, "name": "زيت قالي 1ليتر", "category": "زيوت", "qty": 30, "priceUSD": 1.8},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  double calculateCapitalUSD() {
    return inventory.fold(0, (sum, item) => sum + (item['qty'] * item['priceUSD']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eng_Hasan99'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.inventory), text: 'المخزن والموجودات'),
            Tab(icon: Icon(Icons.point_of_sale), text: 'المبيعات اليومية'),
          ],
        ),
      ),
      body: Column(
        children: [
          // شريط سعر الصرف ورأس المال
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.green.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('سعر الصرف: $dollarRate ل.س', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('رأس المال: ${calculateCapitalUSD().toStringAsFixed(1)} \$ (${(calculateCapitalUSD() * dollarRate).toStringAsFixed(0)} ل.س)',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInventoryExcelSheet(),
                _buildSalesSheet(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  // واجهة الجدول التفاعلي للمخزن (Excel-like UI)
  Widget _buildInventoryExcelSheet() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('المادة')),
            DataColumn(label: Text('النوع')),
            DataColumn(label: Text('الكمية')),
            DataColumn(label: Text('السعر (\$)')),
            DataColumn(label: Text('السعر (ل.س)')),
          ],
          rows: inventory.map((item) {
            double priceSYP = item['priceUSD'] * dollarRate;
            return DataRow(cells: [
              DataCell(Text(item['name'])),
              DataCell(Text(item['category'])),
              DataCell(Text(item['qty'].toString())),
              DataCell(Text('\$${item['priceUSD']}')),
              DataCell(Text('$priceSYP ل.س', style: const TextStyle(fontWeight: FontWeight.bold))),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSalesSheet() {
    return const Center(
      child: Text('جدول المبيعات وحساب الأرباح اليومية'),
    );
  }
}
