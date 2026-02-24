import 'package:flutter/material.dart';

class FacultySyllabusPage extends StatelessWidget {
  const FacultySyllabusPage({super.key});

  static const _bg = Color(0xFF0D1F3C);
  static const _card = Color(0xFF111D35);
  static const _border = Color(0xFF1E3055);
  static const _accent = Color(0xFF1565C0);
  static const _gold = Color(0xFFD4A843);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Syllabus Management', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.upload_file, size: 18),
                  label: const Text('Upload Syllabus'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Track syllabus completion and manage course materials', style: TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 24),

            _SyllabusCourseCard(
              code: 'CS3501',
              name: 'Compiler Design',
              overallProgress: 0.45,
              units: const [
                {'name': 'Unit I - Introduction to Compilers', 'topics': 'Phases of Compiler, Lexical Analysis, RE to DFA', 'progress': 1.0, 'hours': '10/10'},
                {'name': 'Unit II - Syntax Analysis', 'topics': 'CFG, Top-Down Parsing, LL(1), Bottom-Up Parsing', 'progress': 0.80, 'hours': '8/10'},
                {'name': 'Unit III - Intermediate Code', 'topics': 'SDT, Three Address Code, DAG, Type Checking', 'progress': 0.30, 'hours': '3/10'},
                {'name': 'Unit IV - Code Optimization', 'topics': 'Flow Graphs, Data Flow Analysis, Loop Optimization', 'progress': 0.0, 'hours': '0/10'},
                {'name': 'Unit V - Code Generation', 'topics': 'Register Allocation, Instruction Selection, Peephole', 'progress': 0.0, 'hours': '0/8'},
              ],
              color: _accent,
            ),
            const SizedBox(height: 16),

            _SyllabusCourseCard(
              code: 'CS3691',
              name: 'Embedded Systems & IoT',
              overallProgress: 0.38,
              units: const [
                {'name': 'Unit I - Embedded System Basics', 'topics': 'Architecture, Processors, Memory, I/O', 'progress': 1.0, 'hours': '9/9'},
                {'name': 'Unit II - Embedded Programming', 'topics': 'C for Embedded, RTOS Concepts, Task Scheduling', 'progress': 0.60, 'hours': '5/9'},
                {'name': 'Unit III - IoT Architecture', 'topics': 'IoT Protocols, MQTT, CoAP, REST APIs', 'progress': 0.20, 'hours': '2/9'},
                {'name': 'Unit IV - IoT Platforms', 'topics': 'Raspberry Pi, Arduino, Sensor Interfacing', 'progress': 0.0, 'hours': '0/9'},
                {'name': 'Unit V - IoT Applications', 'topics': 'Smart Home, Healthcare IoT, Industrial IoT', 'progress': 0.0, 'hours': '0/9'},
              ],
              color: Colors.teal,
            ),
            const SizedBox(height: 16),

            _SyllabusCourseCard(
              code: 'CS3511',
              name: 'Compiler Design Laboratory',
              overallProgress: 0.50,
              units: const [
                {'name': 'Ex 1-3: Lexical Analysis', 'topics': 'Symbol Table, Lexer using LEX, Token Recognition', 'progress': 1.0, 'hours': '6/6'},
                {'name': 'Ex 4-5: Parsing', 'topics': 'Recursive Descent Parser, YACC implementation', 'progress': 1.0, 'hours': '4/4'},
                {'name': 'Ex 6-7: Intermediate Code', 'topics': 'Three Address Code, Quadruple Generation', 'progress': 0.50, 'hours': '1/4'},
                {'name': 'Ex 8-9: Optimization', 'topics': 'DAG Construction, Code Optimization techniques', 'progress': 0.0, 'hours': '0/4'},
                {'name': 'Ex 10-12: Code Generation', 'topics': 'Assembly Code Gen, Register Allocation, Mini Project', 'progress': 0.0, 'hours': '0/6'},
              ],
              color: _gold,
            ),
            const SizedBox(height: 16),

            _SyllabusCourseCard(
              code: 'CS3401',
              name: 'Algorithms Design & Analysis',
              overallProgress: 0.42,
              units: const [
                {'name': 'Unit I - Algorithm Analysis', 'topics': 'Asymptotic Notation, Recurrences, Master Theorem', 'progress': 1.0, 'hours': '10/10'},
                {'name': 'Unit II - Divide & Conquer', 'topics': 'Merge Sort, Quick Sort, Strassen\'s Matrix Mult.', 'progress': 0.70, 'hours': '7/10'},
                {'name': 'Unit III - Greedy & DP', 'topics': 'Knapsack, Huffman, LCS, Matrix Chain', 'progress': 0.25, 'hours': '2/10'},
                {'name': 'Unit IV - Graph Algorithms', 'topics': 'BFS, DFS, Dijkstra, Bellman-Ford, MST', 'progress': 0.0, 'hours': '0/10'},
                {'name': 'Unit V - NP Problems', 'topics': 'P vs NP, Reductions, Approximation Algorithms', 'progress': 0.0, 'hours': '0/8'},
              ],
              color: Colors.orange,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SyllabusCourseCard extends StatelessWidget {
  final String code, name;
  final double overallProgress;
  final List<Map<String, dynamic>> units;
  final Color color;
  const _SyllabusCourseCard({required this.code, required this.name, required this.overallProgress, required this.units, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Text(code, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))),
              Text('${(overallProgress * 100).toInt()}% Complete', style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: overallProgress,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 16),
          ...units.map((u) {
            final prog = (u['progress'] as double);
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1F3C),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF1E3055).withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        prog >= 1.0 ? Icons.check_circle : prog > 0 ? Icons.timelapse : Icons.radio_button_unchecked,
                        color: prog >= 1.0 ? Colors.greenAccent : prog > 0 ? Colors.orangeAccent : Colors.white30,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(u['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500))),
                      Text(u['hours'] as String, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                      const Text(' hrs', style: TextStyle(color: Colors.white24, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 26),
                    child: Text(u['topics'] as String, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 26),
                    child: LinearProgressIndicator(
                      value: prog,
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation(prog >= 1.0 ? Colors.greenAccent : color),
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_note, size: 16),
              label: const Text('Update Progress'),
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color.withOpacity(0.4)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
