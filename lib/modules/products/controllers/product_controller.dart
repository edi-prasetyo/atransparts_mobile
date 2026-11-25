import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';

final productListProvider = Provider<List<ProductModel>>((ref) {
  return _dummyProducts;
});

final productDetailProvider = Provider.family<ProductModel?, int>((ref, id) {
  try {
    return _dummyProducts.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
});

final List<ProductModel> _dummyProducts = [
  ProductModel(
    id: 1,
    name: 'Filter Oli Atrans',
    brand: 'Denso',
    category: 'Filter & Oli',
    price: 85000,
    oldPrice: 105000,
    rating: 4.8,
    sold: 124,
    imageUrl: 'https://atransparts.com/uploads/products/17557670391.jpg',
    description:
        'Filter oli Denso dirancang untuk menyaring kotoran dan kontaminan '
        'dalam oli mesin secara optimal. Menggunakan material berkualitas tinggi '
        'yang mampu memperpanjang umur mesin kendaraan Anda.',
    specifications: [
      'Tipe: Filter Oli Putar',
      'Diameter: 76 mm',
      'Tinggi: 85 mm',
      'Material: Kertas filtrasi premium',
      'Kompatibilitas: Mesin bensin & diesel',
    ],
  ),
  ProductModel(
    id: 2,
    name: 'Filter Udara Atrans',
    brand: 'BRT',
    category: 'Sistem Udara',
    price: 185000,
    rating: 4.9,
    sold: 89,
    imageUrl: 'https://atransparts.com/uploads/products/17557686581.jpg',
    description:
        'Air filter BRT memberikan aliran udara maksimal ke mesin untuk '
        'meningkatkan performa dan efisiensi bahan bakar. Cocok untuk '
        'penggunaan harian maupun balap.',
    specifications: [
      'Tipe: Panel Filter',
      'Material: Cotton Gauze',
      'Warna: Merah',
      'Performa: +10% airflow',
      'Perawatan: Dapat dicuci dan digunakan ulang',
    ],
  ),
  ProductModel(
    id: 3,
    name: 'Kampas Rem',
    brand: 'Brembo',
    category: 'Rem',
    price: 420000,
    oldPrice: 465000,
    rating: 4.7,
    sold: 56,
    imageUrl: 'https://atransparts.com/uploads/products/17557673651.jpg',
    description:
        'Brake pad Brembo dengan material ceramic memberikan pengereman '
        'yang halus, minim debu, dan tahan panas. Ideal untuk berkendara '
        'dalam kondisi berat.',
    specifications: [
      'Material: Ceramic',
      'Posisi: Depan',
      'Suhu operasional: hingga 500°C',
      'Debu: Rendah',
      'Garansi: 1 tahun',
    ],
  ),
  ProductModel(
    id: 4,
    name: 'Oli Shell Helix Ultra 5W-40',
    brand: 'Castrol',
    category: 'Oli Mesin',
    price: 310000,
    rating: 4.8,
    sold: 203,
    imageUrl: 'https://atransparts.com/uploads/products/17557682341.jpg',
    description:
        'Castrol Premium Engine Oil 5W-30 adalah oli mesin sintetik '
        'yang memberikan perlindungan maksimal terhadap keausan dan '
        'menjaga kebersihan mesin.',
    specifications: [
      'Viskositas: 5W-30',
      'Tipe: Full Synthetic',
      'Volume: 4 Liter',
      'Standar: API SN / ACEA C3',
      'Interval ganti: 10.000 km',
    ],
  ),
  ProductModel(
    id: 5,
    name: 'Kampas Kopling Atrans',
    brand: 'NGK',
    category: 'Pengapian',
    price: 165000,
    rating: 4.9,
    sold: 176,
    imageUrl: 'https://atransparts.com/uploads/products/17557676911.jpg',
    description:
        'Busi NGK Iridium Racing menghasilkan percikan api yang kuat dan '
        'stabil untuk pembakaran optimal. Performa maksimal untuk mesin '
        'bertenaga tinggi.',
    specifications: [
      'Material: Iridium',
      'Lebar celah: 0.6 mm',
      'Umur pakai: hingga 80.000 km',
      'Resistor: Ya',
      'Tipe: Racing Series',
    ],
  ),
  ProductModel(
    id: 6,
    name: 'Filter AC',
    brand: 'Yuasa',
    category: 'Kelistrikan',
    price: 920000,
    oldPrice: 980000,
    rating: 4.6,
    sold: 72,
    imageUrl: 'https://atransparts.com/uploads/products/17557671851.jpg',
    description:
        'Aki Yuasa MF Premium 12V dengan teknologi maintenance-free '
        'memberikan daya starter yang kuat dan tahan lama. Cocok untuk '
        'berbagai jenis kendaraan.',
    specifications: [
      'Tegangan: 12V',
      'Kapasitas: 60Ah',
      'CCA: 550A',
      'Tipe: Maintenance Free',
      'Berat: 14.5 kg',
    ],
  ),
];
