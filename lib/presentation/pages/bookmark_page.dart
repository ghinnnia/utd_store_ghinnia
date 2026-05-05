import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import '../../data/services/bookmark_service.dart';
import '../../data/models/bookmark_model.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<BookmarkModel> bookmarks = [];
  final service = GetIt.I<BookmarkService>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await service.getAll();
    setState(() => bookmarks = data);
  }

  Future<void> _delete(BookmarkModel b) async {
    await service.delete(b.id!);
    await _load();
    Fluttertoast.showToast(msg: 'Dihapus');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmark'),
        backgroundColor: const Color(0xFF6B34E8),
        foregroundColor: Colors.white,
      ),
      body: bookmarks.isEmpty
          ? const Center(child: Text('Belum ada bookmark'))
          : ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final b = bookmarks[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Image.network(b.imageUrl, width: 50, errorBuilder: (_, __, ___) => const Icon(Icons.error)),
                    title: Text(b.productTitle),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rp ${b.price.toStringAsFixed(0)}'),
                        Text('Disimpan ${DateFormat('HH:mm').format(b.savedAt)}'),
                      ],
                    ),
                    trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => _delete(b)),
                  ),
                );
              },
            ),
    );
  }
}