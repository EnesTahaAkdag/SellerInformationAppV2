import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_layout.dart';
import '../services/seller_api_service.dart';
import '../models/seller_infos_list_model.dart';
// ignore: unused_import
import '../models/seller_infos_detail_model.dart';

class SellerListScreen extends StatefulWidget {
  const SellerListScreen({super.key});

  @override
  State<SellerListScreen> createState() => _SellerListScreenState();
}

class _SellerListScreenState extends State<SellerListScreen> {
  final SellerApiService _apiService = SellerApiService();
  late Future<List<SellerInfosListModel>> _sellersFuture;

  @override
  void initState() {
    super.initState();
    _sellersFuture = _apiService.getSellerList();
  }

  Future<void> _launchURL(BuildContext context, String? url) async {
    if (url == null || url.isEmpty) return;

    try {
      final Uri uri = Uri.parse(url);
      if (!uri.hasScheme) {
        final httpsUrl = 'https://$url';
        final httpsUri = Uri.parse(httpsUrl);
        if (await canLaunchUrl(httpsUri)) {
          await launchUrl(httpsUri, mode: LaunchMode.externalApplication);
          return;
        }
      }

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Link açılamadı')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Geçersiz URL formatı: $e')),
      );
    }
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value,
      {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                isLink && value != 'Belirtilmemiş'
                    ? InkWell(
                        onTap: () => _launchURL(context, value),
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    : Text(
                        value,
                        style: const TextStyle(fontSize: 16),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDetailDialog(BuildContext context, int id) async {
    try {
      final detail = await _apiService.getSellerDetail(id);
      if (!context.mounted) return;

      await showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            detail.storeName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  dialogContext,
                  Icons.person,
                  'Satıcı',
                  detail.sellerName ?? 'Belirtilmemiş',
                ),
                _buildDetailRow(
                  dialogContext,
                  Icons.phone,
                  'Telefon',
                  detail.telephone ?? 'Belirtilmemiş',
                ),
                _buildDetailRow(
                  dialogContext,
                  Icons.email,
                  'E-posta',
                  detail.email ?? 'Belirtilmemiş',
                ),
                _buildDetailRow(
                  dialogContext,
                  Icons.location_on,
                  'Adres',
                  detail.address ?? 'Belirtilmemiş',
                ),
                _buildDetailRow(
                  dialogContext,
                  Icons.link,
                  'Website',
                  detail.link ?? 'Belirtilmemiş',
                  isLink: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Kapat'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Mağaza Listesi',
      currentIndex: 1,
      body: FutureBuilder<List<SellerInfosListModel>>(
        future: _sellersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Mağaza bulunamadı'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final seller = snapshot.data![index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () => _showDetailDialog(context, seller.id),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.purple.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.store,
                            color: Colors.purple.shade400,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                seller.storeName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                seller.telephone?.toString() ??
                                    'Telefon bilgisi yok',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
