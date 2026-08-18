import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist_app/views/editprofile_page.dart';
import 'package:shoppinglist_app/views/widgets/homestat_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      border: Border.all(color: Color(0xFF12B76A), width: 1.5),
                    ),

                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditprofilePage(),
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage('Assets/profile.png'),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Text(
                      'Shopping List App',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Color(0xFF079455),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: isDark ? Colors.white : Color(0xFF079455),
                      size: 24,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              Text(
                'Ready to Shop?',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 5),
              Text(
                'Let’s get your shopping list done.',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),

              SizedBox(height: 35),
              Row(
                children: [
                  Expanded(
                    child: homeStatCard(
                      context: context,
                      icon: Icons.shopping_bag_outlined,
                      title: 'Total Items',
                      value: '24',
                      iconColor: const Color(0xFF3D8B68),
                      iconBg: const Color(0xFFDDF8EC),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: homeStatCard(
                      context: context,

                      icon: Icons.inventory_2_outlined,
                      title: 'Remaining',
                      value: '10',
                      iconColor: Color(0xFFF59E0B),
                      iconBg: Color(0xFFFFEFCF),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: homeStatCard(
                      context: context,

                      icon: Icons.check_circle_outline,
                      title: 'Purchased',
                      value: '10',
                      iconColor: const Color(0xFF3B82F6),
                      iconBg: const Color(0xFFDDEBFF),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: homeStatCard(
                      context: context,

                      icon: Icons.payments_outlined,
                      title: 'Estimate Cost',
                      value: '\$10.00',
                      iconColor: const Color(0xFF607D8B),
                      iconBg: const Color(0xFFE2EFF3),
                      valueColor: const Color(0xFF35B84A),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Shopping List'),
                  TextButton(onPressed: () {}, child: Text('See All')),
                ],
              ),

              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
