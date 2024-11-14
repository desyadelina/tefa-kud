class Pengguna {
  final String namaPengguna;
  final String alamat;

  Pengguna({required this.namaPengguna, required this.alamat});

  factory Pengguna.fromJson(Map<String, dynamic> json) {
    return Pengguna(
      namaPengguna: json['nama_pengguna'],
      alamat: json['alamat'],
    );
  }
}