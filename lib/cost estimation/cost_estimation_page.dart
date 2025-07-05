import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CostEstimationPage extends StatefulWidget {
  const CostEstimationPage({super.key});

  @override
  State<CostEstimationPage> createState() => _CostEstimationPageState();
}

class _CostEstimationPageState extends State<CostEstimationPage>
    with TickerProviderStateMixin {
  Map<String, dynamic> feeData = {};
  Map<String, dynamic> extraExpense = {};
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  loadcollegedata() async {
    String data = await rootBundle.loadString("asset/scraped_data.json");
    setState(() {
      feeData = json.decode(data);
    });
  }

  loadExpenseData() async {
    String data = await rootBundle.loadString("asset/add_cost.json");
    setState(() {
      extraExpense = json.decode(data);
    });
  }

  List<SelectedCollege> courselist = [];
  SelectedCollege? selectedcourse;
  String? selectedcategory;
  double totalCost = 0;
  String collegeFee = "";
  String? selectedCollege;

  @override
  void initState() {
    super.initState();
    loadcollegedata();
    loadExpenseData();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  final _auth = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildModernAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildHeroSection(),
                _buildCalculatorSection(),
                if (selectedcourse != null && selectedcategory != null)
                  _buildCostBreakdown(),
                if (collegeFee.isNotEmpty) _buildTotalCostCard(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      title: const Text(
        "College Cost Estimator",
        style: TextStyle(
          color: Color(0xFF1E293B),
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      actions: [
        if (_auth != null) ...[
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_circle,
                    color: Color(0xFF3B82F6), size: 18),
                const SizedBox(width: 8),
                Text(
                  _auth!.email!.split('@')[0],
                  style: const TextStyle(
                    color: Color(0xFF3B82F6),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildActionButton(
            onPressed: () async => await FirebaseAuth.instance.signOut(),
            icon: Icons.logout,
            label: 'Sign Out',
            color: const Color(0xFFEF4444),
          ),
        ] else
          _buildActionButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            icon: Icons.login,
            label: 'Login',
            color: const Color(0xFF3B82F6),
          ),
        _buildActionButton(
          onPressed: () => Navigator.pushNamed(context, '/forum'),
          icon: Icons.forum,
          label: 'Forum',
          color: const Color(0xFF10B981),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3B82F6),
            Color(0xFF1D4ED8),
            Color(0xFF1E40AF),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.school,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            "Smart College Cost Calculator",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "Get accurate cost estimates based on data from 100+ Delhi University students and alumni",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Calculate Your Costs",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Fill in your details to get an accurate estimate",
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 32),
          _buildStepIndicator(),
          const SizedBox(height: 32),
          _buildCollegeDropdown(),
          const SizedBox(height: 24),
          _buildCourseDropdown(),
          const SizedBox(height: 24),
          _buildCategoryDropdown(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        _buildStep(1, "College", selectedCollege != null),
        _buildStepConnector(selectedCollege != null),
        _buildStep(2, "Course", selectedcourse != null),
        _buildStepConnector(selectedcourse != null),
        _buildStep(3, "Category", selectedcategory != null),
      ],
    );
  }

  Widget _buildStep(int number, String label, bool isCompleted) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted
                  ? const Color(0xFF10B981)
                  : const Color(0xFFE2E8F0),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : Text(
                      '$number',
                      style: TextStyle(
                        color: isCompleted
                            ? Colors.white
                            : const Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isCompleted
                  ? const Color(0xFF10B981)
                  : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Container(
      height: 2,
      width: 40,
      margin: const EdgeInsets.only(bottom: 20),
      color: isActive ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
    );
  }

  Widget _buildCollegeDropdown() {
    return _buildModernDropdown(
      label: "Select College",
      icon: Icons.business,
      hint: "Choose your college",
      items: feeData.keys.map<DropdownMenuItem<String>>((String college) {
        return DropdownMenuItem<String>(
          value: college,
          child: Text(college),
        );
      }).toList(),
      onChanged: (val) {
        selectedCollege = val;
        List list = feeData[val];
        courselist.clear();
        for (var e in list) {
          courselist.add(SelectedCollege.fromJson(e));
        }
        selectedcourse = null;
        selectedcategory = null;
        collegeFee = "";
        totalCost = 0;
        setState(() {});
      },
    );
  }

  Widget _buildCourseDropdown() {
    return _buildModernDropdown(
      label: "Select Course",
      icon: Icons.menu_book,
      hint: selectedCollege == null
          ? "Select college first"
          : "Choose your course",
      enabled: selectedCollege != null,
      items: courselist.map<DropdownMenuItem<String>>((course) {
        return DropdownMenuItem<String>(
          value: course.program,
          child: Text(course.program),
          onTap: () {
            selectedcourse = course;
            selectedcategory = null;
            collegeFee = "";
            totalCost = 0;
            setState(() {});
          },
        );
      }).toList(),
      onChanged: (val) {},
    );
  }

  Widget _buildCategoryDropdown() {
    return _buildModernDropdown(
      label: "Select Category",
      icon: Icons.category,
      hint: selectedcourse == null
          ? "Select course first"
          : "Choose your category",
      enabled: selectedcourse != null,
      items: selectedcourse != null
          ? [
              DropdownMenuItem(
                value: "sc",
                onTap: () {
                  collegeFee = selectedcourse!.sc;
                  selectedcategory = "sc";
                  _calculateTotalCost();
                },
                child: const Text("SC/ST"),
              ),
              DropdownMenuItem(
                value: "urobcminority",
                onTap: () {
                  collegeFee = selectedcourse!.urobcminority;
                  selectedcategory = "urobcminority";
                  _calculateTotalCost();
                },
                child: const Text("OBC/UR"),
              ),
              DropdownMenuItem(
                value: "pwd",
                onTap: () {
                  collegeFee = selectedcourse!.pwd;
                  selectedcategory = "pwd";
                  _calculateTotalCost();
                },
                child: const Text("PWD"),
              )
            ]
          : [],
      onChanged: (val) {
        setState(() {});
      },
    );
  }

  void _calculateTotalCost() {
    totalCost = 0;
    extraExpense.forEach(
      (key, value) => totalCost += double.parse(value[selectedcategory]),
    );
    totalCost += double.parse(collegeFee);
    setState(() {});
  }

  Widget _buildModernDropdown({
    required String label,
    required IconData icon,
    required String hint,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF3B82F6)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: enabled ? Colors.white : const Color(0xFFF8FAFC),
            border: Border.all(
              color:
                  enabled ? const Color(0xFFE2E8F0) : const Color(0xFFF1F5F9),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: enabled ? items : [],
            onChanged: enabled ? onChanged : null,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF64748B),
            ),
            dropdownColor: Colors.white,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCostBreakdown() {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long,
                    color: Color(0xFF3B82F6), size: 24),
                const SizedBox(width: 12),
                const Text(
                  "Cost Breakdown",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildCostItem(
                  "College Fee",
                  collegeFee,
                  const Color(0xFF3B82F6),
                  Icons.school,
                  isMain: true,
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFE2E8F0)),
                const SizedBox(height: 16),
                ...extraExpense.entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCostItem(
                      e.value["title"] ?? "",
                      e.value[selectedcategory],
                      const Color(0xFF64748B),
                      Icons.add_circle_outline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostItem(
    String title,
    String amount,
    Color color,
    IconData icon, {
    bool isMain = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: isMain ? 16 : 14,
                fontWeight: isMain ? FontWeight.w600 : FontWeight.w500,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
          Text(
            '₹$amount',
            style: TextStyle(
              fontSize: isMain ? 18 : 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCostCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF10B981),
            Color(0xFF059669),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.calculate,
            size: 40,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            "Total Estimated Cost",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "₹${totalCost.ceil()}",
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Based on real student data",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// SelectedCollege Class remains the same
class SelectedCollege {
  String program;
  String urobcminority;
  String sc;
  String st;
  String pwd;

  SelectedCollege({
    required this.program,
    required this.urobcminority,
    required this.sc,
    required this.st,
    required this.pwd,
  });

  factory SelectedCollege.fromJson(Map<String, dynamic> json) =>
      SelectedCollege(
        program: json["program"],
        urobcminority: json["urobcminority"],
        sc: json["sc"],
        st: json["st"],
        pwd: json["pwd"],
      );

  Map<String, dynamic> toJson() => {
        "program": program,
        "urobcminority": urobcminority,
        "sc": sc,
        "st": st,
        "pwd": pwd,
      };
}
