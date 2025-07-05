import 'package:college_cost_estimator/forum/forum.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            _buildHeader(context),

            // Hero Section
            _buildHeroSection(context),

            // Main Features Section
            _buildMainFeaturesSection(context),

            //testimonials
            // image and its stories
            //
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Logo Section
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'DU Cost Calculator',
                  style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Navigation Links (Desktop)
            if (MediaQuery.of(context).size.width > 768) ...[
              _buildNavLink('Home', true, () {}),
              const SizedBox(width: 32),
              _buildNavLink('Cost Estimator', false, () {
                Navigator.pushNamed(context, '/cost');
              }),
              const SizedBox(width: 32),
              _buildNavLink('Forum', false, () {
                Navigator.pushNamed(context, '/forum');
              }),
              const SizedBox(width: 32),
              _buildNavLink('About Us', false, () {
                Navigator.pushNamed(context, '/about');
              }),
              const SizedBox(width: 32),
              _buildNavLink('Contact', false, () {
                Navigator.pushNamed(context, '/contact');
              }),
              const SizedBox(width: 24),

              // CTA Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Join Now',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ] else ...[
              // Mobile Menu Icon
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                  color: Color(0xFF1E293B),
                  size: 28,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavLink(String text, bool isActive, VoidCallback ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? const Color(0xFF3B82F6) : const Color(0xFF64748B),
          fontSize: 16,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      margin: const EdgeInsets.all(24),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: isMobile ? 32 : 64,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isMobile) ...[
            _buildHeroContent(context, true),
            const SizedBox(height: 40),
            _buildHeroVisual(context, true),
          ] else ...[
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: _buildHeroContent(context, false),
                ),
                const SizedBox(width: 64),
                Expanded(
                  flex: 4,
                  child: _buildHeroVisual(context, false),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeroContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Main Headline
        Text(
          'Get Accurate Cost Estimates for Delhi University',
          style: TextStyle(
            fontSize: isMobile ? 32 : 48,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E293B),
            height: 1.2,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),

        const SizedBox(height: 24),

        // Subheadline
        Text(
          'Plan your education finances with personalized fee calculations based on your college choice, course, and category. Get insights from real student experiences.',
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            color: const Color(0xFF64748B),
            height: 1.6,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),

        const SizedBox(height: 40),

        // CTA Button
        SizedBox(
          width: isMobile ? double.infinity : 240,
          height: 56,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calculate, size: 20),
                SizedBox(width: 8),
                Text(
                  'Start Cost Estimation',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Key Stats
        if (!isMobile) _buildKeyStats() else _buildKeyStatsMobile(),
      ],
    );
  }

  Widget _buildKeyStats() {
    return Row(
      children: [
        _buildStatItem('50+', 'Colleges Covered'),
        const SizedBox(width: 48),
        _buildStatItem('1000+', 'Students Helped'),
        const SizedBox(width: 48),
        _buildStatItem('95%', 'Accuracy Rate'),
      ],
    );
  }

  Widget _buildKeyStatsMobile() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem('50+', 'Colleges Covered'),
            _buildStatItem('1000+', 'Students Helped'),
          ],
        ),
        const SizedBox(height: 16),
        _buildStatItem('95%', 'Accuracy Rate'),
      ],
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF3B82F6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroVisual(BuildContext context, bool isMobile) {
    return Container(
      height: isMobile ? 200 : 300,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'University of Delhi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fee Calculator',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          // Floating elements
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.2),
                ),
              ),
              child: const Text(
                '₹ Live Data',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF3B82F6).withOpacity(0.2),
                ),
              ),
              child: const Text(
                'Updated Daily',
                style: TextStyle(
                  color: Color(0xFF3B82F6),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainFeaturesSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      margin: const EdgeInsets.all(24),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: isMobile ? 40 : 60,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Header
          Text(
            'Main Features',
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          Text(
            'Everything you need to plan your education finances',
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              color: const Color(0xFF64748B),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: isMobile ? 32 : 48),

          // Features Grid
          if (isMobile) ...[
            _buildFeatureCard(
                context,
                Icons.calculate_outlined,
                'Personalized Fee Calculator',
                'Get precise cost estimates based on your college choice, course, and category',
                'Try Calculator',
                const Color(0xFF10B981),
                true, () {
              Navigator.pushNamed(context, "/cost");
            }),
            const SizedBox(height: 24),
            _buildFeatureCard(
                context,
                Icons.forum_outlined,
                'Student Discussion Forum',
                'Connect with current students and get insights about college expenses',
                'Join Discussions',
                const Color(0xFF3B82F6),
                true, () {
              Navigator.pushNamed(context, "/forum");
            }),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                      context,
                      Icons.calculate_outlined,
                      'Personalized Fee Calculator',
                      'Get precise cost estimates based on your college choice, course, and category',
                      'Try Calculator',
                      const Color(0xFF10B981),
                      false, () {
                    Navigator.pushNamed(context, "/cost");
                  }),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildFeatureCard(
                      context,
                      Icons.forum_outlined,
                      'Student Discussion Forum',
                      'Connect with current students and get insights about college expenses',
                      'Join Discussions',
                      const Color(0xFF3B82F6),
                      false, () {
                    Navigator.pushNamed(context, "/forum");
                  }),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    String ctaText,
    Color accentColor,
    bool isMobile,
    VoidCallback? onPressed,
  ) {
    return Container(
      height: isMobile ? 280 : 320,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Container
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: accentColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: accentColor,
                size: 28,
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                height: 1.3,
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Expanded(
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                  height: 1.6,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // CTA Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon == Icons.calculate_outlined
                          ? Icons.arrow_forward
                          : Icons.group_add,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ctaText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
