import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import '../../data/services/bookmark_service.dart';
import '../../data/models/bookmark_model.dart';
import '../../domain/entities/product.dart';
import '../cubit/product_cubit.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Product? product;
  bool isBookmarked = false;
  final bookmarkService = GetIt.I<BookmarkService>();

  @override
  void initState() {
    super.initState();
    _loadProduct();
    _checkBookmark();
  }

  void _loadProduct() {
    final state = context.read<ProductCubit>().state;
    if (state is ProductLoaded) {
      setState(() {
        product = state.products.firstWhere((p) => p.id == widget.productId);
      });
    }
  }

  Future<void> _checkBookmark() async {
    final items = await bookmarkService.getAll();
    setState(() => isBookmarked = items.any((b) => b.productId == widget.productId));
  }

  Future<void> _toggleBookmark() async {
    if (isBookmarked) {
      final items = await bookmarkService.getAll();
      final b = items.firstWhere((b) => b.productId == widget.productId);
      await bookmarkService.delete(b.id!);
      setState(() => isBookmarked = false);
      Fluttertoast.showToast(msg: 'Dihapus dari bookmark');
    } else {
      final bookmark = BookmarkModel(
        productId: widget.productId,
        productTitle: product!.title,
        price: product!.price,
        imageUrl: product!.image,
        savedAt: DateTime.now(),
      );
      await bookmarkService.add(bookmark);
      setState(() => isBookmarked = true);
      Fluttertoast.showToast(msg: 'Disimpan ke bookmark');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(product!.title),
        backgroundColor: const Color(0xFF6B34E8),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(product!.image, height: 200),
              const SizedBox(height: 16),
              Text(product!.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Rp ${product!.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, color: Colors.purple)),
              const SizedBox(height: 16),
              Text(product!.description),
            ],
          ),
        ),
      ),
    );
  }
}