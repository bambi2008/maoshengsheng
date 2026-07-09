import 'package:flutter/material.dart';
import '../theme.dart';
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
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await ApiService.getAlternatives();
      if (mounted) setState(() => _items = items);
    } catch (e) {
      if (mounted) setState(() => _error = '加载失败，请检查后端服务');
    }
  }

  List<AlternativeItem> get _filtered {
    if (_items == null) return [];
    if (_filter.isEmpty) return _items!;
    return _items!
        .where((i) =>
            i.item.contains(_filter) ||
            i.alternative.contains(_filter) ||
            i.category.contains(_filter))
        .toList();
  }

  int get _totalSaved {
    if (_items == null) return 0;
    int total = 0;
    for (final i in _items!) {
      try {
        final high = int.parse(i.price.replaceAll(RegExp(r'[^0-9]'), ''));
        final low = int.parse(i.altPrice.replaceAll(RegExp(r'[^0-9]'), ''));
        total += (high - low).clamp(0, 99999);
      } catch (_) {}
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Nav title
            Padding(
              padding: const EdgeInsets.fromLTRB(AppTheme.space4, AppTheme.space3,
                  AppTheme.space4, AppTheme.space2),
              child: Text('避坑百科', style: AppTheme.headline),
            ),

            if (_error != null)
              Expanded(child: Center(child: Text(_error!, style: AppTheme.footnote)))
            else if (_items == null)
              const Expanded(
                  child: Center(
                      child: CircularProgressIndicator(color: AppTheme.blue)))
            else ...[
              // Hero savings card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.space4),
                child: _SavingsCard(
                    total: _totalSaved, count: _items!.length),
              ),
              const SizedBox(height: AppTheme.space4),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.space4),
                child: _SearchBar(onChanged: (v) => setState(() => _filter = v)),
              ),
              const SizedBox(height: AppTheme.space3),

              // List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                      AppTheme.space4, 0, AppTheme.space4, AppTheme.space4),
                  itemCount: _filtered.length,
                  itemBuilder: (_, i) => _AlternativeCard(item: _filtered[i]),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Savings hero card (blue gradient)
// ============================================================
class _SavingsCard extends StatelessWidget {
  final int total;
  final int count;
  const _SavingsCard({required this.total, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.space4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.blue, Color(0xFF5856D6)],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppTheme.blue.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('智商税平替清单'.toUpperCase(),
              style: AppTheme.caption1.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  letterSpacing: 0.5)),
          const SizedBox(height: AppTheme.space2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('¥$total',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'SF Pro Display')),
              const SizedBox(width: AppTheme.space2),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('可省',
                    style: AppTheme.subhead.copyWith(
                        color: Colors.white.withValues(alpha: 0.85))),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.space1),
          Text('$count 个品类，个个都是真金白银',
              style: AppTheme.footnote
                  .copyWith(color: Colors.white.withValues(alpha: 0.85))),
        ],
      ),
    );
  }
}

// ============================================================
// Search bar
// ============================================================
class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.space3),
      decoration: BoxDecoration(
        color: AppTheme.fill,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppTheme.textSec, size: 18),
          const SizedBox(width: AppTheme.space2),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: AppTheme.subhead,
              decoration: const InputDecoration(
                hintText: '搜商品名或平替…',
                hintStyle: TextStyle(color: AppTheme.textSec, fontSize: 15),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Alternative card
// ============================================================
class _AlternativeCard extends StatelessWidget {
  final AlternativeItem item;
  const _AlternativeCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final catColor = AppTheme.categoryColors[_catKey(item.category)] ??
        AppTheme.textSec;
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.space2),
      padding: const EdgeInsets.all(AppTheme.space4),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: catColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(item.category,
                style: AppTheme.caption2.copyWith(color: catColor)),
          ),
          const SizedBox(height: AppTheme.space3),

          // IQ tax item
          _priceRow(
            tag: '智商税',
            tagColor: AppTheme.red,
            name: item.item,
            price: item.price,
            strikethrough: true,
          ),
          const SizedBox(height: AppTheme.space2),

          // Arrow
          const Padding(
            padding: EdgeInsets.only(left: 2),
            child: Icon(Icons.arrow_downward_rounded,
                color: AppTheme.green, size: 16),
          ),
          const SizedBox(height: AppTheme.space2),

          // Alternative
          _priceRow(
            tag: '平替',
            tagColor: AppTheme.green,
            name: item.alternative,
            price: item.altPrice,
            strikethrough: false,
          ),
          const SizedBox(height: AppTheme.space3),

          // Divider
          const Divider(height: 1, color: AppTheme.separator),
          const SizedBox(height: AppTheme.space2),

          // Reason
          Text(item.reason, style: AppTheme.footnote.copyWith(height: 1.4)),
        ],
      ),
    );
  }

  Widget _priceRow({
    required String tag,
    required Color tagColor,
    required String name,
    required String price,
    required bool strikethrough,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          margin: const EdgeInsets.only(top: 1),
          decoration: BoxDecoration(
            color: tagColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(tag,
              style: AppTheme.caption2.copyWith(color: tagColor)),
        ),
        const SizedBox(width: AppTheme.space2),
        Expanded(
          child: Text(name, style: AppTheme.callout),
        ),
        const SizedBox(width: AppTheme.space2),
        Text(price,
            style: AppTheme.subhead.copyWith(
              color: strikethrough ? AppTheme.textSec : AppTheme.green,
              fontWeight: FontWeight.w600,
              decoration:
                  strikethrough ? TextDecoration.lineThrough : null,
            )),
      ],
    );
  }

  String _catKey(String cn) {
    if (cn.contains('饮水') || cn.contains('水')) return 'urinary';
    if (cn.contains('食') || cn.contains('营养')) return 'digestive';
    if (cn.contains('清洁') || cn.contains('如厕')) return 'skin';
    return 'other';
  }
}
