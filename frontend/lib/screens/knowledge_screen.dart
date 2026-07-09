import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import '../services/api_service.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  List<AlternativeItem>? _items;
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final items = await ApiService.getAlternatives();
      if (mounted) setState(() => _items = items);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  List<AlternativeItem> get _filteredItems {
    if (_items == null) return [];
    if (_filter.isEmpty) return _items!;
    return _items!
        .where((i) =>
            i.item.contains(_filter) ||
            i.alternative.contains(_filter) ||
            i.category.contains(_filter))
        .toList();
  }

  Set<String> get _categories => _items?.map((i) => i.category).toSet() ?? {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('避坑百科', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _items == null
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF3B82F6)))
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (v) => setState(() => _filter = v),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: '搜商品名或平替...',
                      hintStyle: const TextStyle(color: Color(0xFF555A68)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF8890A4)),
                      filled: true,
                      fillColor: const Color(0xFF161822),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF232636)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF232636)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                      ),
                    ),
                  ),
                ),

                // Stats
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _StatChip(
                          label: '${_items!.length} 条', color: const Color(0xFF3B82F6)),
                      const SizedBox(width: 8),
                      _StatChip(
                          label: '${_categories.length} 个品类',
                          color: const Color(0xFF22C55E)),
                      const SizedBox(width: 8),
                      _StatChip(
                          label: '省 ${_totalSaved()}',
                          color: const Color(0xFFF59E0B)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, i) {
                      final item = _filteredItems[i];
                      return _AlternativeCard(item: item);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  String _totalSaved() {
    if (_items == null || _items!.isEmpty) return '很多';
    // Rough estimate: total price difference
    int total = 0;
    for (final item in _items!) {
      try {
        final high = int.parse(item.price.replaceAll(RegExp(r'[^0-9]'), ''));
        final low = int.parse(item.altPrice.replaceAll(RegExp(r'[^0-9]'), ''));
        total += (high - low);
      } catch (_) {}
    }
    if (total > 1000) return '${(total / 1000).toStringAsFixed(0)}k+';
    return '${total}元';
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}

class _AlternativeCard extends StatelessWidget {
  final AlternativeItem item;
  const _AlternativeCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF161822),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF232636)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(item.category,
                    style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 11)),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_rounded, color: Color(0xFF22C55E), size: 18),
            ],
          ),
          const SizedBox(height: 10),

          // IQ tax item
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('智商税 ', style: TextStyle(color: Color(0xFFEF4444), fontSize: 13)),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: item.item,
                          style:
                              const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                      TextSpan(
                          text: '  ${item.price}',
                          style: const TextStyle(color: Color(0xFFEF4444), fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Alternative
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('平替   ', style: TextStyle(color: Color(0xFF22C55E), fontSize: 13)),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: item.alternative,
                          style: const TextStyle(
                              color: Color(0xFF22C55E), fontSize: 14, fontWeight: FontWeight.w600)),
                      TextSpan(
                          text: '  ${item.altPrice}',
                          style: const TextStyle(color: Color(0xFF22C55E), fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Reason
          Text(item.reason,
              style: const TextStyle(color: Color(0xFF8890A4), fontSize: 12, height: 1.4)),
        ],
      ),
    );
  }
}
