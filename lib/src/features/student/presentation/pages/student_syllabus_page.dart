import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StudentSyllabusPage extends StatefulWidget {
  const StudentSyllabusPage({super.key});

  @override
  State<StudentSyllabusPage> createState() => _StudentSyllabusPageState();
}

class _StudentSyllabusPageState extends State<StudentSyllabusPage> {
  final Map<String, bool> _expanded = {};

  final List<Map<String, dynamic>> _courses = [
    {
      'code': 'CS3501',
      'name': 'Compiler Design',
      'faculty': 'Dr. K. Ramesh',
      'completion': 62,
      'units': [
        {'name': 'Unit I - Lexical Analysis', 'topics': 'Role of Lexical Analyzer, Input Buffering, Specification of Tokens, Recognition of Tokens, Lex Tool, Finite Automata, Regular Expressions to NFA and DFA', 'done': 100},
        {'name': 'Unit II - Syntax Analysis', 'topics': 'Role of Parser, Context Free Grammars, Top Down Parsing, Predictive Parsing, Bottom Up Parsing, SLR, CLR, LALR Parsers, YACC Tool', 'done': 100},
        {'name': 'Unit III - Intermediate Code Generation', 'topics': 'Syntax Directed Definitions, Evaluation Orders, SDT Schemes, Type Checking, Three Address Code, Quadruples, Triples, Indirect Triples', 'done': 85},
        {'name': 'Unit IV - Code Optimization', 'topics': 'Principal Sources, Peephole Optimization, Basic Blocks, Flow Graphs, DAG Representation, Loop Optimization, Data Flow Analysis', 'done': 20},
        {'name': 'Unit V - Code Generation', 'topics': 'Issues in Code Generation, Target Machine, Basic Blocks, Next-use Information, Register Allocation, Code Generation Algorithm', 'done': 0},
      ],
    },
    {
      'code': 'CS3591',
      'name': 'Computer Networks',
      'faculty': 'Prof. S. Lakshmi',
      'completion': 55,
      'units': [
        {'name': 'Unit I - Data Communication', 'topics': 'Networks, Network Types, Internet, Protocols, OSI Model, TCP/IP Protocol Suite, Transmission Media, Switching', 'done': 100},
        {'name': 'Unit II - Data Link Layer', 'topics': 'Error Detection, Error Correction, Data Link Control, Multiple Access, Ethernet, IEEE 802.11, Bluetooth', 'done': 100},
        {'name': 'Unit III - Network Layer', 'topics': 'IPv4, IPv6, Address Mapping, ICMP, Routing Algorithms, Distance Vector, Link State, OSPF, BGP', 'done': 70},
        {'name': 'Unit IV - Transport Layer', 'topics': 'Process-to-Process Delivery, UDP, TCP, Congestion Control, Quality of Service, SCTP', 'done': 10},
        {'name': 'Unit V - Application Layer', 'topics': 'DNS, Email, FTP, HTTP, WWW, SNMP, Network Security, Cryptography, Firewalls', 'done': 0},
      ],
    },
    {
      'code': 'CS3551',
      'name': 'Distributed Computing',
      'faculty': 'Dr. M. Venkatesh',
      'completion': 48,
      'units': [
        {'name': 'Unit I - Introduction', 'topics': 'Distributed Systems, Goals, Types, Architecture, Communication Paradigms, Middleware', 'done': 100},
        {'name': 'Unit II - Mutual Exclusion & Deadlock', 'topics': 'Clock Synchronization, Logical Clocks, Mutual Exclusion Algorithms, Deadlock Detection, Election Algorithms', 'done': 100},
        {'name': 'Unit III - Agreement Protocols', 'topics': 'Byzantine Agreement, Consensus, Distributed Transactions, Commit Protocols, Two-Phase Commit, Three-Phase Commit', 'done': 40},
        {'name': 'Unit IV - Fault Tolerance', 'topics': 'Replication, Consistency Models, Fault Detection, Recovery, Checkpointing, Rollback Recovery', 'done': 0},
        {'name': 'Unit V - Peer-to-Peer & Cloud', 'topics': 'P2P Systems, DHT, Chord, CAN, Cloud Computing, Virtualization, MapReduce, Hadoop', 'done': 0},
      ],
    },
    {
      'code': 'MA3391',
      'name': 'Probability and Statistics',
      'faculty': 'Dr. P. Anitha',
      'completion': 70,
      'units': [
        {'name': 'Unit I - Random Variables', 'topics': 'Probability, Axioms, Conditional Probability, Bayes Theorem, Discrete and Continuous Random Variables, Moments, MGF', 'done': 100},
        {'name': 'Unit II - Standard Distributions', 'topics': 'Binomial, Poisson, Geometric, Uniform, Exponential, Gamma, Normal Distribution, Properties', 'done': 100},
        {'name': 'Unit III - Two Dimensional RV', 'topics': 'Joint Distributions, Marginal and Conditional Distributions, Covariance, Correlation, Regression', 'done': 100},
        {'name': 'Unit IV - Testing of Hypothesis', 'topics': 'Sampling Distributions, Estimation, Testing of Hypothesis, Chi-Square Test, t-Test, F-Test, ANOVA', 'done': 50},
        {'name': 'Unit V - Queuing Theory', 'topics': 'Markov Chains, Transition Probability, Steady State, Birth-Death Process, M/M/1, M/M/c Queuing Models', 'done': 0},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.library_books, color: AppColors.primary, size: 28),
                SizedBox(width: 12),
                Text('Syllabus', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Semester 5 - Course Syllabus with Completion Tracking', style: TextStyle(color: AppColors.textLight, fontSize: 14)),
            const SizedBox(height: 24),
            ..._courses.map((course) => _buildCourseSection(course)),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseSection(Map<String, dynamic> course) {
    final code = course['code'] as String;
    final isExpanded = _expanded[code] ?? false;
    final completion = course['completion'] as int;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded[code] = !isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                    child: Text(code, style: const TextStyle(color: Color(0xFF64B5F6), fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(course['faculty'] as String, style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
                    ],
                  )),
                  SizedBox(
                    width: 120,
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: completion / 100,
                          backgroundColor: AppColors.border,
                          valueColor: AlwaysStoppedAnimation(completion >= 75 ? Colors.green : completion >= 50 ? Colors.orange : Colors.redAccent),
                        ),
                        const SizedBox(height: 4),
                        Text('$completion% Complete', style: TextStyle(color: completion >= 75 ? Colors.green : completion >= 50 ? Colors.orange : Colors.redAccent, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: AppColors.textLight),
                ],
              ),
            ),
          ),
          if (isExpanded) ...(course['units'] as List<Map<String, dynamic>>).map((unit) => Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(unit['name'] as String, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600, fontSize: 14))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (unit['done'] as int) == 100 ? Colors.green.withOpacity(0.2) : (unit['done'] as int) > 0 ? Colors.orange.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('${unit['done']}%', style: TextStyle(
                        color: (unit['done'] as int) == 100 ? Colors.green : (unit['done'] as int) > 0 ? Colors.orange : Colors.redAccent,
                        fontSize: 12, fontWeight: FontWeight.bold,
                      )),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(unit['topics'] as String, style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
              ],
            ),
          )),
          if (isExpanded) const SizedBox(height: 4),
        ],
      ),
    );
  }
}
