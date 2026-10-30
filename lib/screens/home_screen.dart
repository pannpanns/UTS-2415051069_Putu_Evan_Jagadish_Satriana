import 'package:flutter/material.dart';

import '../widgets/summary_card.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double _maxContentWidth = 1200;
  static const double _wideBreakpoint = 700;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= _wideBreakpoint;

            final horizontalPadding = isWide ? 32.0 : 20.0;

            final availableWidth = constraints.maxWidth > _maxContentWidth
                ? _maxContentWidth
                : constraints.maxWidth;

            final contentWidth = availableWidth - (horizontalPadding * 2);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(horizontalPadding),

                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: _maxContentWidth,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          24,
                          horizontalPadding,
                          24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildGreeting(),
                            const SizedBox(height: 22),

                            _buildSummary(contentWidth),
                            const SizedBox(height: 16),

                            _buildProgressCard(),
                            const SizedBox(height: 27),

                            _buildUpcomingHeader(),
                            const SizedBox(height: 14),

                            _buildUpcomingTasks(isWide),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Full-width application header
  Widget _buildHeader(double horizontalPadding) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF14532D), Color(0xFF2E8B57)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxContentWidth),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Color(0xFF247A45),
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TuntasKuliah',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Academic Assignment Tracker',
                      style: TextStyle(fontSize: 11, color: Color(0xFFDCEFE2)),
                    ),
                  ],
                ),
              ),

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
    );
  }

  // Greeting section
  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Halo, Mahasiswa!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF25372B),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Pantau dan selesaikan tugas kuliahmu.',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // Responsive task summary
  Widget _buildSummary(double contentWidth) {
    final crossAxisCount = contentWidth >= 680 ? 4 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Tugas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF25372B),
          ),
        ),
        const SizedBox(height: 13),

        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 128,
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

  // Task completion progress
  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2EBE4)),
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
                  color: Color(0xFF25372B),
                ),
              ),
              const Text(
                '42%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E8B57),
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
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E8B57)),
            ),
          ),

          const SizedBox(height: 9),

          Text(
            '5 dari 12 tugas telah diselesaikan.',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // Upcoming task header
  Widget _buildUpcomingHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tugas Minggu Ini',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF25372B),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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

  // Responsive upcoming task list
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
