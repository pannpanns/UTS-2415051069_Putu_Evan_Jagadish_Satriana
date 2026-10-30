
import 'package:flutter/material.dart';

import '../widgets/summary_card.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double maxContentWidth = 1200;

  static const Color background = Color(0xFFF3F8F4);
  static const Color darkGreen = Color(0xFF25372B);
  static const Color primaryGreen = Color(0xFF2E8B57);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape =
            constraints.maxWidth > constraints.maxHeight;

        final horizontalPadding =
            constraints.maxWidth >= 700 ? 32.0 : 20.0;

        final contentWidth =
            (constraints.maxWidth > maxContentWidth
                    ? maxContentWidth
                    : constraints.maxWidth) -
                horizontalPadding * 2;

        final isWide = contentWidth >= 680;

        return Column(
          children: [
            _buildHeader(
              isLandscape,
              horizontalPadding,
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: maxContentWidth,
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        isLandscape ? 12 : 22,
                        horizontalPadding,
                        12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildGreeting(isLandscape),

                          SizedBox(
                            height: isLandscape ? 14 : 22,
                          ),

                          _buildSummary(
                            contentWidth,
                            isLandscape,
                          ),

                          SizedBox(
                            height: isLandscape ? 14 : 20,
                          ),

                          _buildProgressCard(),

                          SizedBox(
                            height: isLandscape ? 18 : 28,
                          ),

                          _buildUpcomingHeader(),

                          const SizedBox(height: 14),

                          _buildUpcomingTasks(isWide),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(
    bool isLandscape,
    double horizontalPadding,
  ) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF14532D),
            Color(0xFF2E8B57),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: maxContentWidth,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: isLandscape ? 7 : 10,
            ),
            child: SizedBox(
              height: 48,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: primaryGreen,
                      size: 25,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TuntasKuliah',
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.2,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Academic Assignment Tracker',
                          style: TextStyle(
                            fontSize: 10,
                            height: 1.2,
                            color: Color(0xFFDCEFE2),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Color(0xFF247A45),
                      size: 21,
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

  Widget _buildGreeting(bool isLandscape) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo, Mahasiswa!',
          style: TextStyle(
            fontSize: isLandscape ? 19 : 22,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Pantau dan selesaikan tugas kuliahmu.',
          style: TextStyle(
            fontSize: isLandscape ? 12 : 13,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(
    double contentWidth,
    bool isLandscape,
  ) {
    final crossAxisCount = contentWidth >= 680 ? 4 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Tugas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),

        const SizedBox(height: 10),

        GridView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: isLandscape ? 116 : 128,
          ),
          children: const [
            SummaryCard(
              title: 'Total Tugas',
              value: '12',
              icon: Icons.assignment_outlined,
              color: Color(0xFF247A45),
              backgroundColor: Color(0xFFE5F3E8),
            ),
            SummaryCard(
              title: 'Selesai',
              value: '5',
              icon: Icons.check_circle_outline,
              color: Color(0xFF198754),
              backgroundColor: Color(0xFFDDF4E6),
            ),
            SummaryCard(
              title: 'Dikerjakan',
              value: '4',
              icon: Icons.pending_actions,
              color: Color(0xFFC17A1B),
              backgroundColor: Color(0xFFFFF1D8),
            ),
            SummaryCard(
              title: 'Belum Mulai',
              value: '3',
              icon: Icons.schedule_outlined,
              color: Color(0xFF667A6B),
              backgroundColor: Color(0xFFE9F0EA),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2EBE4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progres Penyelesaian',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: darkGreen,
                ),
              ),
              const Text(
                '42%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 5 / 12,
              minHeight: 8,
              backgroundColor: Color(0xFFE2ECE4),
              valueColor: AlwaysStoppedAnimation<Color>(
                primaryGreen,
              ),
            ),
          ),

          const SizedBox(height: 9),

          Text(
            '5 dari 12 tugas telah diselesaikan.',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tugas Minggu Ini',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2E7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '3 tugas',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF236B43),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingTasks(bool isWide) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;

        final itemWidth = isWide
            ? (constraints.maxWidth - spacing) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            SizedBox(
              width: itemWidth,
              child: const TaskCard(
                title: 'Membuat Makalah',
                subject: 'Pemrograman Mobile',
                deadline: '02 November 2026',
                priority: 'Tinggi',
                status: 'Dikerjakan',
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: const TaskCard(
                title: 'Laporan Praktikum',
                subject: 'Basis Data',
                deadline: '04 November 2026',
                priority: 'Sedang',
                status: 'Belum Mulai',
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: const TaskCard(
                title: 'Presentasi Individu',
                subject: 'Analisis Sistem',
                deadline: '06 November 2026',
                priority: 'Rendah',
                status: 'Belum Mulai',
              ),
            ),
          ],
        );
      },
    );
  }
}
