import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BottomNav Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});
  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  // نعرّف الصفحات هنا (ثابتة كي لا تُعاد انشاؤها عند التبديل)
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      HomePage(),    // الصفحة الرئيسية (TextFields + زر)
      SearchPage(),  // صفحة البحث (ListView)
      SettingsPage(),// صفحة الإعدادات
      AccountPage(), // صفحة الحساب
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        centerTitle: true,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'بحث'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'إعدادات'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الحساب'),
        ],
      ),
    );
  }
}

/* --------------------- Home Page --------------------- */
/* حقل نص أول + زر يطبع/ينسخ القيمة في الحقل الثاني */
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  void _copyText() {
    // نستخدم setState فقط إن أردنا تحديث واجهة تظهر تغيير؛ هنا نكتب مباشرة في controller
    _controller2.text = _controller1.text;
    // لإظهار رسالة تأكيد سريعة:
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('نُسِخ النص إلى الحقل الثاني')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // استخدام Scroll عند شاشات صغيرة
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          TextField(
            controller: _controller1,
            decoration: const InputDecoration(
              labelText: 'الحقل الأول',
              hintText: 'اكتب نص هنا',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _copyText,
                  icon: const Icon(Icons.copy),
                  label: const Text('انسخ إلى الحقل الثاني'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller2,
            decoration: const InputDecoration(
              labelText: 'الحقل الثاني',
              hintText: 'ستظهر هنا قيمة الحقل الأول بعد النسخ',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

/* --------------------- Search Page --------------------- */
/* ListView مع عدة عناصر ListTile */
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة أمثلة — تستطيع تعديلها أو جلبها من مصدر خارجي
    final List<String> items = List.generate(20, (i) => 'عنصر رقم ${i + 1}');

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text(items[index]),
          subtitle: const Text('وصف مختصر للعناصر'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // مثال: عند الضغط نعرض مربع حوار صغير
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(items[index]),
                content: Text('أنت ضغطت على ${items[index]}.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق'))
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/* --------------------- Settings Page --------------------- */
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const SizedBox(height: 8),
        const Text('الإعدادات', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('الإشعارات'),
          value: _notifications,
          onChanged: (v) => setState(() => _notifications = v),
        ),
        SwitchListTile(
          title: const Text('وضع داكن'),
          value: _darkMode,
          onChanged: (v) => setState(() => _darkMode = v),
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('عن التطبيق'),
          subtitle: const Text('نسخة تجريبية'),
          onTap: () => showAboutDialog(
            context: context,
            applicationName: 'BottomNav Demo',
            applicationVersion: '1.0.0',
            children: const [Text('مثال لتكليف الصفحات الأربعة')],
          ),
        ),
      ],
    );
  }
}

/* --------------------- Account Page --------------------- */
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 48)),
            const SizedBox(height: 12),
            const Text('اسم المستخدم', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('khamisnumber(9)@gmail.com'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تسجيل الخروج (مثال)')));
              },
              icon: const Icon(Icons.logout),
              label: const Text('تسجيل الخروج'),
            ),
          ],
        ),
      ),
    );
  }
}
