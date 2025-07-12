import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/controllers/membership_controller.dart';
import 'package:gym_app/models/membership_models.dart';
import 'package:gym_app/widget/custom_bottom_nav_bar.dart';
import 'package:gym_app/views/membership/membership_checkout_page.dart';
import 'package:gym_app/views/home/home_page.dart';

const _membershipBannerImage = 'assets/images/Carousel.png';
const _barbellProgramImage = 'assets/images/barbell_program.png';
const _dumbbellProgramImage = 'assets/images/3d.png';
const _megaphoneIconPath = 'assets/images/megaphone_icon.png';
const _dumbbellIconPath = 'assets/images/dumble.png';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildMembershipOptionCard(
    BuildContext context, {
    required MembershipPlan plan,
    required String imagePath,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 30, 30, 30),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plan.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                plan.formattedDuration,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Text(
                plan.formattedPrice,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  final String planId = plan.id;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              MembershipCheckoutPage(membershipId: planId),
                    ),
                  );
                },
                child: const Text(
                  'Join membership →',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF424242),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        title: const Text(
          'Membership',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<MembershipController>(
        builder: (context, controller, child) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: MediaQuery.of(context).size.height * 0.25,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(_membershipBannerImage, fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.2),
                              Colors.black.withOpacity(0.5),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Let\'s Join',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Membership',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Dengan bergabung sebagai anggota\ndi gym anda telah memulai langkah\nawal untuk hidup yang lebih sehat',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (controller.isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),

              if (controller.errorMessage != null)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      controller.errorMessage!,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ),

              if (!controller.isLoading && controller.errorMessage == null)
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 20.0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFFE53935), Color(0xFF8B0000)],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                _megaphoneIconPath,
                                width: 35,
                                height: 35,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      '40% discount',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'on all our membership',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 65,
                                height: 65,

                                child: Center(
                                  child: Image.asset(
                                    _dumbbellIconPath,
                                    width: 55,
                                    height: 55,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.separated(
                        itemCount: controller.plans.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final plan = controller.plans[index];
                          final imagePath = _dumbbellProgramImage;

                          return _buildMembershipOptionCard(
                            context,
                            plan: plan,
                            imagePath: imagePath,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ]),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
